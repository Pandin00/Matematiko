import 'package:audioplayers/audioplayers.dart';
import 'package:card/models/playable_cards.dart';
import 'package:card/models/player.dart';
import 'package:card/models/Room.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PlayingCardWidget extends StatelessWidget {
  static const double width = 61;
  static const double height = 101.9;
  static final _log = Logger('PlayingCardWidget');
  final PlayableCards card;
  final Player? player;
  final Room? room;

  const PlayingCardWidget(this.card, {this.player, this.room, super.key});

  @override
  Widget build(BuildContext context) {
    AudioPlayer _audioPlayer = AudioPlayer();

    final cardWidget = Image.asset(
      card.rendering(),
      width: width,
      height: height,
      fit: BoxFit.cover,
    );

    if (player == null || room == null) {
      _log.info("CardWidget con player o room null");
      return cardWidget;
    }

    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: cardWidget,
      ),
      data: PlayingCardDragData(card, player!, room!),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: cardWidget,
      ),
      onDragStarted: () async {
        await _audioPlayer.play(AssetSource('music/flipcard.mp3'));
      },
      onDragEnd: (details) async {
        await _audioPlayer.play(AssetSource('music/flipcard.mp3'));
      },
      child: cardWidget,
    );
  }
}

@immutable
class PlayingCardDragData {
  final PlayableCards card;

  final Player holder;

  final Room room;

  const PlayingCardDragData(this.card, this.holder, this.room);
}
