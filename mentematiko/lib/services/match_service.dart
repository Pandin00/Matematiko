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

  Future<List<String>> createRoom(RoomCreation room, User u) async {
    //create documents
    var main = firestore.collection('rooms').doc();

    if (u.role == 'ARB') {
      // è sempre un arb che crea la room
      String code = '${u.email}${'§'}${u.nome}';
      Map<String, dynamic> playerArb = {
        'id': code,
        'point': 0,
        'order': 0,
        'playing': false,
      };

      await main.collection('players').doc('ARB').set(playerArb);

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
        'eulero_card': eul,
        'log': ''
      };

      await main.set(settingsData);

      return [main.id, code];
    }
    return [];
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
            playing: false,
            untouchable: -1,
            random: -1);
        main
            .doc(querySnapshot.docs.first.id)
            .collection('players')
            .doc(user.email)
            .set(p.toFirestore());
        return JoinedItem(querySnapshot.docs.first.id.toString(),
            currentRoom.numberOfPlayers, currentRoom.time);
      } else {
        return JoinedItem.fromError("FULL");
      }
    }

    return JoinedItem.fromError("NOT_FOUND");
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPlayersInRealTime(
      String idRoom) {
    Stream<QuerySnapshot<Map<String, dynamic>>> data = firestore
        .collection('rooms')
        .doc(idRoom)
        .collection('players')
        .snapshots();

    return data;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getRoomTableInRealTime(
      String idRoom) {
    return firestore.collection('rooms').doc(idRoom).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPlayerInRealTime(
      String idRoom, String idPlayer) {
    return firestore
        .collection('rooms')
        .doc(idRoom)
        .collection('players')
        .doc(idPlayer)
        .snapshots();
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

  Future<Player?> searchByUser(String idRoom, User usr) async {
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');

    QuerySnapshot<Player> searchById = await players
        .where('id', isEqualTo: '${usr.email}${'§'}${usr.nome}')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Player.fromFirestore(snapshot.data()!),
            toFirestore: (player, _) => {})
        .get();
    if (searchById.size > 0) {
      return searchById.docs.first.data();
    } else {
      return null;
    }
  }

  Future<Player?> searchByOrder(String idRoom, int order) async {
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');

    QuerySnapshot<Player> searchById = await players
        .where('order', isEqualTo: order)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Player.fromFirestore(snapshot.data()!),
            toFirestore: (player, _) => {})
        .get();
    if (searchById.size > 0) {
      return searchById.docs.first.data();
    } else {
      return null;
    }
  }

  Future<void> updateNextPlayer(String idRoom, int maxPlayers, User usr) async {
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');

    Player? current = await searchByUser(idRoom, usr);

    if (current != null) {
      String currentId = usr.role == 'ARB' ? 'ARB' : current.id.split('§')[0];
      current.playing = false;
      int next = current.order + 1;
      if (next > maxPlayers) {
        next = 1; //ARB è 0 e non gioca
      }
      //search next
      QuerySnapshot<Player> searchByOrder = await players
          .where('order', isEqualTo: next)
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  Player.fromFirestore(snapshot.data()!),
              toFirestore: (player, _) => {})
          .get();

      Player nextPlayer = searchByOrder.docs.first.data();
      nextPlayer.playing = true;
      //aggiorna
      await players
          .doc(searchByOrder.docs.first.id)
          .set(nextPlayer.toFirestore());
      await players.doc(currentId).set(current.toFirestore());
    }
  }

  Future<void> applyMulta(
      String idRoom, Player currentPlayer, Room room) async {
    if (currentPlayer.cards!.isNotEmpty) {
      String type = '';
      int extracted = -1;
      int tentative = 0;
      do {
        extracted = Random().nextInt(currentPlayer.cards!.length);
        type = currentPlayer.cards![extracted].type;
        ++tentative;
      } while (type == 'E' && tentative < 10);

      if (tentative == 9) return;
      _log.info("carta estratta ${currentPlayer.cards![extracted]}");
      PlayableCards card = currentPlayer.cards!.removeAt(extracted);
      room.numericCards.add(int.parse(card.value));

      //update on firestore
      await updateRoomAndPlayer(idRoom, currentPlayer, room);
    }
  }

//liscia
  Future<void> updateRoomAndPlayer(
      String idRoom, Player currentPlayer, Room room) async {
    var roomDoc = firestore.collection('rooms').doc(idRoom);
    var playersDoc =
        roomDoc.collection('players').doc(currentPlayer.getDocumentId());

    //calcola punti (da scrivere)
    await roomDoc.update(room.toFirestore());
    await playersDoc.update(currentPlayer.toFirestore());
  }

  Future<void> updatePlayer(String idRoom, Player player) async {
    var roomDoc = firestore.collection('rooms').doc(idRoom);
    var playersDoc = roomDoc.collection('players').doc(player.getDocumentId());
    await playersDoc.update(player.toFirestore());
  }

  Future<void> updateRoom(String idRoom, Room room) async {
    var roomDoc = firestore.collection('rooms').doc(idRoom);
    await roomDoc.update(room.toFirestore());
  }

  Future<void> speculare(String idRoom, Player currentPlayer, Room room) async {
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');

    QuerySnapshot playerInGame = await players.get();
    int totalEntities = playerInGame.docs.length-1; //levo l'arbitro
    int circularShift =
        (totalEntities - currentPlayer.order + 1) % totalEntities;
    var batch = firestore.batch();
    for (QueryDocumentSnapshot document in playerInGame.docs) {
      if (document.id != 'ARB') {
        var data = document.data() as Map<String, dynamic>;

        int newOrder = ((data['order'] - circularShift - 1 + totalEntities) %
                totalEntities) +
            1;
        batch.update(document.reference, {'order': newOrder});
      }
    }
    batch.commit();

    //update on firestore
    await updateRoomAndPlayer(idRoom, currentPlayer, room);
  }

  Future<void> updateNextPlayerByCurrentPlayer(
      String idRoom, int maxPlayers, Player current, Room room) async {
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');
    String currentId = current.order == 0 ? 'ARB' : current.id.split('§')[0];
    current.playing = false;
    int next = current.order + 1;
    if (next > maxPlayers) {
      next = 1; //ARB è 0 e non gioca
      //increase turno e decrease tutti quelli con untouchable
      room.turno != room.turno! + 1;
      await decreaseUntouchablesPlayers(idRoom);
    }
    //search next
    QuerySnapshot<Player> searchByOrder = await players
        .where('order', isEqualTo: next)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Player.fromFirestore(snapshot.data()!),
            toFirestore: (player, _) => {})
        .get();

    Player nextPlayer = searchByOrder.docs.first.data();
    nextPlayer.playing = true;
    //aggiorna
    await players
        .doc(searchByOrder.docs.first.id)
        .set(nextPlayer.toFirestore());
    await players.doc(currentId).set(current.toFirestore());
  }

  Future<void> updateWhoIsPlaying(
      String idRoom, User user, bool playing) async {
    var rooms = firestore.collection('rooms');

    Map<String, dynamic> update = {
      'playing': playing,
    };
    await rooms
        .doc(idRoom)
        .collection('players')
        .doc(user.role == 'ARB' ? 'ARB' : user.email)
        .update(update);
  }

  Future<void> decreaseUntouchablesPlayers(String idRoom) async {
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');
    QuerySnapshot<Player> unPlayers = await players
        .where('untouchable', isGreaterThan: 0)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                Player.fromFirestore(snapshot.data()!),
            toFirestore: (player, _) => {})
        .get();
    if (unPlayers.docs.isNotEmpty) {
      for (var element in unPlayers.docs) {
        Player p = element.data();
        p.untouchable = p.untouchable! - 1;
        _log.info("ridotto a ${p.getDocumentId()} ${p.untouchable}");
        await updatePlayer(idRoom, p);
      }
    }
  }

  Future<void> distributeCards(String idRoom) async {
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
    //make piatto
    currentRoom.piatto = currentRoom.numericCards
        .sublist(0, 3)
        .map((e) => e.toString())
        .toList();
    currentRoom.numericCards.removeRange(0, 3);

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
      }
    }
    //update room after distribution
    await rooms.doc(idRoom).update(currentRoom.toFirestore());
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
    const String chars =
        'abcdefghijklmnopqrstuvwxyz0123456789'; // You can include other characters as needed
    String code = '';

    for (int i = 0; i < length; i++) {
      code += chars[codeGenerator.nextInt(chars.length)];
    }

    return code;
  }

  Future<void> assignCardsFromPlate(
      String idRoom, Player player, Room room, int n) async {
    // check if there are enough cards in the piatto
    if (room.piatto.length >= n) {
      // remove n cards from the piatto

      List<String> extract = room.piatto.sublist(1, n + 1);
      List<PlayableCards> playable =
          extract.map((e) => PlayableCards.buildFromValue(e)).toList();
      player.cards!.addAll(playable); //aggiunti al player

      room.piatto.removeRange(
          room.piatto.length - 3, room.piatto.length); //rimossi dal piatto
    } else {
      // give all remaining cards to the player
      List<PlayableCards> cards = room.piatto
          .skip(1)
          .toList()
          .map((e) => PlayableCards.buildFromValue(e))
          .toList();
      player.cards!.addAll(cards);
      room.piatto
          .removeRange(1, room.piatto.length); //eccetto appena quella giocata
    }
    await updateRoomAndPlayer(idRoom, player, room);
  }

  Future<void> assignCardsFromRoom(
      int n, String idRoom, Player player, Room room) async {
    var rooms = firestore.collection('rooms');
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');

    if (room.numericCards.isNotEmpty) {
      int extracted = room.numericCards.removeAt(0);
      player.cards?.add(PlayableCards.buildFromValue(extracted.toString()));
    }
  }

  Future<void> effettoPrimo(
      String idRoom, Player currentPlayer, Room room, int maxPlayers) async {
    var rooms = firestore.collection('rooms');
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');
    int pos = 0;
    List<int> myNexts = getMyNextOrders(currentPlayer, maxPlayers);

    _log.info("EffettoPrimo con $maxPlayers, sottraggo le carte a tutti!");
    QuerySnapshot playerInGame = await players.get();
    for (QueryDocumentSnapshot document in playerInGame.docs) {
      //evita di ciclare il resto
      if (pos >= 3) {
        break;
      }
      if (document.id != 'ARB' &&
          document.id != currentPlayer.getDocumentId()) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        Player otherPlayer = Player.fromFirestore(data);
        if (myNexts.contains(otherPlayer.order)) {
          //se il giocatore è ancora in gioco e non ha l'effetto 7
          if (otherPlayer.cards != null &&
              otherPlayer.cards!.isNotEmpty &&
              otherPlayer.untouchable == -1) {
            int extract = Random().nextInt(otherPlayer.cards!.length);
            PlayableCards lostCard = otherPlayer.cards!.removeAt(extract);
            currentPlayer.cards!.add(lostCard);
            _log.info(
                "Player ${otherPlayer.getDocumentId()}-${otherPlayer.order} lost $lostCard");
            ++pos;
            await updatePlayer(
                idRoom, otherPlayer); //aggiorna le carte al giocatore
          }
        }
      }
    }
    await updateRoomAndPlayer(
        idRoom, currentPlayer, room); //aggiorna room e carte mie
  }

  Future<void> effettoZero(String idRoom, Room room) async {
    var rooms = firestore.collection('rooms');
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');
    _log.info(
        "Effetto zero start piatto: ${room.piatto.length}  numeriche: ${room.numericCards.length} eulero: numeriche: ${room.euleroCards.length}");

    for (var element in room.piatto) {
      if (element != '0') {
        PlayableCards playableCards = PlayableCards.buildFromValue(element);
        if (playableCards.type == 'E') {
          room.euleroCards.add(element);
        } else if (playableCards.type == 'N') {
          room.numericCards.add(int.parse(element));
        }
      }
    }
    //remove piatto
    room.piatto.clear();
    room.piatto.add("0");

    //shuffle
    _shuffleArray(room.euleroCards);
    _shuffleArray(room.numericCards);

    _log.info(
        "Effetto zero end piatto: ${room.piatto.length}  numeriche: ${room.numericCards.length} eulero: numeriche: ${room.euleroCards.length}");
    await updateRoom(idRoom, room);
  }

  List<int> getMyNextOrders(Player currentPlayer, int maxPlayers) {
    int currentOrder = currentPlayer.order;
    List<int> myNext = List.empty(growable: true);
    myNext.add((currentOrder + 1) % maxPlayers);
    myNext.add((currentOrder + 2) % maxPlayers);
    myNext.add((currentOrder + 3) % maxPlayers);

    myNext = myNext.map((value) => value == 0 ? 1 : value).toList();
    return myNext;
  }

  Future<void> effettoMultiplo(String idRoom, Player player, Room room) async {
    assignCardsFromRoom(1, idRoom, player, room);
    await updateRoomAndPlayer(idRoom, player, room);
  }

  Future<void> effettoDivisore(
      Player currentPlayer, Room room, String idRoom, int q) async {
    _log.info("Divisibile i get cards $q from table");
    await assignCardsFromPlate(idRoom, currentPlayer, room, q);
  }

  Future<void> effettoNumeroPerfetto(
      String idRoom, Player currentPlayer, Room room, int value) async {
    List<PlayableCards> piattoExceptFirst = room.piatto
        .skip(1)
        .map((e) => PlayableCards.buildFromValue(e))
        .toList();

    for (var divisore in piattoExceptFirst) {
      if (divisore.type != 'E') {
        int divInt = int.parse(divisore.value);
        if (value % divInt == 0) {
          currentPlayer.cards!.add(divisore);
          room.piatto.remove(divisore.value);
        }
      }
    }
    await updateRoomAndPlayer(idRoom, currentPlayer, room);
  }

  Future<void> effettoComplementare(
      String idRoom, Player currentPlayer, Room room) async {
    currentPlayer.cards!
        .add(PlayableCards.buildFromValue(room.piatto.skip(1).first));
    await updatePlayer(idRoom, currentPlayer);
  }

  Future<void> effettoMcd(
      String idRoom, Player currentPlayer, Room room, int maxPlayers) async {
    if (room.euleroCards.isNotEmpty) {
      String euler = room.euleroCards.removeAt(0);
      currentPlayer.cards!.add(PlayableCards.buildFromValue(euler));
      updateRoomAndPlayer(idRoom, currentPlayer, room);
    } else {
      //caso di pescare dal precedente
      var players =
          firestore.collection('rooms').doc(idRoom).collection('players');
      QuerySnapshot playerInGame = await players.get();
      int searchedOrder =
          currentPlayer.order - 1 % maxPlayers; //ordine precedente
      if (searchedOrder <= 0) searchedOrder = maxPlayers;
      for (QueryDocumentSnapshot document in playerInGame.docs) {
        if (document.id != 'ARB' &&
            document.id != currentPlayer.getDocumentId()) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Player otherPlayer = Player.fromFirestore(data);
          if (otherPlayer.order == searchedOrder) {
            List<PlayableCards> euCard = otherPlayer.cards!
                .where((element) => element.type == 'E')
                .toList();
            if (euCard.isNotEmpty) {
              currentPlayer.cards!.add(euCard.first);
              otherPlayer.cards!.remove(euCard.first);

              await updatePlayer(idRoom, currentPlayer);
              await updatePlayer(idRoom, otherPlayer);
            }
            break;
          }
        }
      }
    }
  }

  //anche m.c.m
  Future<void> effettoEulero(
      String idRoom, Player currentPlayer, Room room) async {
    String first = room.piatto.first;
    room.piatto
        .skip(1)
        .map((e) => currentPlayer.cards!.add(PlayableCards.buildFromValue(e)))
        .toList();
    room.piatto.clear();
    room.piatto.add(first);

    await updateRoomAndPlayer(idRoom, currentPlayer, room);
  }

  //implementa calcolo punti
  Future<int> calcolatePoints(String idPlayer, String idRoom) async {
    var players =
        firestore.collection('rooms').doc(idRoom).collection('players');
    var playerDoc = await players.doc(idPlayer).get();

    List<dynamic> updatedPlayerCards = playerDoc['cards'];

    int points = 0;

    for (var element in updatedPlayerCards) {
      switch (element) {
        case 'e':
        case 'i':
        case 'pi':
        case '0':
        case '1':
          points += 1000;
          break;
        case '2':
          points += 800;
          break;
        case '3':
          points += 700;
          break;
        case '4':
          points += 100;
          break;
        case '5':
          points += 500;
          break;
        case '6':
          points += 10;
          break;
        case '7':
          points += 300;
          break;
        case '8':
          points += 30;
          break;
        case '9':
          points += 100;
          break;
        case '10':
          points += 10;
          break;
        case '11':
          points += 250;
          break;
        case '12':
          points += 20;
          break;
        case '13':
          points += 250;
          break;
        case '14':
          points += 10;
          break;
        case '15':
          points += 10;
          break;
        case '16':
          points += 100;
          break;
        case '17':
          points += 250;
          break;
        case '18':
          points += 10;
          break;
        case '19':
          points += 250;
          break;
        case '20':
          points += 20;
          break;
        case '21':
          points += 10;
          break;
        case '22':
          points += 10;
          break;
        case '23':
          points += 225;
          break;
        case '24':
          points += 30;
          break;
        case '25':
          points += 100;
          break;
        case '26':
          points += 10;
          break;
        case '27':
          points += 10;
          break;
        case '28':
          points += 20;
          break;
        case '29':
          points += 225;
          break;
        case '30':
          points += 10;
          break;
        case '31':
          points += 200;
          break;
        case '32':
          points += 50;
          break;
        case '33':
          points += 10;
          break;
        case '34':
          points += 10;
          break;
        case '35':
          points += 20;
          break;
        case '36':
          points += 100;
          break;
        case '37':
          points += 200;
          break;
        case '38':
          points += 10;
          break;
        case '39':
          points += 10;
          break;
        case '40':
          points += 30;
          break;
        case '41':
          points += 175;
          break;
        case '42':
          points += 10;
          break;
        case '43':
          points += 175;
          break;
        case '44':
          points += 20;
          break;
        case '45':
          points += 10;
          break;
        case '46':
          points += 10;
          break;
        case '47':
          points += 175;
          break;
        case '48':
          points += 40;
          break;
        case '49':
          points += 100;
          break;
        case '50':
          points += 10;
          break;
      }
    }

    return points;
  }

  Future<void> effettoQuadrato(
      String idRoom, Player currentPlayer, Room? currentRoom) async {
    currentPlayer.untouchable = 3;
    await updateRoomAndPlayer(idRoom, currentPlayer, currentRoom!);
  }
}

//classi di comodo
class JoinedItem {
  String? roomId;
  int? time;
  int? maxPlayers;
  String? errorCode;

  JoinedItem(this.roomId, this.maxPlayers, this.time) {
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
        if (prime > 0) {
          --prime;
          extracted.add(element);
        }
      } else {
        if (notPrime > 0) {
          --notPrime;
          extracted.add(element);
        }
      }
      if (notPrime == 0 && prime == 0) {
        break;
      }
    }
    numericCards.removeWhere((element) => extracted.contains(element));
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
