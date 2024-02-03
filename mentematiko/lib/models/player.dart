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
