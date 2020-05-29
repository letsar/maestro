import 'package:flutter/widgets.dart';
import 'package:maestro/src/common.dart';

/// A widget that merges multiple maestros into a single linear widget tree.
/// It is used to improve readability and reduce boilerplate code of having to
/// nest multiple layers of maestros.
///
/// As such, we're going from:
///
/// ```dart
/// Maestro(
///   Something(),
///   child: Maestro(
///     SomethingElse(),
///     child: Maestro(
///       AnotherThing(),
///       child: someWidget,
///     ),
///   ),
/// ),
/// ```
///
/// To:
///
/// ```dart
/// Maestros(
///   [
///     Maestro(Something()),
///     Maestro(SomethingElse()),
///     Maestro(AnotherThing()),
///   ],
///   child: someWidget,
/// )
/// ```
///
/// The widget tree representation of the two approaches are identical.
class Maestros extends StatelessWidget {
  /// Creates a tree of [Maestro] from the specified list.
  const Maestros(
    this.maestros, {
    Key key,
    @required this.child,
  })  : assert(maestros != null),
        assert(child != null),
        super(key: key);

  /// The list of [Maestro] to insert in the same order in the tree.
  ///
  /// Remark: we use a [Relocatable] type in order to have type inference.
  /// Without it, the following code wouldn't compile:
  /// ```dart
  /// Maestros(
  ///   [
  ///     Maestro(Something()),
  ///     Maestro(SomethingElse()),
  ///   ],
  ///   child: someWidget,
  /// )
  /// ```
  final List<Relocatable> maestros;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget widget = child;

    for (int i = maestros.length - 1; i >= 0; i--) {
      final Relocatable relocatable = maestros[i];
      assert(relocatable != null);
      widget = relocatable.copyWithNewChild(widget);
    }

    return widget;
  }
}
