import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:maestro/src/common.dart';

/// A specific [Performer] which can easily access ancestors [Maestro]s
/// in order to compose with the app data.
mixin Composer implements Performer {
  Score _score;

  @override
  void attach(Score score) {
    _score = score;
    play();
  }

  /// Called when the composer can read the score.
  @protected
  FutureOr<void> play() {}

  /// Reads the value of the nearest [Maestro<T>] ancestor in the tree.
  @protected
  T read<T>() => _score.read<T>();

  /// Writes the value of the nearest [Maestro<T>] ancestor in the tree.
  @protected
  void write<T>(T value, [Object action]) => _score.write(value, action);

  @override
  void detach() {}
}
