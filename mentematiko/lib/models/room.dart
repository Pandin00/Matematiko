import 'package:card/models/player.dart';

class Room {
  int time;
  int numberOfPlayers;
  String code;
  List<int> numericCards;
  List<String> nerdCards;
  List<String> euleroCards;

  List<String> piatto; //piatto del gioco 

  List<Player>? players;

  String log=''; //log giocate e notifiche
  int? turno = 1;

//log

  Room(
      {required this.time,
      this.turno,
      required this.numberOfPlayers,
      required this.code,
      required this.numericCards,
      required this.nerdCards,
      required this.euleroCards,
      required this.piatto,
      required this.log
      });




//nerd-card not used now
  Map<String, dynamic> toFirestore() {
    return {
      'time': time,
      'players': numberOfPlayers,
      'code': code,
      'numeric_card': numericCards.map((e) => e.toString()).toList(),
      'eulero_card': euleroCards,
      'piatto': piatto,
      'log': log,
      'turno': turno
    };
  }

  static Room fromFirestore(Map<String, dynamic> data) {
    return Room(
        time: data['time'] ?? '',
        numberOfPlayers: data['players'] ?? '',
        code: data['code'] ?? '',
        numericCards: _convertInt(data['numeric_card']),
        nerdCards: _convertString(data['nerd_card']),
        euleroCards: _convertString(data['eulero_card']),
        piatto: data['piatto'] != null ? _convertString(data['piatto']) : List.empty(),
        log: data['log'] ?? '',
        turno: data['turno']?? 1,
    );
  }

  static List<String> _convertString(List<dynamic> dynamicList) {
    List<String> list = dynamicList
        .map<String>((dynamic element) {
          if (element is String) {
            return element.toString();
          } else {
            return ''; // Provide a default value
          }
        })
        .where((element) => element != null)
        .toList();

    return list;
  }

  static List<int> _convertInt(List<dynamic> dynamicList) {
    List<int> intList = dynamicList
        .map<int>((dynamic element) {
          if (element is int) {
            return element;
          } else if (element is double) {
            return element.toInt();
          } else if (element is String) {
            return int.tryParse(element) ??
                0; // Provide a default value or handle accordingly
          } else {
            return 0; // Provide a default value or handle other types accordingly
          }
        })
        .where((element) => element != null)
        .toList();

    return intList;
  }

  static List<int> _convert(List<dynamic> dynamicList) {
    List<int> intList = dynamicList
        .map<int>((dynamic element) {
          if (element is int) {
            return element;
          } else if (element is double) {
            return element.toInt();
          } else if (element is String) {
            return int.tryParse(element) ??
                0; // Provide a default value or handle accordingly
          } else {
            return 0; // Provide a default value or handle other types accordingly
          }
        })
        .where((element) => element != null)
        .toList();

    return intList;
  }

  //return null;
}
