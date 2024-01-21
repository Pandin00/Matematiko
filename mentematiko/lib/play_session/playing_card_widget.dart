import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';

class PlayingCardImage {
  final String imagePath;

  const PlayingCardImage(this.imagePath);
}

final List<PlayingCardImage> cardImages = [
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),
  PlayingCardImage('assets/cards/carteNumerike/CARTA NUMERIKA 002 - REGINA.png'),

  // Add the rest of the card images here...
];

class PlayingCardWidget extends StatelessWidget {
  static const double width = 61;
  static const double height = 101.9;

  final PlayingCard card;
  final Player? player;

  const PlayingCardWidget(this.card, {this.player, super.key});

  @override
  Widget build(BuildContext context) {
    
    final cardWidget = Image.network(
      cardImages[0].imagePath,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );

    if (player == null) return cardWidget;

    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: cardWidget,
      ),
      data: PlayingCardDragData(card, player!),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: cardWidget,
      ),
      onDragStarted: () {
        final audioController = context.read<AudioController>();
        //TODO cambiare con un suono migliore
        audioController.playSfx(SfxType.huhsh);
      },
      onDragEnd: (details) {
        final audioController = context.read<AudioController>();
        //TODO cambiare con un suono migliore
        audioController.playSfx(SfxType.wssh);
      },
      child: cardWidget,
    );
  }
}

@immutable
class PlayingCardDragData {
  final PlayingCard card;

  final Player holder;

  const PlayingCardDragData(this.card, this.holder);
}
