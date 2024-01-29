import 'dart:math';

import 'package:card/models/player.dart';
import 'package:card/models/playable_cards.dart';
import 'package:card/models/player_actions.dart';
import 'package:card/models/Room.dart';

class Rules {
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
    List<String> allActions = ['divisore', 'multiplo', 'speculare', 'primo', 'zero', 'eulerDiverso', 'quadrato', 'perfetto', 'complementare', 'cubo', 'mcm', 'mcd', 'liscia'];

    if(isNotNumber(playedCard.value)){ //caso in cui la carta giocata non è un numero
      if(!azioniAllaFineDelPopup.contains('eulerDiverso')){
         listaErrori.add('eulerDiverso');
      }
      for (var element in azioniAllaFineDelPopup) {
        switch (element){
          case 'divisore':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('divisore');
            }
            break;
          case 'multiplo':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('multiplo');
            }
            break;
          case 'speculare':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('speculare');
            }
            break;
          case 'primo':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('primo');
            }
            break;
          case 'zero':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('zero');
            }
            break;
          case 'eulerDiverso':
            if(azioniAllaFineDelPopup.contains(element) && isEulerDiversoDaZero(playedCard.value)){
              listaCorretti.add('eulerDiverso');
            } else if(!azioniAllaFineDelPopup.contains(element) && isEulerDiversoDaZero(playedCard.value)){
              listaErrori.add('eulerDiverso');
            }
            break;
          case 'quadrato':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('quadrato');
            }
            break;
          case 'perfetto':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('perfetto');
            }
            break;
          case 'complementare':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('complementare');
            }
            break;
          case 'cubo':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('cubo');
            }
            break;
          case 'mcm':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('mcm');
            }
            break;
          case 'mcd':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('mcd');
            }
            break;
          case 'liscia':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('liscia');
            }
            break;
        }
      }

      return PlayerActions(listaCorretti: [...listaCorretti], listaErrori: [...listaErrori]);

    } else if(isNotNumber(tavolo.piatto.last)){ //caso in cui la last card non è un numero
      int playedCardValue = playedCard.value as int; //do per assodato che la player card sia numerica per condizione sopra

      for (var element in azioniAllaFineDelPopup) {
        switch (element){
          case 'divisore':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('divisore');
            }
            break;
          case 'multiplo':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('multiplo');
            }
            break;
          case 'speculare':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('speculare');
            }
            break;
          case 'primo':
            if(isPrime(playedCardValue) && azioniAllaFineDelPopup.contains('primo')){
              listaCorretti.add('primo');
            } else if(isPrime(playedCardValue) && !azioniAllaFineDelPopup.contains('primo')){
              listaErrori.add('primo');
            } else if(!isPrime(playedCardValue) && azioniAllaFineDelPopup.contains('primo')){
              listaErrori.add('primo');
            }
            break;
          case 'zero':
            if(isZero(playedCardValue) && azioniAllaFineDelPopup.contains('zero')){
              listaCorretti.add('zero');
            } else if(isZero(playedCardValue) && !azioniAllaFineDelPopup.contains('zero')){
              listaErrori.add('zero');
            } else if(!isZero(playedCardValue) && azioniAllaFineDelPopup.contains('zero')){
              listaErrori.add('zero');
            }
            break;
          case 'eulerDiverso':
            if(isEulerDiversoDaZero(playedCardValue as String) && azioniAllaFineDelPopup.contains('eulerDiverso')){
              listaCorretti.add('eulerDiverso');
            } else if(isEulerDiversoDaZero(playedCardValue as String) && !azioniAllaFineDelPopup.contains('eulerDiverso')){
              listaErrori.add('eulerDiverso');
            } else if(!isEulerDiversoDaZero(playedCardValue as String) && azioniAllaFineDelPopup.contains('eulerDiverso')){
              listaErrori.add('eulerDiverso');
            }
            break;
          case 'quadrato':
            if(isSquare(playedCardValue) && azioniAllaFineDelPopup.contains('quadrato')){
              listaCorretti.add('quadrato');
            } else if(isSquare(playedCardValue) && !azioniAllaFineDelPopup.contains('quadrato')){
              listaErrori.add('quadrato');
            } else if(!isSquare(playedCardValue) && azioniAllaFineDelPopup.contains('quadrato')){
              listaErrori.add('quadrato');
            }
            break;
          case 'perfetto':
            if(isPerfectNumber(playedCardValue) && azioniAllaFineDelPopup.contains('perfetto')){
              listaCorretti.add('perfetto');
            } else if(isPerfectNumber(playedCardValue) && !azioniAllaFineDelPopup.contains('perfetto')){
              listaErrori.add('perfetto');
            } else if(!isPerfectNumber(playedCardValue) && azioniAllaFineDelPopup.contains('perfetto')){
              listaErrori.add('perfetto');
            }
            break;
          case 'complementare':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('complementare');
            }
            break;
          case 'cubo':
            if(isCube(playedCardValue) && azioniAllaFineDelPopup.contains('cubo')){
              listaCorretti.add('cubo');
            } else if(isCube(playedCardValue) && !azioniAllaFineDelPopup.contains('cubo')){
              listaErrori.add('cubo');
            } else if(!isCube(playedCardValue) && azioniAllaFineDelPopup.contains('cubo')){
              listaErrori.add('cubo');
            }
            break;
          case 'mcm':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('mcm');
            }
            break;
          case 'mcd':
            if(azioniAllaFineDelPopup.contains(element)){
              listaErrori.add('mcd');
            }
            break;
          case 'liscia':
            if(isLiscia(tavolo.piatto, tavolo.piatto.last, playedCard.value) && azioniAllaFineDelPopup.contains('liscia')){
              listaCorretti.add('liscia');
            } else if(isLiscia(tavolo.piatto, tavolo.piatto.last, playedCard.value) && !azioniAllaFineDelPopup.contains('liscia')){
              listaErrori.add('liscia');
            } else if(!isLiscia(tavolo.piatto, tavolo.piatto.last, playedCard.value) && azioniAllaFineDelPopup.contains('liscia')){
              listaErrori.add('liscia');
            }
            break;
        }
      }

      return PlayerActions(listaCorretti: [...listaCorretti], listaErrori: [...listaErrori]);

    }else { // last card e carta giocata numeri
      int lastCardValue = tavolo.piatto.last as int;
      int playedCardValue = playedCard.value as int;
      for (var element in allActions) {
        switch (element){
          case 'divisore':
            if(isDivisible(lastCardValue, playedCardValue) && azioniAllaFineDelPopup.contains('divisore')){
              listaCorretti.add('divisore');
            } else if(isDivisible(lastCardValue, playedCardValue) && !azioniAllaFineDelPopup.contains('divisore')){
              listaErrori.add('divisore');
            } else if(!isDivisible(lastCardValue, playedCardValue) && azioniAllaFineDelPopup.contains('divisore')){
              listaErrori.add('divisore');
            }
            break;
          case 'moltiplo':
            if(isMultiple(lastCardValue, playedCardValue) && azioniAllaFineDelPopup.contains('moltiplo')){
              listaCorretti.add('moltiplo');
            } else if(isMultiple(lastCardValue, playedCardValue) && !azioniAllaFineDelPopup.contains('moltiplo')){
              listaErrori.add('moltiplo');
            } else if(!isMultiple(lastCardValue, playedCardValue) && azioniAllaFineDelPopup.contains('moltiplo')){
              listaErrori.add('moltiplo');
            }
            break;
          case 'speculare':
            if(isSpecular(lastCardValue, playedCardValue) && azioniAllaFineDelPopup.contains('speculare')){
              listaCorretti.add('speculare');
            } else if(isSpecular(lastCardValue, playedCardValue) && !azioniAllaFineDelPopup.contains('speculare')){
              listaErrori.add('speculare');
            } else if(!isSpecular(lastCardValue, playedCardValue) && azioniAllaFineDelPopup.contains('speculare')){
              listaErrori.add('speculare');
            }
            break;
          case 'primo':
            if(isPrime(playedCardValue) && azioniAllaFineDelPopup.contains('primo')){
              listaCorretti.add('primo');
            } else if(isPrime(playedCardValue) && !azioniAllaFineDelPopup.contains('primo')){
              listaErrori.add('primo');
            } else if(!isPrime(playedCardValue) && azioniAllaFineDelPopup.contains('primo')){
              listaErrori.add('primo');
            }
            break;
          case 'zero':
            if(isZero(playedCardValue) && azioniAllaFineDelPopup.contains('zero')){
              listaCorretti.add('zero');
            } else if(isZero(playedCardValue) && !azioniAllaFineDelPopup.contains('zero')){
              listaErrori.add('zero');
            } else if(!isZero(playedCardValue) && azioniAllaFineDelPopup.contains('zero')){
              listaErrori.add('zero');
            }
            break;
          case 'eulerDiverso':
            if(isEulerDiversoDaZero(playedCardValue as String) && azioniAllaFineDelPopup.contains('eulerDiverso')){
              listaCorretti.add('eulerDiverso');
            } else if(isEulerDiversoDaZero(playedCardValue as String) && !azioniAllaFineDelPopup.contains('eulerDiverso')){
              listaErrori.add('eulerDiverso');
            } else if(!isEulerDiversoDaZero(playedCardValue as String) && azioniAllaFineDelPopup.contains('eulerDiverso')){
              listaErrori.add('eulerDiverso');
            }
            break;
          case 'quadrato':
            if(isSquare(playedCardValue) && azioniAllaFineDelPopup.contains('quadrato')){
              listaCorretti.add('quadrato');
            } else if(isSquare(playedCardValue) && !azioniAllaFineDelPopup.contains('quadrato')){
              listaErrori.add('quadrato');
            } else if(!isSquare(playedCardValue) && azioniAllaFineDelPopup.contains('quadrato')){
              listaErrori.add('quadrato');
            }
            break;
          case 'perfetto':
            if(isPerfectNumber(playedCardValue) && azioniAllaFineDelPopup.contains('perfetto')){
              listaCorretti.add('perfetto');
            } else if(isPerfectNumber(playedCardValue) && !azioniAllaFineDelPopup.contains('perfetto')){
              listaErrori.add('perfetto');
            } else if(!isPerfectNumber(playedCardValue) && azioniAllaFineDelPopup.contains('perfetto')){
              listaErrori.add('perfetto');
            }
            break;
          case 'complementare':
            if(complementare(lastCardValue, playedCardValue) && azioniAllaFineDelPopup.contains('complementare')){
              listaCorretti.add('complementare');
            } else if(complementare(lastCardValue, playedCardValue) && !azioniAllaFineDelPopup.contains('complementare')){
              listaErrori.add('complementare');
            } else if(!complementare(lastCardValue, playedCardValue) && azioniAllaFineDelPopup.contains('complementare')){
              listaErrori.add('complementare');
            }
            break;
          case 'cubo':
            if(isCube(playedCardValue) && azioniAllaFineDelPopup.contains('cubo')){
              listaCorretti.add('cubo');
            } else if(isCube(playedCardValue) && !azioniAllaFineDelPopup.contains('cubo')){
              listaErrori.add('cubo');
            } else if(!isCube(playedCardValue) && azioniAllaFineDelPopup.contains('cubo')){
              listaErrori.add('cubo');
            }
            break;
          case 'mcm':
            if(isMcm(tavolo.piatto, playedCardValue) && azioniAllaFineDelPopup.contains('mcm')){
              listaCorretti.add('mcm');
            } else if(isMcm(tavolo.piatto, playedCardValue) && !azioniAllaFineDelPopup.contains('mcm')){
              listaErrori.add('mcm');
            } else if(!isMcm(tavolo.piatto, playedCardValue) && azioniAllaFineDelPopup.contains('mcm')){
              listaErrori.add('mcm');
            }
            break;
          case 'mcd':
            if(isMCD(tavolo.piatto, playedCardValue) && azioniAllaFineDelPopup.contains('mcd')){
              listaCorretti.add('mcd');
            } else if(isMCD(tavolo.piatto, playedCardValue) && !azioniAllaFineDelPopup.contains('mcd')){
              listaErrori.add('mcd');
            } else if(!isMCD(tavolo.piatto, playedCardValue) && azioniAllaFineDelPopup.contains('mcd')){
              listaErrori.add('mcd');
            }
            break;
          case 'liscia':
            if(isLiscia(tavolo.piatto, tavolo.piatto.last, playedCard.value) && azioniAllaFineDelPopup.contains('liscia')){
              listaCorretti.add('liscia');
            } else if(isLiscia(tavolo.piatto, tavolo.piatto.last, playedCard.value) && !azioniAllaFineDelPopup.contains('liscia')){
              listaErrori.add('liscia');
            } else if(!isLiscia(tavolo.piatto, tavolo.piatto.last, playedCard.value) && azioniAllaFineDelPopup.contains('liscia')){
              listaErrori.add('liscia');
            }
            break;
        }
      }

      return PlayerActions(listaCorretti: [...listaCorretti], listaErrori: [...listaErrori]);
    }
  }

  void divisoreEffetti(){
    //TODO Sia q il quoziente della divisione tra la last card l e la carta giocata g. Il team che scarta il divisore 
    //g raccoglie dal piatto le ultime q carte scartate lasciando al loro posto quella giocata, che diventa 
    //la nuova last card.

  }

  //regola divisore
  bool isDivisible(int lastCardValue, int playedCardValue) {
    return lastCardValue % playedCardValue == 0;
  }

  //regola multiplo
  bool isMultiple(int lastCardValue, int playedCardValue) {
    return isDivisible(playedCardValue, lastCardValue);
  }

  //regola speculare
  bool isSpecular(int number1, int number2) {
    String strNumber1 = number1.toString();
    String strNumber2 = number2.toString();
  
    if (strNumber1.length != strNumber2.length) {
      return false;
    }
  
    // Inverti la prima stringa
    String reversedStrNumber1 = strNumber1.split('').reversed.join();
  
    // Confronta la stringa invertita con la seconda stringa
    return reversedStrNumber1 == strNumber2;
  }

  //Regola numero primo
  bool isPrime(int number) {
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
  bool isZero(int number){
    return number == 0;
  }

  //Euler card not zero
  bool isEulerDiversoDaZero(String euler){
    return euler != '0' && isNotNumber(euler);
  }

  bool isNotNumber(String str) {
    return double.tryParse(str) == null;
  }

  //Regola quadrato
  bool isSquare(int number) {
    int squareRoot = sqrt(number).toInt();
    return squareRoot * squareRoot == number;
  }

  // Regola numero perfetto
  bool isPerfectNumber(int number) {
    int sum = 0;
    for (int i = 1; i < number; i++) {
      if (number % i == 0) {
        sum += i;
      }
    }
    return sum == number;
  }

  //Regola complementare
  bool complementare(int lastCardValue, int played){
    if(lastCardValue + played == 50){
      return true;
    }
    return false;
  }

  //Regola del cubo
  bool isCube(int number) {
    num cubeRoot = pow(number, 1/3);
    int cubeRootInt = cubeRoot.toInt();
    return cubeRootInt * cubeRootInt * cubeRootInt == number;
  }

  //Regola del mcm
  bool isMcm(List<String> cardsValues, int card) {
    if (!cardsValues.every((value) => int.tryParse(value) != null)) {
      return false;
    }

    List<int> intValues = cardsValues.map((value) => int.parse(value)).toList();
    return mcmOfList(intValues) == card;
  }

  //Regola dell'MCD
  bool isMCD(List<String> cardsValues, int card){
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
  bool isLiscia(List<String> cardsValues, String lastCard, String card){
    if(isEulerDiversoDaZero(card)){
      return false;
    }
    
    int lastCardValue = lastCard as int;
    int cardValue = card as int;

    if(isZero(cardValue) || isSquare(cardValue) || isDivisible(lastCardValue, cardValue) || isMultiple(lastCardValue, cardValue) ||
    isSpecular(lastCardValue, cardValue) || isPrime(cardValue) || isSquare(cardValue) || complementare(lastCardValue, cardValue)
    || isCube(cardValue)){
      return false;
    }

    if(isMCD(cardsValues, lastCardValue) || isMcm(cardsValues, lastCardValue)){
      return false;
    }

    return true;
  }
}