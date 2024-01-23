import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/playing_area.dart';
import '../game_internals/playing_card.dart';
import '../style/palette.dart';
import 'playing_card_widget.dart';

class PlayingAreaWidget extends StatefulWidget {
  final PlayingArea area;

  const PlayingAreaWidget(this.area, {super.key});

  @override
  State<PlayingAreaWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {
  bool isHighlighted = false;

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
                      stream: widget.area.allChanges,
                      builder: (context, child) => _CardStack(widget.area.cards),
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
    widget.area.showPlateCard(context);

    final audioController = context.read<AudioController>();
    //TODO cambiare con un suono migliore
    audioController.playSfx(SfxType.huhsh);
  }

  void _onDragAccept(PlayingCardDragData data) {
    bool? flagWarranty=false;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> selections = [];
        return SimpleDialog(
          title: Text('Seleziona una o più azioni'),
          children: [
             StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: [
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
                    ]
                  );
                }
              ),
              ElevatedButton(
                onPressed: () {
                  //TODO aggiungere regole
                  widget.area.acceptCard(data.card);
                  data.holder.removeCard(data.card);
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
}

class _CardStack extends StatelessWidget {
  static const int _maxCards = 6;

  static const _leftOffset = 10.0;

  static const _topOffset = 5.0;

  static const double _maxWidth =
      _maxCards * _leftOffset + PlayingCardWidget.width;

  static const _maxHeight = _maxCards * _topOffset + PlayingCardWidget.height;

  final List<PlayingCard> cards;

  const _CardStack(this.cards);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = max(0, cards.length - _maxCards);
                i < cards.length;
                i++)
              Positioned(
                top: i * _topOffset,
                left: i * _leftOffset,
                child: PlayingCardWidget(cards[i]),
              ),
          ],
        ),
      ),
    );
  }
}
