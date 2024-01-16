import 'dart:convert';
import 'dart:js_interop';
import 'package:card/models/user.dart';
import 'package:card/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder(
        stream: _userService.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              
              Map<String, dynamic> data =document.data() as Map<String,dynamic>;
              User u=User.fromFirestore(data);
              return ListTile(
                title: Text(u.nome),
                subtitle: Text(u.role),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _userService.deleteUser(document.id);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
