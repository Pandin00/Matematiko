import 'dart:js_interop';
import 'dart:math';

import 'package:card/models/Room.dart';
import 'package:card/models/playable_cards.dart';
import 'package:card/models/player.dart';
import 'package:card/models/room_creation.dart';
import 'package:card/models/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class MatchService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _log = Logger('MatchService');
  //da decidere quali verranno implementate [Nessuna]
  final nerdsCard = <String>[
    'Caprone Ugo',
    'Capra Pina',
    'Zio Pipuzzo',
    'Vito Cappuccio',
    'Ignazzuzzo',
    'Ernestuzzo',
    'Fra Cicciuzzo',
    'Maresciallo Trinciapolli',
    'Giuanni Oste',
    'Santa Pupazza',
    'Nonna Astolfa'
  ];
  final eulero = <String>[
    'e',
    'e',
    'e',
    'pi',
    'pi',
    'pi',
    'i',
    'i',
    'i',
    '1',
    '1',
    '1',
    '0',
    '0',
    '0'
  ];

  Future<String> createRooom(RoomCreation room, User u) async {
    //create documents
    var main = firestore.collection('rooms').doc();

    if (u.role == 'ARB') {
      // è sempre un arb che crea la room

      Map<String, dynamic> playerArb = {
        'id': '${u.email}${'§'}${u.nome}',
        'point': 0,
        'order': 0,
        'playing': false,
      };

      await main.collection('players').doc('ARB').set(playerArb);
    }

    //initiliaze tables (numeriche+nerd+eulero)
    List<int> numbers = List.generate(49, (index) => index + 2);
    List<int> shuffled = _shuffleArray(numbers);
    List<String> nerds = _shuffleArray(List.of(nerdsCard));
    List<String> eul = _shuffleArray(List.of(eulero));

    //set settings + tables
    Map<String, dynamic> settingsData = {
      'time': room.minutes,
      'players': room.players,
      'code': 'M${_generateRandomCode(Random(), 5)}',
      'numeric_card': shuffled,
      'nerd_card': nerds,
      'eulero_card': eul
    };

    await main.set(settingsData);

    return main.id;
  }

  Future<JoinedItem> joinInGame(String code, User user) async {
    var main = firestore.collection('rooms');

    QuerySnapshot<Room> querySnapshot = await main
        .where('code', isEqualTo: code)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Room.fromFirestore(snapshot.data()!),
            toFirestore: (room, _) => {})
        .get();

    if (querySnapshot.size > 0) {
      //found and join
      Room currentRoom = querySnapshot.docs.first.data();
      int order =
          await getDocumentCountOnRooms(querySnapshot.docs.first.id, 'players');
      if (order <= currentRoom.numberOfPlayers) {
        Player p = Player(
            id: '${user.email}${'§'}${user.nome}',
            point: 0,
            order: order,
            playing: false);
        main
            .doc(querySnapshot.docs.first.id)
            .collection('players')
            .doc(user.email)
            .set(p.toFirestore());
        return JoinedItem(
            querySnapshot.docs.first.id.toString(), currentRoom.numberOfPlayers);
      } else {
        return JoinedItem.fromError("FULL");
      }
    }

    return JoinedItem.fromError("NOT_FOUND");
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPlayerInRealTime(String idRoom) {
    Stream<QuerySnapshot<Map<String, dynamic>>> data = firestore
        .collection('rooms')
        .doc(idRoom)
        .collection('players')
        .snapshots();
    
    return data;
  }

  Future<int> getDocumentCountOnRooms(String id, String collection) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(id)
          .collection(collection)
          .get();
      int count = querySnapshot.size;
      return count;
    } catch (e) {
      return -1; // Handle the error and return a default value or handle accordingly
    }
  }

  void updateWhoIsPlaying(String idRoom, User user, bool playing) {
    var rooms = firestore.collection('rooms');

    Map<String, dynamic> update = {
      'playing': playing,
    };
    rooms
        .doc(idRoom)
        .collection('players')
        .doc(user.role == 'ARB' ? 'ARB' : user.email)
        .update(update);
  }

  void distributeCards(String idRoom) async {
    /*  get room by id 
        per ogni player prendi le carte
        rimuoveli dall'array & update
        assegnale e fai update su firebase x player
     */

    var rooms = firestore.collection('rooms');
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');
    UtilMatchService util = UtilMatchService();

    var roomInfo = await rooms.doc(idRoom).get();
    Room currentRoom = Room.fromFirestore(roomInfo.data()!);

    QuerySnapshot playerInGame = await players.get();

    for (QueryDocumentSnapshot document in playerInGame.docs) {
      if (document.id != 'ARB') {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        List<int> numeriks = util.extractNumbers(currentRoom.numericCards);
        List<String> eulers = util.extractEulero(currentRoom.euleroCards);

        Player p = Player.fromFirestore(data);
        p.cards?.addAll(numeriks
            .map((e) => PlayableCards.buildFromValue(e.toString()))
            .toList());
        p.cards?.addAll(eulers
            .map((e) => PlayableCards.buildFromValue(e.toString()))
            .toList());

        //update card players + room
        await players.doc(document.id).update(p.toFirestore());
        await rooms.doc(idRoom).update(currentRoom.toFirestore());
      }
    }
  }

/*
  Future<void> fetchData() async {
    try {
      // Reference to the document
      DocumentReference documentRef = FirebaseFirestore.instance
          .collection('your_collection')
          .doc('your_document_id');

      // Get the document
      DocumentSnapshot documentSnapshot = await documentRef.get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Access the data in the document
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        // Access a field in the document
        var fieldValue = data['field_name'];

        // Reference to the subcollection
        CollectionReference subcollectionRef =
            documentRef.collection('your_subcollection');

        // Get the documents in the subcollection
        QuerySnapshot subcollectionSnapshot = await subcollectionRef.get();

        // Iterate through the documents in the subcollection
        subcollectionSnapshot.docs.forEach((subDoc) {
          // Access the data in each subdocument
          Map<String, dynamic> subDocData =
              subDoc.data() as Map<String, dynamic>;

          // Access a field in the subdocument
          var subDocFieldValue = subDocData['subfield_name'];
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
*/
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
    const String chars =
        'abcdefghijklmnopqrstuvwxyz0123456789'; // You can include other characters as needed
    String code = '';

    for (int i = 0; i < length; i++) {
      code += chars[codeGenerator.nextInt(chars.length)];
    }

    return code;
  }
}

//classi di comodo
class JoinedItem {
  String? roomId;
  int? maxPlayers;
  String? errorCode;

  JoinedItem(this.roomId, this.maxPlayers) {
    errorCode = '';
  }

  JoinedItem.fromError(this.errorCode) {
    roomId = '';
    maxPlayers = -1;
  }
}

class UtilMatchService {
  List<int> extractNumbers(List<int> numericCards) {
    int notPrime = 7; // da reg. 7 non primi e 2 primi
    int prime = 2;
    List<int> extracted = List.empty(growable: true);
    for (var element in numericCards) {
      if (isPrime(element)) {
        --prime;
        extracted.add(element);
      } else {
        --notPrime;
        extracted.add(element);
      }
      if (notPrime == 0 && prime == 0) {
        continue;
      }
    }
    numericCards.removeWhere((element) =>
        extracted.contains(element)); //da verificare se è reference
    return extracted;
  }

  List<String> extractEulero(List<String> eulero) {
    List<String> result = [eulero[0]];
    List<int> removed = [0];
    for (int i = 1; i < eulero.length; i++) {
      if (eulero[i] != eulero[0]) {
        result.add(eulero[i]);
        removed.add(i);
      }
      if (result.length == 2) {
        break;
      }
    }
    //sono sempre 2 le carte estratte
    eulero.removeAt(removed[0]);
    eulero.removeAt(removed[1]);
    return result;
  }

  bool isPrime(int number) {
    if (number <= 1) {
      // 0 and 1 are not prime numbers
      return false;
    }

    for (int i = 2; i <= number / 2; i++) {
      if (number % i == 0) {
        return false;
      }
    }
    return true;
  }
}
