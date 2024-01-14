import 'package:card/models/user.dart';
import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LobbyPage extends StatefulWidget {
  User? user;

  LobbyPage({super.key, this.user});
  
 @override
 _LobbyPageState createState() => _LobbyPageState(user: this.user);
}

class _LobbyPageState extends State<LobbyPage> {
  User? user;

  _LobbyPageState({this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Attendo giocatori',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(),
            MyButton(
            onPressed: () async {
              // Check if the game code exists and go to /play if it does
              GoRouter.of(context).go('/play', extra: user);
            },
            child: Text('Entra in partita'),
          ),
          ],
        ),
      ),
    );
  }
}