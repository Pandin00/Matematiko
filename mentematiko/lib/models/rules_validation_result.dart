import 'dart:core';

class RulesValidationResult {
  //codice validazione
  Map<String, Validation> validationMap = {};

  void addValidation(String ruleName, Validation validation) {
    validationMap.putIfAbsent(ruleName, () => validation);
  }
}

//singola validazione
class Validation {
  bool verified = true; //se true ok;
  int result = -1; // se > 0 serve caso 1
  bool reverse = false; //reverse caso 3
  bool dice = false; //true se devi tirare il dado caso 

  Validation(this.verified, this.result, this.reverse, this.dice);

  Validation.withOnlyVerified(this.verified);

  Validation.withResult(this.verified, this.result);

  Validation.withReverse(this.verified, this.reverse);

  Validation.withDice(this.verified, this.dice);

  @override
  String toString() {
    return "{verified: $verified result: $result reverse: $reverse dice: $dice}";
  }
}
