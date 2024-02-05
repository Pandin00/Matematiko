import 'package:audioplayers/audioplayers.dart';
import 'package:card/style/my_button.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/player.dart';

class WinPage extends StatefulWidget {
  final Player player;

  const WinPage({required super.key, required this.player});

  @override
  _WinPageState createState() => _WinPageState();
}

class _WinPageState extends State<WinPage> {
  static const _celebrationDuration = Duration(milliseconds: 2000);
  late ConfettiController _confettiController;
  late final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: _celebrationDuration);
    _confettiController.play(); // Start the confetti animation
    _audioPlayer.play(AssetSource('music/celebration.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/coppa.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              width: 200,
              height: 200,
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              '${widget.player.id.split("§")[1]} ha vinto con ${widget.player.point} punti',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/');
            },
            child: Text('Esci'),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
          ),
        ],
      ),
    );
  }
}