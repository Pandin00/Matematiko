import 'dart:math';

import 'package:card/game_internals/player.dart';
import 'package:card/models/playable_cards.dart';
import 'package:card/models/room.dart';

class Rules {
  Player currentPlayer;
  List<String> azioniAllaFineDelPopup;
  Room tavolo;
  List<Player> altriGiocatori;
  PlayableCards playedCard;

  // Costruttore
  Rules({
    required this.currentPlayer,
    required this.azioniAllaFineDelPopup,
    required this.tavolo,
    required this.altriGiocatori,
    required this.playedCard
  });

  // Metodo per eseguire le regole del gioco
  void eseguiRegoleDelGioco() {
    // Implementa qui le regole del gioco
    // Ricorda di fare un check a priori sul valore della carta, 
    // se è una euler card può fare solo un tot di regole(potrebbe causare errore perché non tutte numeriche)
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
    // Utilizziamo il metodo "tryParse" per convertire la stringa in un numero
    // Se la conversione ha successo, allora la stringa è un numero
    // Altrimenti, se il risultato è null, la stringa non è un numero
    return double.tryParse(str) == null;
  }

  //Regola quadrato
  bool isSquare(int number) {
    int squareRoot = sqrt(number).toInt();
    return squareRoot * squareRoot == number;
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
  bool isMcm(List<int> cardsValues, int card) {
    return mcmOfList(cardsValues) ==  card;
  }

  //Regola dell'MCD
  bool isMCD(List<int> cardsValues, int card){
    return mcdOfList(cardsValues) == card;
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

    //questo controllo è da implementare anche prima di chiamare i controlli su MCD e mcm
    for (String str in cardsValues) {
      if (isNotNumber(str)) {
        return true; // do per assodato che con un valore non numerico non possa essere fatto MCD e mcm
      }
    }

    List<int> cardsNumeric = cardsValues.map((str) => int.parse(str)).toList();
    if(isMCD(cardsNumeric, lastCardValue) || isMcm(cardsNumeric, lastCardValue)){
      return false;
    }

    return true;
  }
}