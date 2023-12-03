// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/main_menu/login.dart';
import 'package:card/main_menu/login_or_register_screen.dart';
import 'package:card/main_menu/register.dart';
import 'package:card/user_pages/tournament_view.dart';
import 'package:card/user_pages/user_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_internals/score.dart';
import 'main_menu/main_menu_screen.dart';
import 'play_session/play_session_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
          path: 'loginOrRegister',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('loginOrRegister'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: const LoginOrRegister(
              key: Key('level selection'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'login',
              pageBuilder: (context, state) => buildMyTransition<void>(
                key: ValueKey('login'),
                color: context.watch<Palette>().backgroundPlaySession,
                child: LoginPage(
                  key: Key('login'),
                ),
              )
            ),
            GoRoute(
              path: 'register',
              pageBuilder: (context, state) => buildMyTransition<void>(
                key: ValueKey('register'),
                color: context.watch<Palette>().backgroundPlaySession,
                child: RegisterPage(
                  key: Key('registration')
                ),
              )
            ),
            GoRoute(
              path: 'userMenu',
              pageBuilder: (context, state) => buildMyTransition<void>(
                key: ValueKey('userMenu'),
                color: context.watch<Palette>().backgroundPlaySession,
                child: UserMenu(
                  key: Key('userMenu')
                ),
              )
            ),
            GoRoute(
              path: 'tournamentsView',
              pageBuilder: (context, state) => buildMyTransition<void>(
                key: ValueKey('tournamentsView'),
                color: context.watch<Palette>().backgroundPlaySession,
                child: TournamentsView(
                ),
              )
            )
          ],
        ),
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('play'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: const PlaySessionScreen(
              key: Key('level selection'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'won',
              redirect: (context, state) {
                if (state.extra == null) {
                  // Trying to navigate to a win screen without any data.
                  // Possibly by using the browser's back button.
                  return '/';
                }

                // Otherwise, do not redirect.
                return null;
              },
              pageBuilder: (context, state) {
                final map = state.extra! as Map<String, dynamic>;
                final score = map['score'] as Score;

                return buildMyTransition<void>(
                  key: ValueKey('won'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: WinGameScreen(
                    score: score,
                    key: const Key('win game'),
                  ),
                );
              },
            )
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
      ],
    ),
  ],
);
