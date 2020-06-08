import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:maestro/src/common.dart';
import 'package:maestro/src/inspector.dart';

/// A widget exposing a value of type [T] to its descendants.
/// Its descendants can read the value or write a new value. When the value is
/// replaced, all descendants who listen a specific [Maestro] will be rebuilt.
class Maestro<T> extends StatefulWidget implements Relocatable<Maestro<T>> {
  /// Stores the [initialValue] and exposes it to its descendants.
  ///
  /// `equalityComparer` can optionally be passed to avoid unnecessarily
  /// rebuilding dependents when [Maestro] is rebuilt but its `value`
  /// did not change.
  ///
  /// Defaults to `(previous, next) => previous != next`.
  const Maestro(
    this.initialValue, {
    Key key,
    this.equalityComparer,
    this.child,
  }) : super(key: key);

  /// The initial value held by this widget.
  final T initialValue;

  /// Used to compare old and new values in order to rebuild its descendants
  /// only when these values are not considered equals.
  ///
  /// Defaults to `(previous, next) => previous != next`.
  final EqualityComparer<T> equalityComparer;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Maestro<T> copyWithNewChild(Widget newChild) {
    return Maestro<T>(
      initialValue,
      key: key,
      equalityComparer: equalityComparer,
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

  /// {@template maestro.readAndWrite}
  /// Gests and Sets the value from the nearest ancestor [Maestro<T>].
  /// {@endtemplate}
  static void readAndWrite<T>(
    BuildContext context,
    Updater<T> updater, [
    Object action,
  ]) {
    context.readAndWrite(updater, action);
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

  @override
  _MaestroState createState() => _MaestroState<T>();
}

class _MaestroState<T> extends State<Maestro<T>> implements Score {
  T get value => _value;
  T _value;
  void _dispatch(_Wrapper<T> wrapper) {
    final T oldValue = _value;

    setState(() {
      _value = wrapper.value;
    });
    _inspect(oldValue, value, wrapper.action);
  }

  void _inspect(T oldValue, T value, Object action) {
    bool bubbling = true;
    _MaestroScope<MaestroInspector> inspector =
        context._getMaestroScope<MaestroInspector>();
    while (inspector != null && bubbling) {
      bubbling = !inspector.value.onAction(oldValue, value, action);
      inspector = inspector.state.context._getMaestroScope<MaestroInspector>();
    }
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    final T value = _value;
    if (value is Performer) {
      value.attach(this);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        value.play();
      });
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
  X read<X>() {
    return Maestro.read<X>(context);
  }

  @override
  void readAndWrite<X>(Updater<X> updater, [Object action]) {
    Maestro.readAndWrite<X>(context, updater, action);
  }

  @override
  void write<X>(X value, [Object action]) {
    Maestro.write<X>(context, value, action);
  }

  bool _updateShouldNotify(T oldValue, T newValue) {
    if (widget.equalityComparer != null) {
      return !widget.equalityComparer(oldValue, newValue);
    } else {
      return oldValue != newValue;
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

@immutable
class _Wrapper<T> {
  const _Wrapper(this.value, this.action);
  final Object action;
  final T value;
}

class _MaestroScope<T> extends InheritedModel<_Aspect<T, dynamic>> {
  const _MaestroScope({
    Key key,
    Widget child,
    this.value,
    this.state,
  }) : super(
          key: key,
          child: child,
        );

  final T value;
  final _MaestroState<T> state;

  @override
  bool updateShouldNotify(_MaestroScope<T> oldWidget) {
    return state._updateShouldNotify(oldWidget.value, value);
  }

  @override
  bool updateShouldNotifyDependent(
    _MaestroScope<T> oldWidget,
    Set<_Aspect<T, dynamic>> dependencies,
  ) {
    return dependencies.any((aspect) {
      return aspect.updateShouldNotify(
        oldWidget.value,
        value,
      );
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('value', value));
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
  /// {@macro  maestro.listen}
  T listen<T>() {
    return _dependOnMaestroScope<T>()?.value;
  }

  /// {@macro  maestro.read}
  T read<T>() {
    return _getMaestroScope<T>()?.value;
  }

  // ignore: use_setters_to_change_properties
  /// {@macro  maestro.write}
  void write<T>(T value, [Object action]) {
    _getMaestroScope<T>()?.state?._dispatch(_Wrapper<T>(value, action));
  }

  /// {@macro  maestro.readAndWrite}
  void readAndWrite<T>(Updater<T> updater, [Object action]) {
    final _MaestroScope<T> scope = _getMaestroScope<T>();
    scope.state._dispatch(_Wrapper<T>(updater(scope.value), action));
  }

  /// {@macro  maestro.select}
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
