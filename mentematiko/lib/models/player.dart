import 'package:card/models/playable_cards.dart';
import 'package:flutter/foundation.dart';

class Player extends ChangeNotifier {
  String id;
  int point = 0;
  int order = 0; //ordine di gioco -> 0 arbitro
  bool playing = false;

  //lista di oggetto cards (?)
  List<PlayableCards>? cards; //mazzo di carte in mano al giocatore

  Player({
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
      'order': order
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
            : List.empty(growable: true));
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


  List<String> playCard(PlayableCards played,List<String> choice){
    PlayableCards? deck=cards?.firstWhere((element) => element==played, orElse: ()=> PlayableCards.nullCard);  
    cards?.remove(deck);
    //esegue le validazioni & aggiorna i punti localmente
  

    return List.empty();
  }
}
