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
  int maxPlayers;
  int turni; //max numero di turni
  final int _WIN = -100;

  final StreamController<Room> tableController =
      StreamController<Room>.broadcast(); //tavolo

  static final _log = Logger('BoardState');
  /*final StreamController<List<Player>> players =
      StreamController<List<Player>>.broadcast(); //giocatori (ne ho bisogno?) */

  final MatchService matchService;
  Player currentPlayer;

  //Player? winner;

  BoardState(
      {required this.onWin,
      required this.matchService,
      required this.currentPlayer,
      required this.idRoom,
      required this.maxPlayers,
      required this.turni});

  Room? getCurrentRoom() {
    return _currentRoom;
  }

  void listeningOnTable(String idRoom) async {
    _currentRoom =
        await matchService.getRoomById(idRoom); //non può mai essere null
    _log.info("get current room $_currentRoom");
    matchService.getRoomTableInRealTime(idRoom).listen((event) {
      Map<String, dynamic> data = event.data()!; //suppongo ci sia!
      // ignore: prefer_conditional_assignment
      if (event.data() != null) {
        _currentRoom = Room.fromFirestore(data);
        tableController.add(Room.fromFirestore(data));
        if (_currentRoom!.turno == _WIN) {
          onWin.call();
        }
      }
    });
  }

  void listeningOnCurrentPlayer(String idRoom) {
    notifyListeners(); //a priori per evitare il bug del player!
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

  void applyEffects(RulesValidationResult validationResult) async {
    for (var entry in validationResult.validationMap.entries) {
      if (entry.value.verified == false) {
        _log.info("Multa su : ${entry.key}  ${entry.value.toString()} ");
        await matchService.applyMulta(idRoom, currentPlayer, _currentRoom!);
      } else {
        _log.info("Effetti su : ${entry.key}  ${entry.value.toString()} ");
        await _effects(entry);
      }
    }

    //aggiorno che non sto giocando più -> timer lancierà chageturn
    currentPlayer.playing = false;
    await matchService.updatePlayer(idRoom, currentPlayer);
    //aggiorna i listeners
    notifyListeners();
  }

  Future<void> _effects(MapEntry<String, Validation> entry) async {
    switch (entry.key) {
      case Rules.LISCIA:
        await matchService.updateRoomAndPlayer(
            idRoom, currentPlayer, _currentRoom!);
        break;
      case Rules.SPECULARE:
        await matchService.speculare(idRoom, currentPlayer, _currentRoom!);
        break;
      case Rules.DIVISIBILE:
        await matchService.effettoDivisore(
            currentPlayer, _currentRoom!, idRoom, entry.value.result);
        break;
      case Rules.MULTIPLO:
        await matchService.effettoMultiplo(
            idRoom, currentPlayer, _currentRoom!);
        break;
      case Rules.PRIMO:
        await matchService.effettoPrimo(
            idRoom, currentPlayer, _currentRoom!, maxPlayers);
        break;
      case Rules.ZERO:
        await matchService.effettoZero(idRoom, _currentRoom!);
        break;
      case Rules.EULER_DIVERSO:
        await matchService.effettoEulero(idRoom, currentPlayer, _currentRoom!);
        break;
      case Rules.QUADRATO:
        await matchService.effettoQuadrato(idRoom, currentPlayer, _currentRoom);
        break;
      case Rules.CUBO:
        await matchService.effettoCubo(
            idRoom, currentPlayer, _currentRoom, entry.value.dice, maxPlayers);
        break;
      case Rules.PERFETTO:
        await matchService.effettoNumeroPerfetto(
            idRoom, currentPlayer, _currentRoom!, entry.value.result);
        break;
      case Rules.COMPLEMENTARE:
        await matchService.effettoComplementare(
            idRoom, currentPlayer, _currentRoom!);
        break;
      case Rules.MCM:
        await matchService.effettoEulero(idRoom, currentPlayer, _currentRoom!);
        break;
      case Rules.MCD:
        await matchService.effettoMcd(
            idRoom, currentPlayer, _currentRoom!, maxPlayers);
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    tableController.close();
  }

  void changeTurn(String idRoom) async {
    //servizio che per ogni player aggiorna i punti
    await matchService.updatePoints(idRoom);
    //servizio che verifica se c'è un vincitore
    await matchService.winningConditions(
        idRoom, _currentRoom!, maxPlayers, turni);
    //se non c'è un vincitore a fine turno vai avanti
    if (_currentRoom!.turno != -100) {
      await matchService.updateNextPlayerByCurrentPlayer(
          idRoom, _currentRoom!.numberOfPlayers, currentPlayer, _currentRoom!);
    }
  }

  Future<Player> getWinnerPlayer() async {
    return await matchService.searchWinnerPlayer(idRoom);
  }
}
