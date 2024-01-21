import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'playing_card_widget.dart';

//indica il tipo di dado in base alle facce 6, 10, 20 
int diceType = 6;

class DiceWidget extends StatefulWidget {
  const DiceWidget({super.key});

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> with SingleTickerProviderStateMixin {
  bool isHighlighted = false;
  
  List<String> diceImages = [];

  AnimationController? _diceAnimationController;
  late AudioPlayer _audioPlayer;
  late Animation<double> _diceAnimation;

  @override
  void initState() {
    super.initState();
    switch(diceType) {
      case 6:
        diceImages = [
        'assets/dice/dice.png', //simbolo per
        'assets/dice/dice (1).png', //simbolo -
        'assets/dice/dice (2).png', //simbolo +
        'assets/dice/dice (3).png', //simbolo :
        'assets/dice/dice (4).png', //simbolo =
        'assets/dice/dice (5).png', //simbolo >
      ];
      break;
    case 10:
        diceImages = [
        'dice/d10-1.png',
        'dice/d10-2.png',
        'dice/d10-3.png',
        'dice/d10-4.png',
        'dice/d10-5.png',
        'dice/d10-6.png',
        'dice/d10-7.png',
        'dice/d10-8.png',
        'dice/d10-9.png',
        'dice/d10-10.png',
      ];     
      break;
    case 20:
        diceImages = [
        'dice/d20-1.png',
        'dice/d20-2.png',
        'dice/d20-3.png',
        'dice/d20-4.png',
        'dice/d20-5.png',
        'dice/d20-6.png',
        'dice/d20-7.png',
        'dice/d20-8.png',
        'dice/d20-9.png',
        'dice/d20-10.png',
        'dice/d20-11.png',
        'dice/d20-12.png',
        'dice/d20-13.png',
        'dice/d20-14.png',
        'dice/d20-15.png',
        'dice/d20-16.png',
        'dice/d20-17.png',
        'dice/d20-18.png',
        'dice/d20-19.png',
        'dice/d20-20.png',
      ];
      break;
    }
    _audioPlayer = AudioPlayer();
    _diceAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 910),
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

  Future<void> _startDiceAnimation() async {
    await _diceAnimationController?.forward();
    _diceAnimationController?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final diceFace = random.nextInt(diceImages.length) + 1;

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
    if(diceType == 6){
      return Center(
        child: Container(
          width: 120,
          height: 120,
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
    } else {
      return Center(
        child: Container(
          width: 120,
          height: 160,
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
}