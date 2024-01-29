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
          if(isMultiple(tavolo.piatto.first, playedCard.value) && azioniAllaFineDelPopup.contains(MULTIPLO)){
            listaCorretti.add(MULTIPLO);
          } else if(isMultiple(tavolo.piatto.first, playedCard.value) && !azioniAllaFineDelPopup.contains(MULTIPLO)){
            listaErrori.add(MULTIPLO);
          } else if(!isMultiple(tavolo.piatto.first, playedCard.value) && azioniAllaFineDelPopup.contains(MULTIPLO)){
            listaErrori.add(MULTIPLO);
          }
          break;
        case SPECULARE:
          if(isSpecular(tavolo.piatto.first, playedCard.value) && azioniAllaFineDelPopup.contains(SPECULARE)){
            listaCorretti.add(SPECULARE);
          } else if(isSpecular(tavolo.piatto.first, playedCard.value) && !azioniAllaFineDelPopup.contains(SPECULARE)){
            listaErrori.add(SPECULARE);
          } else if(!isSpecular(tavolo.piatto.first, playedCard.value) && azioniAllaFineDelPopup.contains(SPECULARE)){
            listaErrori.add(SPECULARE);
          }
          break;
        case PRIMO:
          if(isPrime(playedCard.value) && azioniAllaFineDelPopup.contains(PRIMO)){
            listaCorretti.add(PRIMO);
          } else if(isPrime(playedCard.value) && !azioniAllaFineDelPopup.contains(PRIMO)){
            listaErrori.add(PRIMO);
          } else if(!isPrime(playedCard.value) && azioniAllaFineDelPopup.contains(PRIMO)){
            listaErrori.add(PRIMO);
          }
          break;
        case ZERO:
          if(isZero(playedCard.value) && azioniAllaFineDelPopup.contains(ZERO)){
            listaCorretti.add(ZERO);
          } else if(isZero(playedCard.value) && !azioniAllaFineDelPopup.contains(ZERO)){
            listaErrori.add(ZERO);
          } else if(!isZero(playedCard.value) && azioniAllaFineDelPopup.contains(ZERO)){
            listaErrori.add(ZERO);
          }
          break;
        case EULER_DIVERSO:
          if(isEulerDiversoDaZero(playedCard.value as String) && azioniAllaFineDelPopup.contains(EULER_DIVERSO)){
            listaCorretti.add(EULER_DIVERSO);
          } else if(isEulerDiversoDaZero(playedCard.value as String) && !azioniAllaFineDelPopup.contains(EULER_DIVERSO)){
            listaErrori.add(EULER_DIVERSO);
          } else if(!isEulerDiversoDaZero(playedCard.value as String) && azioniAllaFineDelPopup.contains(EULER_DIVERSO)){
            listaErrori.add(EULER_DIVERSO);
          }
          break;
        case QUADRATO:
          if(isSquare(playedCard.value) && azioniAllaFineDelPopup.contains(QUADRATO)){
            listaCorretti.add(QUADRATO);
          } else if(isSquare(playedCard.value) && !azioniAllaFineDelPopup.contains(QUADRATO)){
            listaErrori.add(QUADRATO);
          } else if(!isSquare(playedCard.value) && azioniAllaFineDelPopup.contains(QUADRATO)){
            listaErrori.add(QUADRATO);
          }
          break;
        case PERFETTO:
          if(isPerfectNumber(playedCard.value) && azioniAllaFineDelPopup.contains(PERFETTO)){
            listaCorretti.add(PERFETTO);
          } else if(isPerfectNumber(playedCard.value) && !azioniAllaFineDelPopup.contains(PERFETTO)){
            listaErrori.add(PERFETTO);
          } else if(!isPerfectNumber(playedCard.value) && azioniAllaFineDelPopup.contains(PERFETTO)){
            listaErrori.add(PERFETTO);
          }
          break;
        case COMPLEMENTARE:
          if(complementare(tavolo.piatto.first, playedCard.value) && azioniAllaFineDelPopup.contains(COMPLEMENTARE)){
            listaCorretti.add(COMPLEMENTARE);
          } else if(complementare(tavolo.piatto.first, playedCard.value) && !azioniAllaFineDelPopup.contains(COMPLEMENTARE)){
            listaErrori.add(COMPLEMENTARE);
          } else if(!complementare(tavolo.piatto.first, playedCard.value) && azioniAllaFineDelPopup.contains(COMPLEMENTARE)){
            listaErrori.add(COMPLEMENTARE);
          }
          break;
        case CUBO:
          if(isCube(playedCard.value) && azioniAllaFineDelPopup.contains(CUBO)){
            listaCorretti.add(CUBO);
          } else if(isCube(playedCard.value) && !azioniAllaFineDelPopup.contains(CUBO)){
            listaErrori.add(CUBO);
          } else if(!isCube(playedCard.value) && azioniAllaFineDelPopup.contains(CUBO)){
            listaErrori.add(CUBO);
          }
          break;
        case MCM:
          if(isMcm(tavolo.piatto, playedCard.value) && azioniAllaFineDelPopup.contains(MCM)){
            listaCorretti.add(MCM);
          } else if(isMcm(tavolo.piatto, playedCard.value) && !azioniAllaFineDelPopup.contains(MCM)){
            listaErrori.add(MCM);
          } else if(!isMcm(tavolo.piatto, playedCard.value) && azioniAllaFineDelPopup.contains(MCM)){
            listaErrori.add(MCM);
          }
          break;
        case MCD:
          if(isMCD(tavolo.piatto, playedCard.value) && azioniAllaFineDelPopup.contains(MCD)){
            listaCorretti.add(MCD);
          } else if(isMCD(tavolo.piatto, playedCard.value) && !azioniAllaFineDelPopup.contains(MCD)){
            listaErrori.add(MCD);
          } else if(!isMCD(tavolo.piatto, playedCard.value) && azioniAllaFineDelPopup.contains(MCD)){
            listaErrori.add(MCD);
          }
          break;
        case LISCIA:
          if(isLiscia(tavolo.piatto, tavolo.piatto.first, playedCard.value) && azioniAllaFineDelPopup.contains(LISCIA)){
            listaCorretti.add(LISCIA);
          } else if(isLiscia(tavolo.piatto, tavolo.piatto.first, playedCard.value) && !azioniAllaFineDelPopup.contains(LISCIA)){
            listaErrori.add(LISCIA);
          } else if(!isLiscia(tavolo.piatto, tavolo.piatto.first, playedCard.value) && azioniAllaFineDelPopup.contains(LISCIA)){
            listaErrori.add(LISCIA);
          }
          break;
      }
    }

      return PlayerActions(listaCorretti: [...listaCorretti], listaErrori: [...listaErrori]);
  }

  void divisoreEffetti(){
    //TODO Sia q il quoziente della divisione tra la first card l e la carta giocata g. Il team che scarta il divisore 
    //g raccoglie dal piatto le ultime q carte scartate lasciando al loro posto quella giocata, che diventa 
    //la nuova first card.

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
  bool isZero(String cardValue){
    if(isNotNumber(cardValue)) return false;

    int number  = int.parse(cardValue);

    return number == 0;
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

    if(isZero(card) || isSquare(card) || isDivisible(firstCard, card) || isMultiple(firstCard, card) ||
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