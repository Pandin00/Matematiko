import 'dart:async';

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
  final StreamController<QuerySnapshot> _streamController =
      StreamController<QuerySnapshot>.broadcast();

  LobbyPage(
      {super.key,
      required this.user,
      required this.matchService,
      required this.sharedController});

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  String? idRoom;
  int? playerSize;

  _LobbyPageState();
  @override
  Widget build(BuildContext context) {
    idRoom = widget.sharedController.getRoomCode();
    playerSize = widget.sharedController.getMaxPlayer();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      body: StreamBuilder(
        stream: widget.matchService.getPlayerInRealTime(idRoom ?? 'wrong'),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError ||
              !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (isStarted(snapshot)) {
              GoRouter.of(context).go('/play', extra: widget.user);
            }

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        Player p = Player.fromFirestore(data);
                        return ListTile(
                          title: Text(p.id.split("§")[1]),
                          subtitle: Text(p.id.split("§")[0]),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 30),
                  Visibility(
                    visible: widget.user.role == 'ARB',
                    child: MyButton(
                      child: Text('Start Game'),
                      onPressed: () {
                        if ((snapshot.data!.docs.length - 1) == playerSize) {
                          widget.matchService.distributeCards(idRoom!)
                          .whenComplete(() async => await widget.matchService.updateNextPlayer(idRoom!, playerSize!, widget.user)
                          .whenComplete(() => GoRouter.of(context).go('/play', extra: widget.user)) 
                          );
                          
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  bool isStarted(AsyncSnapshot<QuerySnapshot> snapshot) {
    //e un player ha order=true
    if ((snapshot.data!.docs.length - 1) == playerSize) {
      return false;
    }

    return false;
  }
}
