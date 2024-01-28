import 'package:card/models/playable_cards.dart';
import 'package:card/models/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

class PlayingCardWidget extends StatelessWidget {
  static const double width = 61;
  static const double height = 101.9;

  final PlayableCards card;
  final Player? player;

  const PlayingCardWidget(this.card, {this.player, super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidget = Image.network(
      card.rendering(),
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
  final PlayableCards card;

  final Player holder;

  const PlayingCardDragData(this.card, this.holder);
}
