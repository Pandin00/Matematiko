// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', semanticLabel: 'Logo'),
              getGapHeight(context),
              MyButton(
                onPressed: () {
                  GoRouter.of(context).go('/login');
                },
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              MyButton(
                onPressed: () {
                  GoRouter.of(context).go('/register');
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
        rectangularMenuArea: getGapHeight(context),
      ),
    );
  }

  static SizedBox getGapHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var padding;
    if (screenHeight > 780) {
      padding = mediaQuery.size.width * 0.19;
    } else {
      padding = mediaQuery.size.width * 0.08;
    }

    return SizedBox(height: padding);
  }
}
