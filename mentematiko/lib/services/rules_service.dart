import 'dart:math';

import 'package:card/models/player.dart';
import 'package:card/models/playable_cards.dart';
import 'package:card/models/rules_validation_result.dart';
import 'package:card/models/Room.dart';

class Rules {
  static const String DIVISIBILE = 'divisore';
  static const String MULTIPLO = 'multiplo';
  static const String SPECULARE = 'speculare';
  static const String PRIMO = 'primo';
  static const String ZERO = 'zero';
  static const String EULER_DIVERSO = 'eulerDiverso';
  static const String QUADRATO = 'quadrato';
  static const String PERFETTO = 'perfetto';
  static const String COMPLEMENTARE = 'complementare';
  static const String CUBO = 'cubo';
  static const String MCM = 'mcm';
  static const String MCD = 'mcd';
  static const String LISCIA = 'liscia';

  Player currentPlayer;
  List<String> azioniAllaFineDelPopup;
  Room tavolo;
  //List<Player> altriGiocatori;
  PlayableCards playedCard;

  // Costruttore
  Rules(
      {required this.currentPlayer,
      required this.azioniAllaFineDelPopup,
      required this.tavolo,
      required this.playedCard});

  // Metodo per eseguire le regole del gioco
  RulesValidationResult eseguiRegoleDelGioco() {
    RulesValidationResult validation = RulesValidationResult();

    List<String> allActions = [
      DIVISIBILE,
      MULTIPLO,
      SPECULARE,
      PRIMO,
      ZERO,
      EULER_DIVERSO,
      QUADRATO,
      PERFETTO,
      COMPLEMENTARE,
      CUBO,
      MCM,
      MCD,
      LISCIA
    ];

    for (var element in allActions) {
      switch (element) {
        case DIVISIBILE:
          bool isDiv = isDivisible(tavolo.piatto.first, playedCard.value);

          if (isDiv && azioniAllaFineDelPopup.contains(DIVISIBILE)) {
            int tableCard = int.parse(tavolo.piatto.first);
            int playedValue = int.parse(playedCard.value);
            validation.addValidation(DIVISIBILE,
                Validation.withResult(true, tableCard ~/ playedValue));
          } else if (isDiv && !azioniAllaFineDelPopup.contains(DIVISIBILE)) {
            validation.addValidation(
                DIVISIBILE, Validation.withOnlyVerified(false));
          } else if (!isDiv && azioniAllaFineDelPopup.contains(DIVISIBILE)) {
            validation.addValidation(
                DIVISIBILE, Validation.withOnlyVerified(false));
          }
          break;
        case MULTIPLO:
          bool isMul = isMultiple(tavolo.piatto.first, playedCard.value);

          if (isMul && azioniAllaFineDelPopup.contains(MULTIPLO)) {
            validation.addValidation(
                MULTIPLO, Validation.withOnlyVerified(true));
          } else if (isMul && !azioniAllaFineDelPopup.contains(MULTIPLO)) {
            validation.addValidation(
                MULTIPLO, Validation.withOnlyVerified(false));
          } else if (!isMul && azioniAllaFineDelPopup.contains(MULTIPLO)) {
            validation.addValidation(
                MULTIPLO, Validation.withOnlyVerified(false));
          }
          break;
        case SPECULARE:
          bool isSpec = isSpecular(tavolo.piatto.first, playedCard.value);
          if (isSpec && azioniAllaFineDelPopup.contains(SPECULARE)) {
            validation.addValidation(
                SPECULARE, Validation.withReverse(true, true));
          } else if (isSpec && !azioniAllaFineDelPopup.contains(SPECULARE)) {
            validation.addValidation(
                SPECULARE, Validation.withOnlyVerified(false));
          } else if (!isSpec && azioniAllaFineDelPopup.contains(SPECULARE)) {
            validation.addValidation(
                SPECULARE, Validation.withOnlyVerified(false));
          }
          break;
        case PRIMO:
          bool prime = isPrime(playedCard.value);
          if (prime && azioniAllaFineDelPopup.contains(PRIMO)) {
            validation.addValidation(PRIMO, Validation.withOnlyVerified(true));
          } else if (prime && !azioniAllaFineDelPopup.contains(PRIMO)) {
            validation.addValidation(PRIMO, Validation.withOnlyVerified(false));
          } else if (!prime && azioniAllaFineDelPopup.contains(PRIMO)) {
            validation.addValidation(PRIMO, Validation.withOnlyVerified(false));
          }
          break;
        case ZERO:
          bool zero = isZero(playedCard.value, tavolo.piatto.first);
          if (zero && azioniAllaFineDelPopup.contains(ZERO)) {
            validation.addValidation(ZERO, Validation.withOnlyVerified(true));
          } else if (zero && !azioniAllaFineDelPopup.contains(ZERO)) {
            validation.addValidation(ZERO, Validation.withOnlyVerified(false));
          } else if (!zero && azioniAllaFineDelPopup.contains(ZERO)) {
            validation.addValidation(ZERO, Validation.withOnlyVerified(false));
          }
          break;
        case EULER_DIVERSO:
          bool eul = isEulerDiversoDaZero(playedCard.value);
          if (eul && azioniAllaFineDelPopup.contains(EULER_DIVERSO)) {
            validation.addValidation(
                EULER_DIVERSO, Validation.withOnlyVerified(true));
          } else if (eul && !azioniAllaFineDelPopup.contains(EULER_DIVERSO)) {
            validation.addValidation(
                EULER_DIVERSO, Validation.withOnlyVerified(false));
          } else if (!eul && azioniAllaFineDelPopup.contains(EULER_DIVERSO)) {
            validation.addValidation(
                EULER_DIVERSO, Validation.withOnlyVerified(false));
          }
          break;
        case QUADRATO:
          bool square = isSquare(playedCard.value);
          if (square && azioniAllaFineDelPopup.contains(QUADRATO)) {
            validation.addValidation(QUADRATO,
                Validation.withOnlyVerified(true)); //passa untouchable a 3
          } else if (square && !azioniAllaFineDelPopup.contains(QUADRATO)) {
            validation.addValidation(
                QUADRATO, Validation.withOnlyVerified(false));
          } else if (!square && azioniAllaFineDelPopup.contains(QUADRATO)) {
            validation.addValidation(
                QUADRATO, Validation.withOnlyVerified(false));
          }
          break;
        case PERFETTO:
          bool perfect = isPerfectNumber(playedCard.value);
          if (perfect && azioniAllaFineDelPopup.contains(PERFETTO)) {
            validation.addValidation(PERFETTO,
                Validation.withResult(true, int.parse(playedCard.value)));
          } else if (perfect && !azioniAllaFineDelPopup.contains(PERFETTO)) {
            validation.addValidation(
                PERFETTO, Validation.withOnlyVerified(false));
          } else if (!perfect && azioniAllaFineDelPopup.contains(PERFETTO)) {
            validation.addValidation(
                PERFETTO, Validation.withOnlyVerified(false));
          }
          break;
        case COMPLEMENTARE:
          bool compl = complementare(tavolo.piatto.first, playedCard.value);
          if (compl && azioniAllaFineDelPopup.contains(COMPLEMENTARE)) {
            validation.addValidation(
                COMPLEMENTARE, Validation.withOnlyVerified(true));
          } else if (compl && !azioniAllaFineDelPopup.contains(COMPLEMENTARE)) {
            validation.addValidation(
                COMPLEMENTARE, Validation.withOnlyVerified(false));
          } else if (!compl && azioniAllaFineDelPopup.contains(COMPLEMENTARE)) {
            validation.addValidation(
                COMPLEMENTARE, Validation.withOnlyVerified(false));
          }
          break;
        case CUBO:
          bool cube = isCube(playedCard.value);
          if (cube && azioniAllaFineDelPopup.contains(CUBO)) {
            validation.addValidation(CUBO, Validation.withDice(true, true));
          } else if (cube && !azioniAllaFineDelPopup.contains(CUBO)) {
            validation.addValidation(CUBO, Validation.withOnlyVerified(false));
          } else if (!cube && azioniAllaFineDelPopup.contains(CUBO)) {
            validation.addValidation(CUBO, Validation.withOnlyVerified(false));
          }
          break;
        case MCM:
          bool mcm = isMcm(tavolo.piatto, playedCard.value);
          if (mcm && azioniAllaFineDelPopup.contains(MCM)) {
            validation.addValidation(MCM, Validation.withOnlyVerified(true));
          } else if (mcm && !azioniAllaFineDelPopup.contains(MCM)) {
            validation.addValidation(MCM, Validation.withOnlyVerified(false));
          } else if (!mcm && azioniAllaFineDelPopup.contains(MCM)) {
            validation.addValidation(MCM, Validation.withOnlyVerified(false));
          }
          break;
        case MCD:
          bool mcd = isMCD(tavolo.piatto, playedCard.value);
          if (mcd && azioniAllaFineDelPopup.contains(MCD)) {
            validation.addValidation(MCD, Validation.withOnlyVerified(true));
          } else if (mcd && !azioniAllaFineDelPopup.contains(MCD)) {
            validation.addValidation(MCD, Validation.withOnlyVerified(false));
          } else if (!mcd && azioniAllaFineDelPopup.contains(MCD)) {
            validation.addValidation(MCD, Validation.withOnlyVerified(false));
          }
          break;
        case LISCIA:
          bool liscia =
              isLiscia(tavolo.piatto, tavolo.piatto.first, playedCard.value);
          if (liscia && azioniAllaFineDelPopup.contains(LISCIA)) {
            validation.addValidation(LISCIA, Validation.withOnlyVerified(true));
          } else if (liscia && !azioniAllaFineDelPopup.contains(LISCIA)) {
            validation.addValidation(
                LISCIA, Validation.withOnlyVerified(false));
          } else if (!liscia && azioniAllaFineDelPopup.contains(LISCIA)) {
            validation.addValidation(
                LISCIA, Validation.withOnlyVerified(false));
          }
          break;
      }
    }
    //aggiunge la carta giocata al piatto come last-card
    tavolo.piatto.insert(0, playedCard.value);
    if(currentPlayer.random!=-1){
      //remove curse after played
      currentPlayer.random=-1;
    }
    return validation;
  }

  //regola divisore
  bool isDivisible(String firstCard, String playedCard) {
    if (isNotNumber(firstCard) || isNotNumber(playedCard)) return false;

    int firstCardValue = int.parse(firstCard);
    int playedCardValue = int.parse(playedCard);

    if (playedCardValue == 0 || firstCardValue == 0) return false;

    return firstCardValue % playedCardValue == 0;
  }

  //regola multiplo
  bool isMultiple(String firstCard, String playedCard) {
    return isDivisible(playedCard, firstCard);
  }

  //regola speculare
  bool isSpecular(String firstCard, String playedCard) {
    if (firstCard.length < 2 ||
        playedCard.length < 2 ||
        firstCard == 'pi' ||
        playedCard == 'pi') {
      return false;
    }
    if (firstCard.length != playedCard.length) {
      return false;
    }

    // Inverti la prima stringa
    String reversedfirstCard = firstCard.split('').reversed.join();

    // Confronta la stringa invertita con la seconda stringa
    return reversedfirstCard == playedCard;
  }

  //Regola numero primo
  bool isPrime(String cardValue) {
    if (isNotNumber(cardValue)) return false;

    int number = int.parse(cardValue);

    if (number <= 1) {
      return false;
    }
    if (number <= 3) {
      return true;
    }
    if (number % 2 == 0 || number % 3 == 0) {
      return false;
    }
    int i = 5;
    while (i * i <= number) {
      if (number % i == 0 || number % (i + 2) == 0) {
        return false;
      }
      i += 6;
    }
    return true;
  }

  //Euler card zero
  bool isZero(String cardValue, String lastCard) {
    if (isNotNumber(cardValue)) return false;

    if (lastCard == '0') return false;

    return cardValue == '0';
  }

  //Euler card not zero
  bool isEulerDiversoDaZero(String euler) {
    return euler == 'pi' || euler == '1' || euler == 'e' || euler == 'i';
  }

  bool isNotNumber(String str) {
    return double.tryParse(str) == null;
  }

  //Regola quadrato
  bool isSquare(String cardValue) {
    if (isNotNumber(cardValue)) return false;

    int number = int.parse(cardValue);

    int squareRoot = sqrt(number).toInt();
    return squareRoot * squareRoot == number;
  }

  // Regola numero perfetto
  bool isPerfectNumber(String cardValue) {
    if (isNotNumber(cardValue)) return false;

    int number = int.parse(cardValue);

    if (number == 0 || number == 1) return false;

    int sum = 0;
    for (int i = 1; i < number; i++) {
      if (number % i == 0) {
        sum += i;
      }
    }
    return sum == number;
  }

  //Regola complementare
  bool complementare(String firstCard, String playedCard) {
    if (isNotNumber(firstCard) || isNotNumber(playedCard)) return false;

    int firstCardValue = int.parse(firstCard);
    int playedCardValue = int.parse(playedCard);

    if (firstCardValue + playedCardValue == 50) {
      return true;
    }
    return false;
  }

  //Regola del cubo
  bool isCube(String cardValue) {
    if (isNotNumber(cardValue)) return false;

    int number = int.parse(cardValue);

    num cubeRoot = pow(number, 1 / 3);
    int cubeRootInt = cubeRoot.toInt();
    return cubeRootInt * cubeRootInt * cubeRootInt == number;
  }

  //Regola del mcm
  bool isMcm(List<String> cardsValues, String cardValue) {
    if (isNotNumber(cardValue)) return false;

    int card = int.parse(cardValue);

    if (!cardsValues.every((value) => int.tryParse(value) != null)) {
      return false;
    }

    List<int> intValues = cardsValues.map((value) => int.parse(value)).toList();
    return mcmOfList(intValues) == card;
  }

  //Regola dell'MCD
  bool isMCD(List<String> cardsValues, String cardValue) {
    if (isNotNumber(cardValue)) return false;

    int card = int.parse(cardValue);

    if (!cardsValues.every((value) => int.tryParse(value) != null)) {
      return false;
    }

    List<int> intValues = cardsValues.map((value) => int.parse(value)).toList();
    return mcdOfList(intValues) == card;
  }

  // Funzione per calcolare il massimo comune divisore (MCD) di una lista di numeri
  int mcdOfList(List<int> numbers) {
    if (numbers.isEmpty) {
      return 0;
    }
    int result = numbers[0];
    for (int i = 1; i < numbers.length; i++) {
      result = mcd(result, numbers[i]);
    }
    return result;
  }

  // Funzione per calcolare il minimo comune multiplo (mcm) di una lista di numeri
  int mcmOfList(List<int> numbers) {
    if (numbers.isEmpty) {
      return 0;
    }
    int result = numbers[0];
    for (int i = 1; i < numbers.length; i++) {
      result = mcm(result, numbers[i]);
    }
    return result;
  }

  // Funzione per calcolare il massimo comune divisore (MCD) di due numeri
  int mcd(int a, int b) {
    if (b == 0) {
      return a;
    } else {
      return mcd(b, a % b);
    }
  }

  // Funzione per calcolare il minimo comune multiplo (mcm) di due numeri
  int mcm(int a, int b) {
    return (a * b) ~/ mcd(a, b);
  }

  //Regola giocata liscia
  bool isLiscia(List<String> cardsValues, String firstCard, String card) {
    if (isEulerDiversoDaZero(card)) {
      return false;
    }

    if (isZero(card, firstCard) ||
        isSquare(card) ||
        isDivisible(firstCard, card) ||
        isMultiple(firstCard, card) ||
        isSpecular(firstCard, card) ||
        isPrime(card) ||
        isSquare(card) ||
        complementare(firstCard, card) ||
        isCube(card) ||
        isPerfectNumber(card)) {
      return false;
    }

    if (isMCD(cardsValues, firstCard) || isMcm(cardsValues, firstCard)) {
      return false;
    }

    return true;
  }
}
