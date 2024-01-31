import 'dart:math';

import 'package:card/models/player.dart';
import 'package:card/models/playable_cards.dart';
import 'package:card/models/player_actions.dart';
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
  Rules({
    required this.currentPlayer,
    required this.azioniAllaFineDelPopup,
    required this.tavolo,
   // required this.altriGiocatori,
    required this.playedCard
  });

  // Metodo per eseguire le regole del gioco
  PlayerActions eseguiRegoleDelGioco() {

    List<String> listaCorretti = [];
    List<String> listaErrori = [];
    List<String> allActions = [DIVISIBILE, MULTIPLO, SPECULARE, PRIMO, ZERO, EULER_DIVERSO, QUADRATO, PERFETTO, COMPLEMENTARE, CUBO, MCM, MCD, LISCIA];

    //caso in cui last card è 0
    if(tavolo.piatto.first == '0'){
      for (var action in azioniAllaFineDelPopup){
        if( action == DIVISIBILE ){
          listaCorretti.add(DIVISIBILE);
        } else {
          listaErrori.add(action);
        }
      }
      return PlayerActions(listaCorretti: [...listaCorretti], listaErrori: [...listaErrori]);
    }
    
    for (var element in allActions) {
      switch (element){
        case DIVISIBILE:
          bool isDiv = isDivisible(tavolo.piatto.first, playedCard.value);
          if(isDiv && azioniAllaFineDelPopup.contains(DIVISIBILE)){
            listaCorretti.add(DIVISIBILE);
          } else if(isDiv && !azioniAllaFineDelPopup.contains(DIVISIBILE)){
            listaErrori.add(DIVISIBILE);
          } else if(!isDiv && azioniAllaFineDelPopup.contains(DIVISIBILE)){
            listaErrori.add(DIVISIBILE);
          }
          break;
        case MULTIPLO:
          bool isMul = isMultiple(tavolo.piatto.first, playedCard.value);
          if(isMul && azioniAllaFineDelPopup.contains(MULTIPLO)){
            listaCorretti.add(MULTIPLO);
          } else if(isMul && !azioniAllaFineDelPopup.contains(MULTIPLO)){
            listaErrori.add(MULTIPLO);
          } else if(!isMul && azioniAllaFineDelPopup.contains(MULTIPLO)){
            listaErrori.add(MULTIPLO);
          }
          break;
        case SPECULARE:
          bool isSpec = isSpecular(tavolo.piatto.first, playedCard.value);
          if(isSpec && azioniAllaFineDelPopup.contains(SPECULARE)){
            listaCorretti.add(SPECULARE);
          } else if(isSpec && !azioniAllaFineDelPopup.contains(SPECULARE)){
            listaErrori.add(SPECULARE);
          } else if(!isSpec && azioniAllaFineDelPopup.contains(SPECULARE)){
            listaErrori.add(SPECULARE);
          }
          break;
        case PRIMO:
          bool isPrimo = isPrime(playedCard.value);
          if(isPrimo && azioniAllaFineDelPopup.contains(PRIMO)){
            listaCorretti.add(PRIMO);
          } else if(isPrimo && !azioniAllaFineDelPopup.contains(PRIMO)){
            listaErrori.add(PRIMO);
          } else if(!isPrimo && azioniAllaFineDelPopup.contains(PRIMO)){
            listaErrori.add(PRIMO);
          }
          break;
        case ZERO:
          bool isZ = isZero(playedCard.value, playedCard.value);
          if(isZ && azioniAllaFineDelPopup.contains(ZERO)){
            listaCorretti.add(ZERO);
          } else if(isZ && !azioniAllaFineDelPopup.contains(ZERO)){
            listaErrori.add(ZERO);
          } else if(!isZ && azioniAllaFineDelPopup.contains(ZERO)){
            listaErrori.add(ZERO);
          }
          break;
        case EULER_DIVERSO:
          bool isEuler = isEulerDiversoDaZero(playedCard.value);
          if(isEuler && azioniAllaFineDelPopup.contains(EULER_DIVERSO)){
            listaCorretti.add(EULER_DIVERSO);
          } else if(isEuler && !azioniAllaFineDelPopup.contains(EULER_DIVERSO)){
            listaErrori.add(EULER_DIVERSO);
          } else if(!isEuler && azioniAllaFineDelPopup.contains(EULER_DIVERSO)){
            listaErrori.add(EULER_DIVERSO);
          }
          break;
        case QUADRATO:
          bool isSqua = isSquare(playedCard.value);
          if(isSqua && azioniAllaFineDelPopup.contains(QUADRATO)){
            listaCorretti.add(QUADRATO);
          } else if(isSqua && !azioniAllaFineDelPopup.contains(QUADRATO)){
            listaErrori.add(QUADRATO);
          } else if(!isSqua && azioniAllaFineDelPopup.contains(QUADRATO)){
            listaErrori.add(QUADRATO);
          }
          break;
        case PERFETTO:
          bool isPerfect = isPerfectNumber(playedCard.value);
          if(isPerfect && azioniAllaFineDelPopup.contains(PERFETTO)){
            listaCorretti.add(PERFETTO);
          } else if(isPerfect && !azioniAllaFineDelPopup.contains(PERFETTO)){
            listaErrori.add(PERFETTO);
          } else if(!isPerfect && azioniAllaFineDelPopup.contains(PERFETTO)){
            listaErrori.add(PERFETTO);
          }
          break;
        case COMPLEMENTARE:
          bool isCompl = complementare(tavolo.piatto.first, playedCard.value);
          if(isCompl && azioniAllaFineDelPopup.contains(COMPLEMENTARE)){
            listaCorretti.add(COMPLEMENTARE);
          } else if(isCompl && !azioniAllaFineDelPopup.contains(COMPLEMENTARE)){
            listaErrori.add(COMPLEMENTARE);
          } else if(!isCompl && azioniAllaFineDelPopup.contains(COMPLEMENTARE)){
            listaErrori.add(COMPLEMENTARE);
          }
          break;
        case CUBO:
          bool isCu = isCube(playedCard.value);
          if(isCu && azioniAllaFineDelPopup.contains(CUBO)){
            listaCorretti.add(CUBO);
          } else if(isCu && !azioniAllaFineDelPopup.contains(CUBO)){
            listaErrori.add(CUBO);
          } else if(!isCu && azioniAllaFineDelPopup.contains(CUBO)){
            listaErrori.add(CUBO);
          }
          break;
        case MCM:
          bool mcm = isMcm(tavolo.piatto, playedCard.value);
          if(mcm && azioniAllaFineDelPopup.contains(MCM)){
            listaCorretti.add(MCM);
          } else if(mcm && !azioniAllaFineDelPopup.contains(MCM)){
            listaErrori.add(MCM);
          } else if(!mcm && azioniAllaFineDelPopup.contains(MCM)){
            listaErrori.add(MCM);
          }
          break;
        case MCD:
          bool mcd = isMCD(tavolo.piatto, playedCard.value);
          if(mcd && azioniAllaFineDelPopup.contains(MCD)){
            listaCorretti.add(MCD);
          } else if(mcd && !azioniAllaFineDelPopup.contains(MCD)){
            listaErrori.add(MCD);
          } else if(!mcd && azioniAllaFineDelPopup.contains(MCD)){
            listaErrori.add(MCD);
          }
          break;
        case LISCIA:
          bool liscia = isLiscia(tavolo.piatto, tavolo.piatto.first, playedCard.value);
          if(liscia && azioniAllaFineDelPopup.contains(LISCIA)){
            listaCorretti.add(LISCIA);
          } else if(liscia && !azioniAllaFineDelPopup.contains(LISCIA)){
            listaErrori.add(LISCIA);
          } else if(liscia && azioniAllaFineDelPopup.contains(LISCIA)){
            listaErrori.add(LISCIA);
          }
          break;
      }
    }

      return PlayerActions(listaCorretti: [...listaCorretti], listaErrori: [...listaErrori]);
  }

  //regola divisore
  bool isDivisible(String firstCard, String playedCard) {
    if(isNotNumber(firstCard) || isNotNumber(playedCard)) return false;
    
    int firstCardValue = int.parse(firstCard);
    int playedCardValue = int.parse(playedCard);
    
    if(firstCardValue == 0 || playedCardValue == 0) return false;

    return firstCardValue % playedCardValue == 0;
  }

  //regola multiplo
  bool isMultiple(String firstCard, String playedCard) {
    return isDivisible(playedCard, firstCard);
  }

  //regola speculare
  bool isSpecular(String firstCard, String playedCard) { 
    if(firstCard.length<2 || playedCard.length<2 || firstCard == 'pi' || playedCard== 'pi'){
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
    if(isNotNumber(cardValue)) return false;

    int number  = int.parse(cardValue);
    
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
  bool isZero(String cardValue, String lastCard){
    if(isNotNumber(cardValue)) return false;
    
    if(lastCard == '0') return false;
    
    return cardValue == '0';
  }

  //Euler card not zero
  bool isEulerDiversoDaZero(String euler){
    return euler == 'pi' || euler == '1' || euler == 'e' || euler == 'i';
  }

  bool isNotNumber(String str) {
    return double.tryParse(str) == null;
  }

  //Regola quadrato
  bool isSquare(String cardValue){
    if(isNotNumber(cardValue)) return false;

    int number  = int.parse(cardValue);

    int squareRoot = sqrt(number).toInt();
    return squareRoot * squareRoot == number;
  }

  // Regola numero perfetto
  bool isPerfectNumber(String cardValue){
    if(isNotNumber(cardValue)) return false;

    int number  = int.parse(cardValue);

    if( number == 0 || number == 1) return false;
    
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
    if(isNotNumber(firstCard) || isNotNumber(playedCard)) return false;

    int firstCardValue = int.parse(firstCard);
    int playedCardValue = int.parse(playedCard);

    if(firstCardValue + playedCardValue == 50){
      return true;
    }
    return false;
  }

  //Regola del cubo
  bool isCube(String cardValue){
    if(isNotNumber(cardValue)) return false;

    int number  = int.parse(cardValue);

    num cubeRoot = pow(number, 1/3);
    int cubeRootInt = cubeRoot.toInt();
    return cubeRootInt * cubeRootInt * cubeRootInt == number;
  }

  //Regola del mcm
  bool isMcm(List<String> cardsValues, String cardValue){
    if(isNotNumber(cardValue)) return false;

    int card  = int.parse(cardValue);

    if (!cardsValues.every((value) => int.tryParse(value) != null)) {
      return false;
    }

    List<int> intValues = cardsValues.map((value) => int.parse(value)).toList();
    return mcmOfList(intValues) == card;
  }

  //Regola dell'MCD
  bool isMCD(List<String> cardsValues, String cardValue){
    if(isNotNumber(cardValue)) return false;

    int card  = int.parse(cardValue);

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
  bool isLiscia(List<String> cardsValues, String firstCard, String card){
    if(isEulerDiversoDaZero(card)){
      return false;
    }

    if(isZero(card, firstCard) || isSquare(card) || isDivisible(firstCard, card) || isMultiple(firstCard, card) ||
    isSpecular(firstCard, card) || isPrime(card) || isSquare(card) || complementare(firstCard, card)
    || isCube(card)){
      return false;
    }

    if(isMCD(cardsValues, firstCard) || isMcm(cardsValues, firstCard)){
      return false;
    }

    return true;
  }
}