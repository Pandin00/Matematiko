

import 'package:card/firebase_options.dart';
import 'package:card/models/room_creation.dart';
import 'package:card/models/user.dart';
import 'package:card/services/match_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

setUpAll(() async {
    // Initialize Firebase with the test configuration
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });   


group('Room Services', () {
   test('creation', () async {
      MatchService match= MatchService();
      User arb=User(email: "arb",nome: "arb",cf: "fake",regione: "reg",provincia: "pro",istituto: "ff",role: "ARB",password: "p");
      User p1=User(email: "p1",nome: "p1",cf: "fake",regione: "reg",provincia: "pro",istituto: "ff",role: "USR",password: "p");
      //User p2=User(email: "p2",nome: "p2",cf: "fake",regione: "reg",provincia: "pro",istituto: "ff",role: "USR",password: "p");

      List<String> result= await match.createRoom(RoomCreation(players: 2, minutes: 10,maxTurni: 10), arb);
      await match.joinInGame(result[1], p1);
      //await match.joinInGame(result[1], p2);

      //match.distributeCards(result[0]);

    });

});

   

}