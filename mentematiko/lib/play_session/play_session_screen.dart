// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:card/models/player.dart';
import 'package:card/play_session/dice_widget.dart';
import 'package:card/play_session/opponent_widget.dart';
import 'package:card/play_session/player_hand_widget.dart';
import 'package:card/services/match_service.dart';
import 'package:card/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/board_state.dart';
import '../style/palette.dart';
import 'board_widget.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class PlaySessionScreen extends StatefulWidget {
  Player? currentPlayer;
  final SettingsController sharedController;
  final MatchService matchService;
  PlaySessionScreen(
      {super.key,
      this.currentPlayer,
      required this.sharedController,
      required this.matchService});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');
  int numberOfPlayers = 2;
  String? idRoom;
  late int time;

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late final BoardState _boardState;
  late bool _timerExpired;

  List<int> orders = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    switch (numberOfPlayers) {
      case > 4:
        return IgnorePointer(
          ignoring: _duringCelebration,
          child: Scaffold(
            backgroundColor: palette.backgroundPlaySession,
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Schermo grande, utilizza un layout diverso
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListenableBuilder(
                            listenable: _boardState,
                            builder: (context, child) {
                              return CountdownTimer(
                                currentPlayer: _boardState.currentPlayer,
                                duration: time,
                                onTimerExpired: timerExpired,
                              );
                            }),
                      ],
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: numberOfPlayers - 3,
                        children: [
                          for (int i = 0; i < numberOfPlayers - 3; i++)
                            OpponentWidget(
                                matchService: widget.matchService,
                                idRoom: idRoom!,
                                order: orders[i]),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: [
                          OpponentWidget(
                              matchService: widget.matchService,
                              idRoom: idRoom!,
                              order: orders[numberOfPlayers - 3]),
                          BoardWidget(boardState: _boardState),
                          OpponentWidget(
                              matchService: widget.matchService,
                              idRoom: idRoom!,
                              order: orders[numberOfPlayers - 2]),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: DiceWidget(),
                    ),
                    IgnorePointer(
                      // quando il tempo arriva a 0 la mano non è cliccabile
                      ignoring: _timerExpired,
                      child: PlayerHandWidget(boardState: _boardState),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      case 2:
      case 1:
        return IgnorePointer(
          ignoring: _duringCelebration,
          child: Scaffold(
            backgroundColor: palette.backgroundPlaySession,
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Schermo grande, utilizza un layout diverso
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListenableBuilder(
                            listenable: _boardState,
                            builder: (context, child) {
                              return CountdownTimer(
                                currentPlayer: _boardState.currentPlayer,
                                duration: time,
                                onTimerExpired: timerExpired,
                              );
                            }),
                      ],
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 1,
                        children: [
                          OpponentWidget(
                              matchService: widget.matchService,
                              idRoom: idRoom!,
                              order: orders[0]),
                        ],
                      ),
                    ),
                    Center(
                      child: BoardWidget(boardState: _boardState),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: DiceWidget(),
                    ),
                    IgnorePointer(
                      // quando il tempo arriva a 0 la mano non è cliccabile
                      ignoring: _timerExpired,
                      child: PlayerHandWidget(boardState: _boardState),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      case 3:
        return IgnorePointer(
          ignoring: _duringCelebration,
          child: Scaffold(
            backgroundColor: palette.backgroundPlaySession,
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Schermo grande, utilizza un layout diverso
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListenableBuilder(
                            listenable: _boardState,
                            builder: (context, child) {
                              return CountdownTimer(
                                currentPlayer: _boardState.currentPlayer,
                                duration: time,
                                onTimerExpired: timerExpired,
                              );
                            }),
                      ],
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          OpponentWidget(
                              matchService: widget.matchService,
                              idRoom: idRoom!,
                              order: orders[0]),
                          OpponentWidget(
                              matchService: widget.matchService,
                              idRoom: idRoom!,
                              order: orders[1]),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: BoardWidget(boardState: _boardState),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: DiceWidget(),
                    ),
                    IgnorePointer(
                      // quando il tempo arriva a 0 la mano non è cliccabile
                      ignoring: _timerExpired,
                      child: PlayerHandWidget(boardState: _boardState),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      case 4:
        return IgnorePointer(
          ignoring: _duringCelebration,
          child: Scaffold(
            backgroundColor: palette.backgroundPlaySession,
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Schermo grande, utilizza un layout diverso
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListenableBuilder(
                            listenable: _boardState,
                            builder: (context, child) {
                              return CountdownTimer(
                                currentPlayer: _boardState.currentPlayer,
                                duration: time,
                                onTimerExpired: timerExpired,
                              );
                            }),
                      ],
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: [
                          OpponentWidget(
                              matchService: widget.matchService,
                              idRoom: idRoom!,
                              order: orders[0]),
                          OpponentWidget(
                              matchService: widget.matchService,
                              idRoom: idRoom!,
                              order: orders[1]),
                          OpponentWidget(
                              matchService: widget.matchService,
                              idRoom: idRoom!,
                              order: orders[2]),
                        ],
                      ),
                    ),
                    BoardWidget(boardState: _boardState),
                    Container(
                      height: 100,
                      width: 100,
                      child: DiceWidget(),
                    ),
                    SizedBox(height: 10),
                    IgnorePointer(
                      // quando il tempo arriva a 0 la mano non è cliccabile
                      ignoring: _timerExpired,
                      child: PlayerHandWidget(boardState: _boardState),
                    ),
                  ],
                );
              },
            ),
          ),
        );
    }
    // Return a widget if numberOfPlayers is not matched
    return SizedBox.shrink();
  }

  @override
  void dispose() {
    _boardState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    numberOfPlayers = widget.sharedController.getMaxPlayer();
    idRoom = widget.sharedController.getRoomCode();
    time = widget.sharedController.getTimePerTurn();
    //calculate orders for opponent
    for (int i = 0; i < numberOfPlayers; ++i) {
      orders.add(i + 1);
    }
    orders.remove(widget.currentPlayer?.order);

    _startOfPlay = DateTime.now();
    _boardState = BoardState(
        onWin: _playerWon,
        matchService: widget.matchService,
        currentPlayer: widget.currentPlayer!,
        idRoom: idRoom!,
        maxPlayers: numberOfPlayers);
    _boardState.listeningOnTable(idRoom!);
    _boardState.listeningOnCurrentPlayer(idRoom!);
    _timerExpired=!_boardState.currentPlayer.playing;
  }

  void timerExpired(bool value) {
    if (value != _timerExpired) {
      setState(() {
        _timerExpired = value; //se true disattiva
      });
      if (value) {
        _boardState.changeTurn(idRoom!);
      }
    }
  }

  Future<void> _playerWon() async {
    _log.info('Player won');

    // TODO: replace with some meaningful score for the card game

    // final playerProgress = context.read<PlayerProgress>();
    // playerProgress.setLevelReached(widget.level.number);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    //GoRouter.of(context).go('/play/won', extra: {'score': score});
  }

  static SizedBox getGapHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    var padding;
    if (screenHeight > 780) {
      padding = mediaQuery.size.width * 0.19;
    } else {
      padding = mediaQuery.size.width * 0.08;
    }

    return SizedBox(height: padding);
  }
}

class CountdownTimer extends StatefulWidget {
  final int duration;
  final ValueChanged<bool> onTimerExpired;
  final Player currentPlayer;

  const CountdownTimer(
      {super.key,
      required this.duration,
      required this.onTimerExpired,
      required this.currentPlayer});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  int _remainingTime = 0;
  bool _timerExpired = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void restartTimer() {
    //_timer?.cancel(); // Cancella il timer esistente
    _timerExpired = false;
    _remainingTime = widget.duration * 60; // Reimposta il tempo rimanente
    //_startTimer(); // Avvia il nuovo timer
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        if (widget.currentPlayer.playing) {
          widget.onTimerExpired(_timerExpired);
          if (_remainingTime > 0) {
            _remainingTime -= 3;
          } else {
            _timerExpired = true;
            widget.onTimerExpired(_timerExpired);
            restartTimer();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String timeString = '${_remainingTime.toString().padLeft(2, '0')} secondi';
    return Column(
      children: [
        if (widget.currentPlayer.playing)
          if (!_timerExpired)
            Text(
              'Tempo turno: $timeString',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )
          else
            Text(
              'Il tempo è scaduto',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            )
        else
          Text(
            'Non è il tuo turno',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
