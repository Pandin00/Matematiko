class PlayableCards {
  String value;
  late String type; //N(Numeriche), Eulero(E),Nerd(ND)

  static PlayableCards nullCard = PlayableCards('', '');

  PlayableCards(this.value, this.type);

  PlayableCards.buildFromValue(this.value) {
    type=_resolveType(value);
  }

  void rendering() {
    //implementare switch case o mappa statica che associa valore a immagine carta
  }

  static String _resolveType(String element) {
    if (element is int) {
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
