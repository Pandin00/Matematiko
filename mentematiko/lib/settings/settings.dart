// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'persistence/local_storage_settings_persistence.dart';
import 'persistence/settings_persistence.dart';

/// An class that holds settings like [playerName] or [musicOn],
/// and saves them to an injected persistence store.
class SettingsController {
  static final _log = Logger('SettingsController');

  /// The persistence store that is used to save settings.
  final SettingsPersistence _store;

  /// Whether or not the audio is on at all. This overrides both music
  /// and sounds (sfx).
  ///
  /// This is an important feature especially on mobile, where players
  /// expect to be able to quickly mute all the audio. Having this as
  /// a separate flag (as opposed to some kind of {off, sound, everything}
  /// enum) means that the player will not lose their [soundsOn] and
  /// [musicOn] preferences when they temporarily mute the game.
  ValueNotifier<bool> audioOn = ValueNotifier(true);

  /// The player's name. Used for things like high score lists.
  ValueNotifier<String> playerName = ValueNotifier('Player');

  /// Whether or not the sound effects (sfx) are on.
  ValueNotifier<bool> soundsOn = ValueNotifier(true);

  /// Whether or not the music is on.
  ValueNotifier<bool> musicOn = ValueNotifier(true);

  /// Creates a new instance of [SettingsController] backed by [store].
  ///
  /// By default, settings are persisted using [LocalStorageSettingsPersistence]
  /// (i.e. NSUserDefaults on iOS, SharedPreferences on Android or
  /// local storage on the web).
  SettingsController({SettingsPersistence? store})
      : _store = store ?? LocalStorageSettingsPersistence();

  String getRoomId() {
    return _store.getLastRoomCode();
  }

  void setRoomId(String code) {
    _store.setLastRoomCode(code);
  }

  int getMaxPlayer() {
    return _store.getMaxPlayer();
  }

  void setMaxPlayer(int max) {
    return _store.setMaxPlayer(max);
  }

  void setTimePerTurn(int time) {
    return _store.setTimePerTurn(time);
  }

  int getTimePerTurn() {
    return _store.getTimePerTurn();
  }

//n-max di turni
  void setTurni(int turni) {
    return _store.setMaxTurni(turni);
  }

  int getTurni() {
    return _store.getMaxTurni();
  }
}
