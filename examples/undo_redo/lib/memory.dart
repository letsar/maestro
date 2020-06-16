import 'dart:collection';

import 'package:maestro/maestro.dart';

class _Command<T> {
  const _Command(
    this.oldState,
    this.newState,
    this.action,
  );
  final T oldState;
  final T newState;
  final Object action;

  void undo(Score score) {
    score.write<T>(oldState, UndoAction(action));
  }

  void redo(Score score) {
    score.write<T>(newState, RedoAction(action));
  }
}

abstract class MemoryAction {
  const MemoryAction(
    this.name,
    Object action,
  ) : action = action ?? '';

  final Object action;
  final String name;

  @override
  String toString() {
    return '$name $action';
  }
}

class UndoAction extends MemoryAction {
  const UndoAction(Object action) : super('undo', action);
}

class RedoAction extends MemoryAction {
  const RedoAction(Object action) : super('redo', action);
}

class Memory implements MaestroInspector {
  ListQueue<_Command> _undoStack = ListQueue<_Command>();
  ListQueue<_Command> _redoStack = ListQueue<_Command>();

  void undo(Score score) {
    if (_undoStack.isNotEmpty) {
      final _Command command = _undoStack.removeFirst();
      _redoStack.addFirst(command);
      command.undo(score);
    }
  }

  void redo(Score score) {
    if (_redoStack.isNotEmpty) {
      final _Command command = _redoStack.removeFirst();
      _undoStack.addFirst(command);
      command.redo(score);
    }
  }

  @override
  bool onAction<T>(T oldValue, T value, Object action) {
    if (action is! MemoryAction) {
      _undoStack.addFirst(_Command<T>(oldValue, value, action));
      _redoStack.clear();
    }

    return false;
  }
}
