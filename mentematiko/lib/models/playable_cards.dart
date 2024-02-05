import 'package:logging/logging.dart';

class PlayableCards {
  String value;
  late String type; //N(Numeriche), Eulero(E),Nerd(ND)
  final Map<String, String> carte = {
    'e': 'assets/cards/euler/e.png',
    'i': 'assets/cards/euler/i.png',
    'pi': 'assets/cards/euler/pi.png',
    '0': 'assets/cards/euler/0.png',
    '1': 'assets/cards/euler/1.png',
    '2': 'assets/cards/numerike/2.png',
    '3': 'assets/cards/numerike/3.png',
    '4': 'assets/cards/numerike/4.png',
    '5': 'assets/cards/numerike/5.png',
    '6': 'assets/cards/numerike/6.png',
    '7': 'assets/cards/numerike/7.png',
    '8': 'assets/cards/numerike/8.png',
    '9': 'assets/cards/numerike/9.png',
    '10': 'assets/cards/numerike/10.png',
    '11': 'assets/cards/numerike/11.png',
    '12': 'assets/cards/numerike/12.png',
    '13': 'assets/cards/numerike/13.png',
    '14': 'assets/cards/numerike/14.png',
    '15': 'assets/cards/numerike/15.png',
    '16': 'assets/cards/numerike/16.png',
    '17': 'assets/cards/numerike/17.png',
    '18': 'assets/cards/numerike/18.png',
    '19': 'assets/cards/numerike/19.png',
    '20': 'assets/cards/numerike/20.png',
    '21': 'assets/cards/numerike/21.png',
    '22': 'assets/cards/numerike/22.png',
    '23': 'assets/cards/numerike/23.png',
    '24': 'assets/cards/numerike/24.png',
    '25': 'assets/cards/numerike/25.png',
    '26': 'assets/cards/numerike/26.png',
    '27': 'assets/cards/numerike/27.png',
    '28': 'assets/cards/numerike/28.png',
    '29': 'assets/cards/numerike/29.png',
    '30': 'assets/cards/numerike/30.png',
    '31': 'assets/cards/numerike/31.png',
    '32': 'assets/cards/numerike/32.png',
    '33': 'assets/cards/numerike/33.png',
    '34': 'assets/cards/numerike/34.png',
    '35': 'assets/cards/numerike/35.png',
    '36': 'assets/cards/numerike/36.png',
    '37': 'assets/cards/numerike/37.png',
    '38': 'assets/cards/numerike/38.png',
    '39': 'assets/cards/numerike/39.png',
    '40': 'assets/cards/numerike/40.png',
    '41': 'assets/cards/numerike/41.png',
    '42': 'assets/cards/numerike/42.png',
    '43': 'assets/cards/numerike/43.png',
    '44': 'assets/cards/numerike/44.png',
    '45': 'assets/cards/numerike/45.png',
    '46': 'assets/cards/numerike/46.png',
    '47': 'assets/cards/numerike/47.png',
    '48': 'assets/cards/numerike/48.png',
    '49': 'assets/cards/numerike/49.png',
    '50': 'assets/cards/numerike/50.png',
  };
  static final _log = Logger('PlayableCards');
  static PlayableCards nullCard = PlayableCards('', '');

  PlayableCards(this.value, this.type);

  PlayableCards.buildFromValue(this.value) {
    type = _resolveType(value);
  }

  String rendering() {
    //_log.info('$value - $type');
    return carte[value]!;
  }

  static String _resolveType(String element) {
    if (int.tryParse(element) != null) {
      if (element == "0" || element == "1") {
        return "E";
      }
      return "N";
    }
    if (PlayableCards.checkIfIsEulero(element)) {
      return 'E';
    }
    return ''; //non dovrebbe accadere
  }

  static bool checkIfIsEulero(String value) {
    if (value == 'e' ||
        value == 'pi' ||
        value == 'i' ||
        value == '0' ||
        value == '1') {
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return value;
  }

  bool operator ==(Object other) {
    return other is PlayableCards && other.value == value && other.type == type;
  }
}
