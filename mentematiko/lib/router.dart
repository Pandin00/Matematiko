// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/main_menu/login.dart';
import 'package:card/main_menu/register.dart';
import 'package:card/models/user.dart';
import 'package:card/play_session/play_session_screen.dart';
import 'package:card/services/login_register_service.dart';
import 'package:card/services/match_service.dart';
import 'package:card/user_pages/new_table.dart';
import 'package:card/user_pages/user_menu.dart';
import 'package:card/user_pages/users_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'main_menu/main_menu_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
          path: 'login',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('login'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: LoginPage(
              key: Key('login'),
              loginService: context.read<LoginService>(),
            ),
          ),
          redirect: (context, state) {
            if (state.extra != null && state.extra is User) {
              return '/userMenu';
            }
            return null;
          },
        ),
        GoRoute(
          path: 'register',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('register'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: RegisterPage(
                key: Key('registration'),
                loginService: context.read<LoginService>()),
          ),
          redirect: (context, state) {
            if (state.extra != null && state.extra is User) {
              return '/userMenu';
            }
            return null;
          },
        ),
        GoRoute(
          path: 'userMenu',
          pageBuilder: (context, state) {
            UserMenu menu =
                UserMenu(key: Key('userMenu'), 
                user: state.extra as User,
                matchService: context.read<MatchService>());
            return buildMyTransition(
                child: menu,
                color: context.watch<Palette>().backgroundPlaySession,
                key: ValueKey('userMenu'));
          },
          redirect: (context, state) {
            if (state.extra == null) {
              return '/login';
            }
            return null;
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
        GoRoute(
          path: 'newTable',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('newTable'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: CreateNewTablePage(
                key: Key('newTable'),
                matchService: context.read<MatchService>(),
                user: state.extra as User),
          ),
          redirect: (context, state) {
            if (state.extra == null) {
              return '/login';
            }
            return null;
          },
        ),
        GoRoute(
            path: 'usersView',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: ValueKey('usersView'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: UsersPage(),
                )),
        GoRoute(
                path: 'play',
                pageBuilder: (context, state){
                   PlaySessionScreen play =
                PlaySessionScreen(key: Key('playSessionScreen'), user: state.extra as User);
                return buildMyTransition<void>(
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: play,
                );
                }),
      ],
    ),
  ],
);
