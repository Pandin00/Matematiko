// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:shared_preferences/shared_preferences.dart';

import 'settings_persistence.dart';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.
class LocalStorageSettingsPersistence extends SettingsPersistence {
   
   SharedPreferences? instance;

   LocalStorageSettingsPersistence(){
      SharedPreferences.getInstance().then((value) => instance=value);
   }
  
  @override
  String getLastRoomCode()  {
    final prefs = instance;
    return prefs?.getString('roomCode') ?? '';
  }
  
  @override
  Future<void> setLastRoomCode(String code) async {
    final prefs = instance;
    await prefs?.setString('roomCode', code);
  }
  
  @override
  int getMaxPlayer() {
    final prefs = instance;
    return prefs?.getInt('maxPlayers') ?? -1;
  }
  
  @override
  void setMaxPlayer(int max) async{
    final prefs = instance;
    await prefs?.setInt('maxPlayers', max);
  }
  
  @override
  int getTimePerTurn() {
     final prefs = instance;
    return prefs?.getInt('time') ?? -1;
  }
  
  @override
  void setTimePerTurn(int time) async {
   final prefs = instance;
    await prefs?.setInt('time', time);
  }
  
  @override
  int getMaxTurni() {
   final prefs = instance;
    return prefs?.getInt('turni') ?? 5;
  }
  
  @override
  void setMaxTurni(int turni) async {
    final prefs = instance;
    await prefs?.setInt('turni', turni);
  }


}
