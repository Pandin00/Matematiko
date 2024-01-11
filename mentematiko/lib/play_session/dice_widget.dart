import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:card/game_internals/dice.dart';
import 'package:flutter/material.dart';
import 'playing_card_widget.dart';

class DiceWidget extends StatefulWidget {
  final Dice area;

  const DiceWidget(this.area, {super.key});

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> with SingleTickerProviderStateMixin {
  bool isHighlighted = false;
  final List<String> diceImages = [
    'assets/dice/dice.png',
    'assets/dice/dice (1).png',
    'assets/dice/dice (2).png',
    'assets/dice/dice (3).png',
    'assets/dice/dice (4).png',
    'assets/dice/dice (5).png',
  ];

  AnimationController? _diceAnimationController;
  late AudioPlayer _audioPlayer;
  late Animation<double> _diceAnimation;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _diceAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );
    final tween = Tween<double>(begin: 0, end: 1);
    _diceAnimation = tween.animate(_diceAnimationController!);
    _diceAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _diceAnimationController?.dispose();
    super.dispose();
  }

  void _playDiceSound() async {
    await _audioPlayer.play(AssetSource('music/dice.mp3'));
  }

  void _onAreaTapDice() {
    _startDiceAnimation();
    _playDiceSound();
  }

  void _startDiceAnimation() {
    _diceAnimationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final diceFace = random.nextInt(6) + 1;

    return LimitedBox(
      maxHeight: 200,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: DragTarget<PlayingCardDragData>(
          builder: (context, candidateData, rejectedData) => SizedBox(
            height: 100,
            child: InkWell(
              onTap: _onAreaTapDice,
              child: Stack(
                children: [
                  Positioned(
                    child: _Dice(
                      animation: _diceAnimation,
                      image: diceImages[diceFace - 1],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dice extends StatefulWidget {
  final Animation<double> animation;
  final String image;

  _Dice({required this.animation, required this.image});

  @override
  __DiceState createState() => __DiceState();
}

class __DiceState extends State<_Dice> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        child: Image.asset(
          widget.image,
          fit: BoxFit.cover,
          frameBuilder: (context, image, frame, callback) {
            if (frame == null) {
              return Container();
            }
            return Transform.rotate(
              angle: widget.animation.value * 2 * pi,
              child: image,
            );
          },
        ),
      ),
    );
  }
}