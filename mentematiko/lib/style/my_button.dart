// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  final double width;
  final double maxWidth;
  final double height;
  final double maxHeight;

  const MyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(20.0),
    this.maxWidth = 500,
    this.height = double.infinity,
    this.maxHeight = 90,
    this.width = double.infinity,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _controller.repeat();
      },
      onExit: (event) {
        _controller.stop(canceled: false);
      },
      child: RotationTransition(
        turns: _controller.drive(const _MySineTween(0.005)),
        child: Container(
          height:
              min(MediaQuery.of(context).size.height * 0.78, widget.maxHeight),
          width: min(MediaQuery.of(context).size.width * 0.78, widget.maxWidth),
          padding: widget.padding,
          child: ElevatedButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 23),
            ),
            onPressed: widget.onPressed,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _MySineTween extends Animatable<double> {
  final double maxExtent;

  const _MySineTween(this.maxExtent);

  @override
  double transform(double t) {
    return sin(t * 2 * pi) * maxExtent;
  }
}
