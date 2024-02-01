import 'dart:async';

import 'package:card/models/Room.dart';
import 'package:card/models/player.dart';
import 'package:card/models/rules_validation_result.dart';
import 'package:card/services/match_service.dart';
import 'package:card/services/rules_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class BoardState extends ChangeNotifier {
  final VoidCallback onWin; //check condizione di vittoria
  //final VoidCallback timeEnd; //ogni volta che il timer scade + verifica vittoria

  Room? _currentRoom;
  String idRoom;

  final StreamController<Room> tableController =
      StreamController<Room>.broadcast(); //tavolo

  static final _log = Logger('BoardState');
  /*final StreamController<List<Player>> players =
      StreamController<List<Player>>.broadcast(); //giocatori (ne ho bisogno?) */

  final MatchService matchService;
  Player currentPlayer;

  BoardState(
      {required this.onWin,
      required this.matchService,
      required this.currentPlayer,
      required this.idRoom}) {
    currentPlayer.addListener(_handlePlayed);
  }

  Room getCurrentRoom() {
    return _currentRoom!; // da rivedere
  }

  void listeningOnTable(String idRoom) {
    matchService.getRoomTableInRealTime(idRoom).listen((event) {
      Map<String, dynamic> data = event.data()!; //suppongo ci sia!
      // ignore: prefer_conditional_assignment
      if (_currentRoom == null) {
        _currentRoom = Room.fromFirestore(data);
      }
      tableController.add(Room.fromFirestore(data));
    });
  }

  void listeningOnCurrentPlayer(String idRoom) {
    matchService
        .getPlayerInRealTime(idRoom, currentPlayer.id.split('§')[0])
        .listen((event) {
      if (event.data() != null) {
        currentPlayer = Player.fromFirestore(event.data()!);
        _log.info('Player ${currentPlayer.id.split("§")[0]} aggiornato!');
        notifyListeners();
      }
    });
  }

  void applyEffects(RulesValidationResult validationResult) {
    for (var entry in validationResult.validationMap.entries) {
      if (entry.value.verified == false) {
        _log.info("Multa su : ${entry.key}  ${entry.value.toString()} ");
        matchService.applyMulta(idRoom, currentPlayer, _currentRoom!);
      } else {
        _log.info("Effetti su : ${entry.key}  ${entry.value.toString()} ");
        _effects(entry);
        
      }
    }
  }


  void _effects(MapEntry<String,Validation> entry){
    switch(entry.key){
       case Rules.LISCIA:
             matchService.updateRoomAndPlayer(idRoom, currentPlayer, _currentRoom!);
             break;
       case Rules.SPECULARE:
             matchService.speculare(idRoom, currentPlayer, _currentRoom!);
             break;

    }

  }

  //List<PlayingArea> get areas => [areaOne];

  void dispose() {
    currentPlayer.removeListener(_handlePlayed);
    tableController.close();
  }

  void _handlePlayed() {
    //passa al turno successivo & aggiorna sul db
  }

  void changeTurn(String idRoom) {
    matchService.updateNextPlayerByCurrentPlayer(
        idRoom, _currentRoom!.numberOfPlayers, currentPlayer);
  }
}
