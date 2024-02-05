import 'dart:async';
import 'dart:math';

import 'package:card/game_internals/board_state.dart';
import 'package:card/main_menu/popup_util.dart';
import 'package:card/models/Room.dart';
import 'package:card/models/playable_cards.dart';
import 'package:card/models/player.dart';
import 'package:card/models/rules_validation_result.dart';
import 'package:card/services/rules_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                      return _CardStack(snapshot.data?.piatto,
                          widget._boardState.getCurrentRoom());
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
                  value: (selections.contains(Rules.DIVISIBILE)),
                  title: Text('Divisore'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.DIVISIBILE);
                        } else {
                          selections.remove(Rules.DIVISIBILE);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.MULTIPLO)),
                  title: Text('Multiplo'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.MULTIPLO);
                        } else {
                          selections.remove(Rules.MULTIPLO);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.SPECULARE)),
                  title: Text('Speculare'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.SPECULARE);
                        } else {
                          selections.remove(Rules.SPECULARE);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.PRIMO)),
                  title: Text('Numero primo'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.PRIMO);
                        } else {
                          selections.remove(Rules.PRIMO);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.ZERO)),
                  title: Text('0'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.ZERO);
                        } else {
                          selections.remove(Rules.ZERO);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.EULER_DIVERSO)),
                  title: Text('EC != 0'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.EULER_DIVERSO);
                        } else {
                          selections.remove(Rules.EULER_DIVERSO);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.QUADRATO)),
                  title: Text('Quadrato'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.QUADRATO);
                        } else {
                          selections.remove(Rules.QUADRATO);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.PERFETTO)),
                  title: Text('Perfetto'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.PERFETTO);
                        } else {
                          selections.remove(Rules.PERFETTO);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.COMPLEMENTARE)),
                  title: Text('Complementare'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.COMPLEMENTARE);
                        } else {
                          selections.remove(Rules.COMPLEMENTARE);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.CUBO)),
                  title: Text('Cubo'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.CUBO);
                        } else {
                          selections.remove(Rules.CUBO);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.MCM)),
                  title: Text('m.c.m.'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.MCM);
                        } else {
                          selections.remove(Rules.MCM);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.MCD)),
                  title: Text('M.C.D.'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.MCD);
                        } else {
                          selections.remove(Rules.MCD);
                        }
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  tristate: false,
                  value: (selections.contains(Rules.LISCIA)),
                  title: Text('Liscia'),
                  onChanged: (value) {
                    setState(() {
                      flagWarranty = value;
                      if (value != null) {
                        if (value) {
                          selections.add(Rules.LISCIA);
                        } else {
                          selections.remove(Rules.LISCIA);
                        }
                      }
                    });
                  },
                ),
              ]);
            }),
            ElevatedButton(
              onPressed: () {
                if (widget._boardState.currentPlayer.playing) {
                  //aggiorna localmente e ritorna le azioni/errori
                  RulesValidationResult result = data.holder.playCard(data.card,
                      selections, widget._boardState.getCurrentRoom()!);
                  widget._boardState.applyEffects(result);
                }
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
    //sotto l'effetto di cubo (rule10)
    if (data.holder.random != -1 ){
       Player p=data.holder;
       if(p.cards![p.random!]!=data.card){
         //obbligo di gioco
         PopupUtil.showPopup(context: context, title: 'Obbligo causa CUBO', content: 'Sei obbligato a giocare la carta ${p.cards![p.random!].value}');
         return false;
       }
      return true;
    }
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
                        child: Image.asset(
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

  Room? currentRoom;

  _CardStack(List<String>? plateCards, Room? room) {
    cards = plateCards != null
        ? plateCards
            .map((e) => PlayableCards.buildFromValue(e))
            .toList()
            .reversed
            .toList()
        : List.empty();
    currentRoom = room;
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
                child: PlayingCardWidget(
                  cards![i],
                  room: currentRoom,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
