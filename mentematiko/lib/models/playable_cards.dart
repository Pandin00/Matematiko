import 'dart:collection';

class PlayableCards {
  String value;
  late String type; //N(Numeriche), Eulero(E),Nerd(ND)
  final Map<String, String> carte = {
    'e' : 'assets/cards/EulerCards/e.png',
    'i' : 'assets/cards/EulerCards/i.png',
    'pi' : 'assets/cards/EulerCards/pi.png',
    '0' : 'assets/cards/EulerCards/0.png',
    '1' : 'assets/cards/EulerCards/1.png',
    '2' : 'assets/cards/carteNumerike/2.png',
    '3' : 'assets/cards/carteNumerike/3.png',
    '4' : 'assets/cards/carteNumerike/4.png',
    '5' : 'assets/cards/carteNumerike/5.png',
    '6' : 'assets/cards/carteNumerike/6.png',
    '7' : 'assets/cards/carteNumerike/7.png',
    '8' : 'assets/cards/carteNumerike/8.png',
    '9' : 'assets/cards/carteNumerike/9.png',
    '10' : 'assets/cards/carteNumerike/10.png',
    '11' : 'assets/cards/carteNumerike/11.png',
    '12' : 'assets/cards/carteNumerike/12.png',
    '13' : 'assets/cards/carteNumerike/13.png',
    '14' : 'assets/cards/carteNumerike/14.png',
    '15' : 'assets/cards/carteNumerike/15.png',
    '16' : 'assets/cards/carteNumerike/16.png',
    '17' : 'assets/cards/carteNumerike/17.png',
    '18' : 'assets/cards/carteNumerike/18.png',
    '19' : 'assets/cards/carteNumerike/19.png',
    '20' : 'assets/cards/carteNumerike/20.png',
    '21' : 'assets/cards/carteNumerike/21.png',
    '22' : 'assets/cards/carteNumerike/22.png',
    '23' : 'assets/cards/carteNumerike/23.png',
    '24' : 'assets/cards/carteNumerike/24.png',
    '25' : 'assets/cards/carteNumerike/25.png',
    '26' : 'assets/cards/carteNumerike/26.png',
    '27' : 'assets/cards/carteNumerike/27.png',
    '28' : 'assets/cards/carteNumerike/28.png',
    '29' : 'assets/cards/carteNumerike/29.png',
    '30' : 'assets/cards/carteNumerike/30.png',
    '31' : 'assets/cards/carteNumerike/31.png',
    '32' : 'assets/cards/carteNumerike/32.png',
    '33' : 'assets/cards/carteNumerike/33.png',
    '34' : 'assets/cards/carteNumerike/34.png',
    '35' : 'assets/cards/carteNumerike/35.png',
    '36' : 'assets/cards/carteNumerike/36.png',
    '37' : 'assets/cards/carteNumerike/37.png',
    '38' : 'assets/cards/carteNumerike/38.png',
    '39' : 'assets/cards/carteNumerike/39.png',
    '40' : 'assets/cards/carteNumerike/40.png',
    '41' : 'assets/cards/carteNumerike/41.png',
    '42' : 'assets/cards/carteNumerike/42.png',
    '43' : 'assets/cards/carteNumerike/43.png',
    '44' : 'assets/cards/carteNumerike/44.png',
    '45' : 'assets/cards/carteNumerike/45.png',
    '46' : 'assets/cards/carteNumerike/46.png',
    '47' : 'assets/cards/carteNumerike/47.png',
    '48' : 'assets/cards/carteNumerike/48.png',
    '49' : 'assets/cards/carteNumerike/49.png',
    '50' : 'assets/cards/carteNumerike/50.png',
  };

  static PlayableCards nullCard = PlayableCards('', '');

  PlayableCards(this.value, this.type);

  PlayableCards.buildFromValue(this.value) {
    type=_resolveType(value);
  }

  String? rendering() {
    return carte[value];
  }

  static String _resolveType(String element) {
    if (int.tryParse(element)!=null) {
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
}
