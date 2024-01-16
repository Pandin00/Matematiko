import 'package:card/models/player.dart';
import 'package:card/models/user.dart';
import 'package:card/services/match_service.dart';
import 'package:card/settings/settings.dart';
import 'package:card/style/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LobbyPage extends StatefulWidget {
  User user;
  MatchService matchService;
  SettingsController sharedController;

  LobbyPage(
      {super.key,
      required this.user,
      required this.matchService,
      required this.sharedController});

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  String? roomCode;
  int? playerSize;

  _LobbyPageState();
  @override
  Widget build(BuildContext context) {
    roomCode = widget.sharedController.getRoomCode();
    playerSize= widget.sharedController.getMaxPlayer();
    return Scaffold(
        appBar: AppBar(
          title: Text('Lobby'),
        ),
        body: StreamBuilder(
            stream:
                widget.matchService.getPlayerInRealTime(roomCode ?? 'wrong'),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            Player p = Player.fromFirestore(data);
                            return ListTile(
                              title: Text(p.id.split("§")[1]),
                              subtitle: Text(p.id.split("§")[0]),
                            );
                          }).toList(),
                        )),
                        SizedBox(height: 30),
                        Visibility(
                            visible: widget.user.role == 'ARB',
                            child: MyButton(child: Text('Start Game'), onPressed: () => {
                                   if((snapshot.data!.docs.length-1)==playerSize){
                                        
                                        GoRouter.of(context).go('/play', extra: widget.user)
                                   }

                            } ,))
                      ]));

              //parte grafica
            }));
  }
}
