import 'dart:math';

import 'package:flutter/foundation.dart';

@immutable
class PlayingCard {
  static final _random = Random();

  final int value;

  const PlayingCard(this.value);

  factory PlayingCard.fromJson(Map<String, dynamic> json) {
    return PlayingCard(
      json['value'],
    );
  }

  factory PlayingCard.random([Random? random]) {
    random ??= _random;
    return PlayingCard(
      2 + random.nextInt(9)
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlayingCard && other.value == value;
  }

  Map<String, dynamic> toJson() => {
    'value': value,
  };

  @override
  String toString() {
    return '$value';
  }
}
