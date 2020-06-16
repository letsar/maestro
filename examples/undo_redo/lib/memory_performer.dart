import 'dart:async';

import 'package:maestro/maestro.dart';
import 'package:undo_redo/memory.dart';

class MemoryPerformer with Performer {
  MemoryPerformer(this.memory);
  final Memory memory;
  Score _score;

  void undo() => memory.undo(_score);

  void redo() => memory.redo(_score);

  @override
  void attach(Score score) {
    _score = score;
  }

  @override
  void detach() {}

  @override
  FutureOr<void> play() {}
}
