import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:maestro/src/common.dart';
import 'package:maestro/src/inspector.dart';
import 'package:maestro/src/memento.dart';

/// A widget exposing a value of type [T] to its descendants.
/// Its descendants can read the value or write a new value. When the value is
/// replaced, all descendants who listen a specific [Maestro] will be rebuilt.
class Maestro<T> extends StatefulWidget with Relocatable<Maestro<T>> {
  /// Stores the [initialValue] and exposes it to its descendants.
  ///
  /// `equalityComparer` can optionally be passed to avoid unnecessarily
  /// rebuilding dependents when [Maestro] is rebuilt but its `value`
  /// did not change.
  ///
  /// Defaults to `(previous, next) => previous != next`.
  ///
  /// Its internal value can only be udpated by descendants using the [write]
  /// method on [Maestro].
  const Maestro(
    T initialValue, {
    Key key,
    EqualityComparer<T> equalityComparer,
    Widget child,
  }) : this._(
          initialValue,
          key: key,
          equalityComparer: equalityComparer,
          readOnly: false,
          child: child,
        );

  /// Stores the [initialValue] and exposes it to its descendants.
  ///
  /// `equalityComparer` can optionally be passed to avoid unnecessarily
  /// rebuilding dependents when [Maestro] is rebuilt but its `value`
  /// did not change.
  ///
  /// Defaults to `(previous, next) => previous != next`.
  ///
  /// Its internal value can only be updated by its parent by recreating another
  /// [Maestro] with a different value.
  const Maestro.readOnly(
    T value, {
    Key key,
    EqualityComparer<T> equalityComparer,
    ValueChanged<WritingRequest<T>> onWrite,
    Widget child,
  }) : this._(
          value,
          key: key,
          equalityComparer: equalityComparer,
          onWrite: onWrite,
          readOnly: true,
          child: child,
        );

  const Maestro._(
    this.value, {
    Key key,
    this.equalityComparer,
    this.onWrite,
    bool readOnly,
    this.child,
  })  : _readOnly = readOnly,
        super(key: key);

  /// The value held by this widget.
  final T value;

  /// Used to compare old and new values in order to rebuild its descendants
  /// only when these values are not considered equals.
  ///
  /// Defaults to `(previous, next) => previous != next`.
  final EqualityComparer<T> equalityComparer;

  /// Called for a [Maestro.readOnly] when a descendant want to write its value.
  final ValueChanged<WritingRequest<T>> onWrite;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  final bool _readOnly;

  @override
  Maestro<T> copyWithNewChild(Widget newChild) {
    return Maestro<T>._(
      value,
      key: key,
      equalityComparer: equalityComparer,
      onWrite: onWrite,
      readOnly: _readOnly,
      child: newChild,
    );
  }

  /// {@template maestro.listen}
  /// Gets a value from the nearest ancestor [Maestro<T>] and listens for
  /// changes.
  /// {@endtemplate}
  static T listen<T>(BuildContext context) {
    return context.listen<T>();
  }

  /// {@template maestro.read}
  /// Gets a value from the nearest ancestor [Maestro<T>] without listenening
  /// for changes.
  /// {@endtemplate}
  static T read<T>(BuildContext context) {
    return context.read<T>();
  }

  /// {@template maestro.write}
  /// Sets the value from the nearest ancestor [Maestro<T>].
  /// {@endtemplate}
  static void write<T>(BuildContext context, T value, [Object action]) {
    context.write(value, action);
  }

  /// {@template maestro.update}
  /// Gests and Sets the value from the nearest ancestor [Maestro<T>].
  /// {@endtemplate}
  static void update<T>(
    BuildContext context,
    Updater<T> updater, [
    Object action,
  ]) {
    context.update(updater, action);
  }

  /// {@template maestro.select}
  /// Gets a value from the nearest ancestor [Maestro<T>] and transforms it
  /// into a new value.
  ///
  /// The widget calling this method will be rebuilt only when the selecting
  /// value has changed.
  ///
  /// For example, consider this user model.
  /// ```dart
  /// class User {
  ///   const User(this.name, this.age);
  ///
  ///   final String name;
  ///   final int age;
  /// }
  /// ```
  ///
  /// If a widget doesn't care about the user's name but only wants to listen
  /// to its age, then it can do this:
  ///
  /// ```dart
  /// Widget build(BuildContext context){
  ///   final int age = Maestro.select<User,int>((user) => user.age);
  ///   return Text(age.toString());
  /// }
  /// ```
  ///
  /// The [equalityComparer] is used to compare old and new values in order to
  /// determine when we should rebuild.
  /// {@endtemplate}
  static R select<T, R>(
    BuildContext context,
    R Function(T value) selector, {
    EqualityComparer<R> equalityComparer,
  }) {
    assert(context != null);
    assert(selector != null);
    return context.select(selector, equalityComparer: equalityComparer);
  }

  /// {@macro maestro.undo}
  static void undo<T>(BuildContext context) => context.undo<T>();

  /// {@macro maestro.redo}
  static void redo<T>(BuildContext context) => context.redo<T>();

  @override
  _MaestroState<T> createState() => _MaestroState<T>();
}

class _MaestroState<T> extends State<Maestro<T>> implements Score {
  T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    final T value = _value;
    if (value is Performer) {
      value.attach(this);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        value.play();
      });
    }
  }

  @override
  void didUpdateWidget(Maestro<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final T newValue = widget.value;
    if (widget._readOnly) {
      _dispatch(WritingRequest<T>(newValue, const WidgetUpdatedAction()));
    }
  }

  @override
  void dispose() {
    final T value = _value;
    if (value is Performer) {
      value.detach();
    }
    super.dispose();
  }

  @override
  X read<X>() => context.read<X>();

  @override
  void update<X>(Updater<X> updater, [Object action]) =>
      context.update<X>(updater, action);

  @override
  void write<X>(X value, [Object action]) => context.write<X>(value, action);

  @override
  void redo<X>() => context.redo<X>();

  @override
  void undo<X>() => context.undo<X>();

  void _write(WritingRequest<T> writingRequest) {
    if (_updateShouldNotify(writingRequest.value)) {
      if (widget._readOnly) {
        if (widget.onWrite != null) {
          widget.onWrite(writingRequest);
        }
      } else {
        _dispatch(writingRequest);
      }
    }
  }

  void _dispatch(WritingRequest<T> writingRequest) {
    final T oldValue = _value;
    setState(() {
      _value = writingRequest.value;
    });
    _inspect(oldValue, _value, writingRequest.action);
  }

  void _inspect(T oldValue, T value, Object action) {
    bool bubbling = true;
    _MaestroScope<Inspector> inspector = context._getMaestroScope<Inspector>();
    while (inspector != null && bubbling) {
      bubbling = !inspector.value.onAction(oldValue, value, action);
      inspector = inspector.state.context._getMaestroScope<Inspector>();
    }
  }

  bool _updateShouldNotify(T otherValue) {
    if (widget.equalityComparer != null) {
      return !widget.equalityComparer(_value, otherValue);
    } else {
      return _value != otherValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _MaestroScope<T>(
      value: _value,
      state: this,
      child: widget.child,
    );
  }
}

/// Represents a writing request.
class WritingRequest<T> {
  /// Creates a [WritingRequest<T>].
  const WritingRequest(this.value, this.action);

  /// The new value to write.
  final T value;

  /// The action.
  final Object action;
}

class _MaestroScope<T> extends InheritedModel<_Aspect<T, dynamic>> {
  const _MaestroScope({
    Key key,
    @required T value,
    @required this.state,
    Widget child,
  })  : assert(state != null),
        _value = value,
        super(key: key, child: child);

  final T _value;

  T get value => state._value;

  final _MaestroState<T> state;

  @override
  bool updateShouldNotify(_MaestroScope<T> oldWidget) {
    return state._updateShouldNotify(oldWidget._value);
  }

  @override
  bool updateShouldNotifyDependent(
    _MaestroScope<T> oldWidget,
    Set<_Aspect<T, dynamic>> dependencies,
  ) {
    return dependencies.any((aspect) {
      return aspect.updateShouldNotify(oldWidget._value, _value);
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('value', _value));
  }
}

class _Aspect<T, R> {
  const _Aspect(this.selector, this.equalityComparer);

  final R Function(T value) selector;

  final EqualityComparer<R> equalityComparer;

  bool updateShouldNotify(T oldValue, T value) {
    final R oldSelectedValue = selector(oldValue);
    final R selectedValue = selector(value);
    if (equalityComparer != null) {
      return !equalityComparer(oldSelectedValue, selectedValue);
    } else {
      return !const DeepCollectionEquality().equals(
        oldSelectedValue,
        selectedValue,
      );
    }
  }
}

/// Extensions for [BuildContext].
extension MaestroBuildContextExtensions on BuildContext {
  /// {@macro maestro.listen}
  T listen<T>() {
    return _dependOnMaestroScope<T>()?.value;
  }

  /// {@macro maestro.read}
  T read<T>() {
    return _getMaestroScope<T>()?.value;
  }

  /// {@macro maestro.write}
  void write<T>(T value, [Object action]) {
    _getMaestroScope<T>()?.state?._write(WritingRequest<T>(value, action));
  }

  /// {@macro maestro.update}
  void update<T>(Updater<T> updater, [Object action]) {
    final _MaestroScope<T> scope = _getMaestroScope<T>();
    scope.state._write(WritingRequest<T>(updater(scope.value), action));
  }

  /// {@macro maestro.select}
  R select<T, R>(
    R Function(T value) selector, {
    EqualityComparer<R> equalityComparer,
  }) {
    final _Aspect<T, R> aspect = _Aspect<T, R>(
      selector,
      equalityComparer,
    );
    final _MaestroScope<T> scope = _dependOnMaestroScope<T>(aspect: aspect);
    return aspect.selector(scope.value);
  }

  _MaestroScope<T> _getMaestroScope<T>() {
    return getElementForInheritedWidgetOfExactType<_MaestroScope<T>>()?.widget
        as _MaestroScope<T>;
  }

  _MaestroScope<T> _dependOnMaestroScope<T>({Object aspect}) {
    return dependOnInheritedWidgetOfExactType<_MaestroScope<T>>(aspect: aspect);
  }
}
