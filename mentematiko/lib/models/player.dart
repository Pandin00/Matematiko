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
      'cards': cards,
      'order': order
    };
  }

  factory Player.fromFirestore(Map<String, dynamic> data) {
    return Player(
        id: data['id'],
        point: data['point'],
        order: data['order'],
        playing: data['playing'] ?? false,
        cards: data['cards'] ?? List.empty(growable: true));
  }
}
