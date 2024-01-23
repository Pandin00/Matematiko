import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'playing_card.dart';

class PlayingArea {
  /// The maximum number of cards in this playing area.
  static const int maxCards = 6;

  /// The current cards in this area.
  final List<PlayingCard> cards = [];

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  final StreamController<void> _remoteChanges =
      StreamController<void>.broadcast();

  PlayingArea();

  /// A [Stream] that fires an event every time any change to this area is made.
  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream<void> get playerChanges => _playerChanges.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream<void> get remoteChanges => _remoteChanges.stream;

  /// Accepts the [card] into the area.
  void acceptCard(PlayingCard card) {
    cards.add(card);
    _maybeTrim();
    _playerChanges.add(null);
  }

  void dispose() {
    _remoteChanges.close();
    _playerChanges.close();
  }

  /// Replaces the cards in the area with [cards].
  ///
  /// This method is meant to be called when the cards are updated from
  /// a server.
  void replaceWith(List<PlayingCard> cards) {
    this.cards.clear();
    this.cards.addAll(cards);
    _maybeTrim();
    _remoteChanges.add(null);
  }

  void _maybeTrim() {
    if (cards.length > maxCards) {
      cards.removeRange(0, cards.length - maxCards);
    }
  }

  ///show played cards
  void showPlateCard(BuildContext context){
    List<String> cardsToDisplay = ['assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png',
    'assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png', 
    'assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png',
    'assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png',
    'assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png',
    'assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png',
    'assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png',
    'assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png',
    'assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'];// replace this with the actual list of cards to display
  
    int numCards = cardsToDisplay.length;
    int numRows = 2;
    int numCardsPerRow = (numCards / numRows).ceil();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select a Figure'),
          children: [
            // display the cards in each row
            for (int i = 0; i < numRows; i++)
              Wrap(
                children: [
                  for (int j = 0; j < numCardsPerRow; j++)
                    if (i * numCardsPerRow + j < cardsToDisplay.length)
                      Container(
                        child: Image.network(
                          cardsToDisplay[i * numCardsPerRow + j],
                          height: 110,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                ],
              ),
          ],
        );
      },
    );
  }
}
