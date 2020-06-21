import 'package:flutter/widgets.dart';
import 'package:maestro/src/common.dart';
import 'package:maestro/src/maestro.dart';

/// {@template maestro.selector}
/// An equivalent to [MaestroListener] that can filter updates by selecting a
/// limited amount of values and prevent rebuild if they don't change.
///
/// [MaestroSelector] will obtain a value using [Maestro.select], then pass that
/// value to `selector`. That `selector` callback is then tasked to return an
/// object that contains only the information needed for `builder` to complete.
///
/// By default, [MaestroSelector] determines if `builder` needs to be called
/// again by comparing the previous and new result of `selector` using
/// [DeepCollectionEquality] from the package `collection`.
///
/// This behavior can be overridden by passing a custom `equalityComparer`
/// callback.
///
///  **NOTE**:
/// The selected value must be immutable, or otherwise [MaestroSelector] may
/// think nothing changed and not call `builder` again.
///
/// As such, its `selector` should return either a collection
/// ([List]/[Map]/[Set]/[Iterable]) or a class that overrides `==`.
///
/// To select multiple values without having to write a class that implements
/// `==`, the easiest solution is to use a "Tuple" from
/// [tuple](https://pub.dev/packages/tuple):
///
/// ```dart
/// MaestroSelector<Foo, Tuple2<Bar, Baz>>(
///   selector: (_, foo) => Tuple2(foo.bar, foo.baz),
///   builder: (_, data, __) {
///     return Text('${data.item1}  ${data.item2}');
///   }
/// )
/// ```
///
/// In that example, `builder` will be called again only if `foo.bar` or
/// `foo.baz` changes.
/// {@endtemplate}
class MaestroSelector<T, R> extends StatelessWidget {
  /// Creates a [MaestroSelector].
  ///
  /// The [selector] and the [builder] must not be null.
  const MaestroSelector({
    Key key,
    @required this.selector,
    @required this.builder,
    this.equalityComparer,
    this.child,
  })  : assert(selector != null),
        assert(builder != null),
        super(key: key);

  /// A function which transforms a value of type [T] into another object
  /// of type [R].
  ///
  /// The type [R] must implement [operator==].
  final R Function(T value) selector;

  /// Called every time the selected value changed.
  final ValueWidgetBuilder<R> builder;

  /// Used to compare old and new values in order to rebuild this widget
  /// only when these values are not considered equals.
  ///
  /// Defaults to `(x, y) => !const DeepCollectionEquality().equals(x, y)`.
  final EqualityComparer<R> equalityComparer;

  /// The child widget to pass to the [builder].
  ///
  /// If a [builder] callback's return value contains a subtree that does not
  /// depend on the selected value, it's more efficient to build that subtree
  /// once instead of rebuilding it each time the selected value changed.
  ///
  /// If the pre-built subtree is passed as the [child] parameter, the
  /// [MaestroSelector] will pass it back to the [builder] function so that it
  /// can be incorporated into the build.
  ///
  /// Using this pre-built child is entirely optional, but can improve
  /// performance significantly in some cases and is therefore a good practice.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final R value = Maestro.select(
      context,
      selector,
      equalityComparer: equalityComparer,
    );
    return builder(context, value, child);
  }
}
