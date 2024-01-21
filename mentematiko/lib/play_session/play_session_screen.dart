// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:card/models/user.dart';
import 'package:card/play_session/dice_widget.dart';
import 'package:card/play_session/opponent_widget.dart';
import 'package:card/play_session/player_hand_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/board_state.dart';
import '../game_internals/score.dart';
import '../style/palette.dart';
import 'board_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../multiplayer/firestore_controller.dart';
/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class PlaySessionScreen extends StatefulWidget {
  final User user;
  
  const PlaySessionScreen({super.key, required this.user});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');
  
  FirestoreController? _firestoreController;

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late final BoardState _boardState;
  bool _timerExpired = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

return MultiProvider(
  providers: [
    Provider.value(value: _boardState),
  ],
  child: IgnorePointer(
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
                    CountdownTimer(
                      duration: 60,
                      onTimerExpired: (expired) {
                        setState(() {
                          _timerExpired = expired;
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.count(
                    crossAxisCount: 3,
                    children:
                    [
                      for (int i = 0; i < 3; i++) OpponentWidget(),
                      OpponentWidget(),
                      BoardWidget(),
                      OpponentWidget(),                
                    ],
                  ),
                ),
              ),Container(
                  height: 100,
                  width: 100,
                  child: DiceWidget(),
              ),
              IgnorePointer(//quando il tempo arriva a 0 la mano non è cliccabile
                ignoring: _timerExpired,
                child: PlayerHandWidget()
            ),],
            );
          },
        ),
      ),
    ),
  );
  }

  @override
  void dispose() {
    _firestoreController?.dispose();
    _boardState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
    _boardState = BoardState(onWin: _playerWon);
    final firestore = context.read<FirebaseFirestore?>();
    if (firestore == null) {
      _log.warning("Firestore instance wasn't provided. "
      "Running without _firestoreController.");
    } else {
      _firestoreController = FirestoreController(
        instance: firestore,
        boardState: _boardState,
      );
    }
  }

  Future<void> _playerWon() async {
    _log.info('Player won');

    // TODO: replace with some meaningful score for the card game
    final score = Score(1, 1, DateTime.now().difference(_startOfPlay));

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

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}

class CountdownTimer extends StatefulWidget {
  final int duration;
  final ValueChanged<bool> onTimerExpired;

  const CountdownTimer({
    Key? key,
    required this.duration,
    required this.onTimerExpired,
  }) : super(key: key);

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
    _remainingTime = widget.duration;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void restartTimer() {
    _timer?.cancel(); // Cancella il timer esistente
    _remainingTime = widget.duration; // Reimposta il tempo rimanente
    _startTimer(); // Avvia il nuovo timer
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _timerExpired = true;
          widget.onTimerExpired(_timerExpired);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String timeString = _remainingTime.toString().padLeft(2, '0');
    return Column(
      children: [
        Text(
          ' Tempo turno: $timeString',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        if (_timerExpired)
          const Text(
            'Il tempo è scaduto',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
      ],
    );
  }
}