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
  }

  @override
  FutureOr<void> play() {}

  /// Reads the value of the nearest [Maestro<T>] ancestor in the tree.
  @protected
  T read<T>() => _score.read<T>();

  /// Updates the value of the nearest [Maestro<T>] ancestor in the tree.
  @protected
  void update<T>(Updater<T> updater, [Object action]) =>
      _score.update<T>(updater, action);

  /// Writes the value of the nearest [Maestro<T>] ancestor in the tree.
  @protected
  void write<T>(T value, [Object action]) => _score.write(value, action);

  @override
  void detach() {}
}
