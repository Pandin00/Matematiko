import 'dart:async';
import 'dart:math';

import 'package:card/game_internals/board_state.dart';
import 'package:card/models/Room.dart';
import 'package:card/models/playable_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../style/palette.dart';
import 'playing_card_widget.dart';

class PlayingAreaWidget extends StatefulWidget {
  late StreamController<Room> table;
  final BoardState _boardState;

  PlayingAreaWidget(this._boardState, {super.key}) {
    table = _boardState.tableController;
  }

  @override
  State<PlayingAreaWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {
  bool isHighlighted = false;
  List<PlayableCards>? tableCards;
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return LimitedBox(
      maxHeight: 200,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: DragTarget<PlayingCardDragData>(
          builder: (context, candidateData, rejectedData) => SizedBox(
            height: 100,
            child: Material(
              color: isHighlighted ? palette.accept : palette.trueWhite,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: palette.redPen,
                onTap: _onAreaTap,
                child: StreamBuilder(
                  // Rebuild the card stack whenever the area changes
                  // (either by a player action, or remotely).
                  stream: widget.table.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        !snapshot.hasError &&
                        snapshot.hasData) {
                      tableCards = snapshot.data?.piatto
                          ?.map((e) => PlayableCards.buildFromValue(e))
                          .toList();
                      return _CardStack(snapshot.data?.piatto);
                    } else {
                      // Return a placeholder or loading indicator if needed
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
          onWillAccept: _onDragWillAccept,
          onLeave: _onDragLeave,
          onAccept: _onDragAccept,
        ),
      ),
    );
  }

  void _onAreaTap() {
    showPlateCard(context, tableCards!);
    final audioController = context.read<AudioController>();
    //TODO cambiare con un suono migliore
    audioController.playSfx(SfxType.huhsh);
  }

  void _onDragAccept(PlayingCardDragData data) {
    bool? flagWarranty = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> selections = [];
        return SimpleDialog(
          title: Text('Seleziona una o più azioni'),
          children: [
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(children: [
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Divisore')),
                  title: Text('Divisore'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Divisore');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Multiplo')),
                  title: Text('Multiplo'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Multiplo');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Speculare')),
                  title: Text('Speculare'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Speculare');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Numero primo')),
                  title: Text('Numero primo'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Numero primo');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('0')),
                  title: Text('0'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('0');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('EC != 0')),
                  title: Text('EC != 0'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('EC != 0');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Quadrato')),
                  title: Text('Quadrato'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Quadrato');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Perfetto')),
                  title: Text('Perfetto'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Perfetto');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Complementare')),
                  title: Text('Complementare'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Complementare');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Cubo')),
                  title: Text('Cubo'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Cubo');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('m.c.m.')),
                  title: Text('m.c.m.'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('m.c.m.');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('M.C.D.')),
                  title: Text('M.C.D.'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('M.C.D.');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains('Liscia')),
                  title: Text('Liscia'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        selections.add('Liscia');
                      }
                    });
                  },
                ),
              ]);
            }),
            ElevatedButton(
              onPressed: () {
                //aggiorna localmente e ritorna le azioni/errori
                List<String> effects =
                    data.holder.playCard(data.card, selections);

                //chiama board_start per eseguire gli effetti e le operazioni su db

                Navigator.pop(context);
              },
              child: Text('Sottometti'),
            ),
          ],
        );
      },
    );
    setState(() => isHighlighted = false);
  }

  void _onDragLeave(PlayingCardDragData? data) {
    setState(() => isHighlighted = false);
  }

  bool _onDragWillAccept(PlayingCardDragData? data) {
    if (data == null) return false;
    setState(() => isHighlighted = true);
    return true;
  }

  ///show played cards
  void showPlateCard(BuildContext context, List<PlayableCards> cards) {
    int numRows = 2;
    int numCardsPerRow = (cards.length / numRows).ceil();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Carte'),
          children: [
            // display the cards in each row
            for (int i = 0; i < numRows; i++)
              Wrap(
                children: [
                  for (int j = 0; j < numCardsPerRow; j++)
                    if (i * numCardsPerRow + j < cards.length)
                      Container(
                        child: Image.network(
                          cards[i * numCardsPerRow + j].rendering(),
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

class _CardStack extends StatelessWidget {
  static const int _maxCards = 6;

  static const _leftOffset = 10.0;

  static const _topOffset = 5.0;

  static const double _maxWidth =
      _maxCards * _leftOffset + PlayingCardWidget.width;

  static const _maxHeight = _maxCards * _topOffset + PlayingCardWidget.height;

  List<PlayableCards>? cards;

  _CardStack(List<String>? plateCards) {
    cards = plateCards != null
        ? plateCards
            .map((e) => PlayableCards.buildFromValue(e))
            .toList()
            .reversed
            .toList()
        : List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = max(0, cards!.length - _maxCards);
                i < cards!.length;
                i++)
              Positioned(
                top: i * _topOffset,
                left: i * _leftOffset,
                child: PlayingCardWidget(cards![i]),
              ),
          ],
        ),
      ),
    );
  }
}
