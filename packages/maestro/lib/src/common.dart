import 'dart:async';

import 'package:flutter/widgets.dart';

/// A predicate to determine if to value are considered equals.
///
/// Used by [Maestro] to compare old and new valuees.
typedef EqualityComparer<T> = bool Function(T x, T y);

/// Signature for a method which updates a value.
typedef Updater<T> = T Function(T current);

/// An interface for reading and writing values held by [Maestro]s.
abstract class Score {
  /// Gets a value from the nearest ancestor [Maestro<X>] without listenening
  /// for changes.
  X read<X>();

  /// Updates the value from the nearest ancestor [Maestro<X>].
  void update<X>(Updater<X> updater, [Object action]);

  /// Sets the value from the nearest ancestor [Maestro<X>].
  void write<X>(X value, [Object action]);

  /// {@macro maestro.undo}
  void undo<X>();

  /// {@macro maestro.redo}
  void redo<X>();
}

/// An interface for classes that wants to perform actions on some [Maestro]
/// ancestors.
abstract class Performer {
  /// Called when the [Performer] is added in the tree.
  ///
  /// This is called internally. You should not call this method.
  void attach(Score score);

  /// Called the first time the [Performer] is added in the tree.
  /// This can be overriden to perform an action when the [Performer] is added
  /// the first time in the tree. Loading data and update a model for example.
  ///
  /// This is called internally. You should not call this method.
  FutureOr<void> play();

  /// Called when the [Performer] is removed from the tree.
  ///
  /// This is called internally. You should not call this method.
  void detach();
}

/// An interface for widgets, with one child, able to be relocated at another
/// location in the widget tree.
mixin Relocatable<T extends Widget> on Widget {
  /// Creates a new widget of type [T] with the specified [newChild].
  T copyWithNewChild(Widget newChild);
}

/// A specific action when a value is updated due to a widget which was updated.
@immutable
class WidgetUpdatedAction {
  /// Creates a [WidgetUpdatedAction].
  const WidgetUpdatedAction();

  @override
  String toString() => 'maestro.widget_updated';
}
