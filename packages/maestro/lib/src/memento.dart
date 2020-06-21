import 'package:flutter/widgets.dart';
import 'package:maestro/src/common.dart';
import 'package:maestro/src/evicting_queue.dart';
import 'package:maestro/src/inspector.dart';
import 'package:maestro/src/maestro.dart';

class _Variation<T> {
  const _Variation(this.oldState, this.newState, this.action);

  final T oldState;
  final T newState;
  final Object action;

  void undo(BuildContext context) {
    context.write<T>(oldState, UndoAction._(action));
  }

  void redo(BuildContext context) {
    context.write<T>(newState, RedoAction._(action));
  }
}

/// The action wrapping the action to undo or redo.
abstract class MementoAction {
  const MementoAction._(
    this._name,
    Object action,
  ) : action = action ?? '';

  final String _name;

  /// The wrapped action.
  final Object action;

  @override
  String toString() {
    return '$_name $action';
  }
}

/// The action wrapping the action to undo.
class UndoAction extends MementoAction {
  const UndoAction._(Object action) : super._('undo', action);
}

/// The action wrapping the action to redo.
class RedoAction extends MementoAction {
  const RedoAction._(Object action) : super._('redo', action);
}

class _Memento<T> implements Inspector {
  _Memento(int maxCapacity)
      : _undoStack = EvictingQueue<_Variation>(maxCapacity),
        _redoStack = EvictingQueue<_Variation>(maxCapacity);

  final EvictingQueue<_Variation> _undoStack;
  final EvictingQueue<_Variation> _redoStack;

  void undo(BuildContext context) {
    if (_undoStack.isNotEmpty) {
      final _Variation variation = _undoStack.dequeue();
      _redoStack.enqueue(variation);
      variation.undo(context);
    }
  }

  void redo(BuildContext context) {
    if (_redoStack.isNotEmpty) {
      final _Variation variation = _redoStack.dequeue();
      _undoStack.enqueue(variation);
      variation.redo(context);
    }
  }

  @override
  bool onAction<X>(X oldValue, X newValue, Object action) {
    if (action is! MementoAction && oldValue is T && newValue is T) {
      _undoStack.enqueue(_Variation<X>(oldValue, newValue, action));
      _redoStack.clear();
    }
    return false;
  }
}

/// A special Maestro used to remember all the states of type [T].
/// A [Maestro<T>] must be a descendants of this widget in order for it to
/// capture the state variations.
///
/// To undo/redo an action, you can call the methods [undo] and [redo] on a
/// [BuildContext] or from a [Composer].
class MaestroMemento<T> extends StatefulWidget
    with Relocatable<MaestroMemento<T>> {
  /// Creates a [MaestroMemento<T>].
  const MaestroMemento({
    Key key,
    this.maxCapacity = _defaultMaxCapacity,
    this.child,
  })  : assert(maxCapacity != null && maxCapacity > 0),
        super(key: key);

  static const int _defaultMaxCapacity = 16;

  /// The maximum number of states remembered.
  final int maxCapacity;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  MaestroMemento<T> copyWithNewChild(Widget newChild) {
    return MaestroMemento<T>(
      key: key,
      maxCapacity: maxCapacity,
      child: newChild,
    );
  }

  @override
  _MaestroMementoState<T> createState() => _MaestroMementoState<T>();
}

class _MaestroMementoState<T> extends State<MaestroMemento<T>> {
  _Memento<T> memento;

  @override
  void initState() {
    super.initState();
    memento = _Memento<T>(widget.maxCapacity);
  }

  @override
  Widget build(BuildContext context) {
    return Maestro<Inspector>.readOnly(
      memento,
      child: Maestro<_Memento<T>>(
        memento,
        child: widget.child,
      ),
    );
  }
}

/// Extensions methods concerning the undo/redo feature.
extension MementoBuildContextExtensions on BuildContext {
  /// {@template maestro.undo}
  /// Reverts the last action on type [T].
  ///
  /// There must be a [MaestroMemento<T>] declared before the [Maestro<T>].
  /// {@endtemplate}
  void undo<T>() => read<_Memento<T>>()?.undo(this);

  /// {@template maestro.redo}
  /// Reverts the last undone command on type [T].
  ///
  /// There must be a [MaestroMemento<T>] declared before the [Maestro<T>].
  /// {@endtemplate}
  void redo<T>() => read<_Memento<T>>()?.redo(this);
}
