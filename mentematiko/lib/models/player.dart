import 'package:card/models/Room.dart';
import 'package:card/models/playable_cards.dart';
import 'package:card/models/rules_validation_result.dart';
import 'package:card/services/rules_service.dart';
import 'package:flutter/foundation.dart';

class Player extends ChangeNotifier {
  String id;
  int point = 0;
  int order = 0; //ordine di gioco -> 0 arbitro
  bool playing = false;
  //lista di oggetto cards (?)
  List<PlayableCards>? cards; //mazzo di carte in mano al giocatore

  int? untouchable = -1; //non attaccabile x n° turni
  int? random = -1; //gioca random card mandatory

  Player({
    this.untouchable,
    this.random,
    required this.id,
    required this.point,
    required this.order,
    required this.playing,
    this.cards,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'point': point,
      'playing': playing,
      'cards': cards?.map((e) => e.value.toString()).toList() ?? [],
      'order': order,
      'untouchable': untouchable,
      'random': random,
    };
  }

  factory Player.fromFirestore(Map<String, dynamic> data) {
    return Player(
        id: data['id'],
        point: data['point'],
        order: data['order'],
        playing: data['playing'] ?? false,
        cards: data['cards'] != null
            ? _convertToPlayable(data['cards'])
            : List.empty(growable: true),
        untouchable: data['untouchable'] ?? -1,
        random: data['random'] ?? -1);
  }

  static List<PlayableCards> _convertToPlayable(List<dynamic> dynamicList) {
    List<PlayableCards> list = dynamicList
        .map<PlayableCards>((dynamic element) {
          if (int.tryParse(element) != null) {
            if (element == 0 || element == 1) {
              return PlayableCards(element.toString(), 'E');
            }
            return PlayableCards(element.toString(), 'N');
          } else if (element is String) {
            if (PlayableCards.checkIfIsEulero(element)) {
              return PlayableCards(element.toString(), 'E');
            }
            //else if nerd-card (non presenti più)
          }
          return PlayableCards('', ''); //null playable
        })
        .where((element) => element != PlayableCards.nullCard)
        .toList();

    return list;
  }

  String getDocumentId() {
    return id.split('§').length > 1 ? id.split('§')[0] : 'ARB';
  }

  bool haveEuleroCombo() {
    List<String> eu = ['pi', '1', '0', 'i', 'e'];
    List<String> cardLocal = cards!.map((e) => e.toString()).toList();
    return eu.every((element) => cardLocal.contains(element));
  }

  void calculatePoints() {
    int points = 0;
    if (cards != null && cards!.isNotEmpty) {
      for (var element in cards!) {
        switch (element.value) {
          case 'e':
          case 'i':
          case 'pi':
          case '0':
          case '1':
            points += 1000;
            break;
          case '2':
            points += 800;
            break;
          case '3':
            points += 700;
            break;
          case '4':
            points += 100;
            break;
          case '5':
            points += 500;
            break;
          case '6':
            points += 10;
            break;
          case '7':
            points += 300;
            break;
          case '8':
            points += 30;
            break;
          case '9':
            points += 100;
            break;
          case '10':
            points += 10;
            break;
          case '11':
            points += 250;
            break;
          case '12':
            points += 20;
            break;
          case '13':
            points += 250;
            break;
          case '14':
            points += 10;
            break;
          case '15':
            points += 10;
            break;
          case '16':
            points += 100;
            break;
          case '17':
            points += 250;
            break;
          case '18':
            points += 10;
            break;
          case '19':
            points += 250;
            break;
          case '20':
            points += 20;
            break;
          case '21':
            points += 10;
            break;
          case '22':
            points += 10;
            break;
          case '23':
            points += 225;
            break;
          case '24':
            points += 30;
            break;
          case '25':
            points += 100;
            break;
          case '26':
            points += 10;
            break;
          case '27':
            points += 10;
            break;
          case '28':
            points += 20;
            break;
          case '29':
            points += 225;
            break;
          case '30':
            points += 10;
            break;
          case '31':
            points += 200;
            break;
          case '32':
            points += 50;
            break;
          case '33':
            points += 10;
            break;
          case '34':
            points += 10;
            break;
          case '35':
            points += 20;
            break;
          case '36':
            points += 100;
            break;
          case '37':
            points += 200;
            break;
          case '38':
            points += 10;
            break;
          case '39':
            points += 10;
            break;
          case '40':
            points += 30;
            break;
          case '41':
            points += 175;
            break;
          case '42':
            points += 10;
            break;
          case '43':
            points += 175;
            break;
          case '44':
            points += 20;
            break;
          case '45':
            points += 10;
            break;
          case '46':
            points += 10;
            break;
          case '47':
            points += 175;
            break;
          case '48':
            points += 40;
            break;
          case '49':
            points += 100;
            break;
          case '50':
            points += 10;
            break;
        }
        point = points;
      }
    }
  }

  RulesValidationResult playCard(
      PlayableCards played, List<String> choice, Room room) {
    PlayableCards? deck = cards?.firstWhere((element) => element == played,
        orElse: () => PlayableCards.nullCard);
    cards?.remove(deck);

    Rules rules = Rules(
        currentPlayer: this,
        azioniAllaFineDelPopup: choice,
        tavolo: room,
        playedCard: played);
    return rules.eseguiRegoleDelGioco();

    //esegue le validazioni & aggiorna i punti localmente
  }
}
