import 'package:flutter/material.dart';

import '../game_internals/board_state.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatelessWidget {

  final BoardState boardState;
  const PlayerHandWidget({super.key,required this.boardState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: PlayingCardWidget.height),
        child: ListenableBuilder(
          // Make sure we rebuild every time there's an update
          // to the player's hand.
          listenable: boardState,
          builder: (context, child) {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ...boardState.currentPlayer.cards!.map((card) =>
                    PlayingCardWidget(card, player: boardState.currentPlayer)),
              ],
            );
          },
        ),
      ),
    );
  }
}
