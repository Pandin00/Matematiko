import 'dart:math';

import 'package:card/models/room.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class MatchService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _log = Logger('MatchService');



Future<bool> createRooom(Room room) async{
  //create documents
   var main=firestore.collection('rooms').doc();
   var teams=main
             .collection('teams');
    
  
    //create teams
   
   for(int i=0;i<room.teams;++i){
      teams.doc('team$i').set({});
   }
  
  //initiliaze tables (numeriche)
    List<int> numbers = List.generate(49, (index) => index + 2); 
    List<int> shuffled= _shuffleArray(numbers);



  //set settings + tables
    Map<String, dynamic> settingsData = {
      'time': room.minutes,
      'teams': room.teams,
      'players': room.players,
      'code': 'M${_generateRandomCode(Random(), 5)}',
      'numeric_card': shuffled
    };
   
   
   main.set(settingsData);

   return true;
}



List<T> _shuffleArray<T>(List<T> array) {
  Random random = Random();

  for (int i = array.length - 1; i > 0; i--) {
    int randomIndex = random.nextInt(i + 1);
    T temp = array[i];
    array[i] = array[randomIndex];
    array[randomIndex] = temp;
  }

  return array;
}


String _generateRandomCode(Random codeGenerator, int length) {
  const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789'; // You can include other characters as needed
  String code = '';

  for (int i = 0; i < length; i++) {
    code += chars[codeGenerator.nextInt(chars.length)];
  }

  return code;
}
    
    
   
}
