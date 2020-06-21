import 'package:flutter/widgets.dart';
import 'package:maestro/src/common.dart';
import 'package:maestro/src/maestro.dart';

/// Signature for logging an action.
///
/// Return true to cancel the action bubbling.
/// Return false to allow the action to continue to be dispatched to further
/// ancestors.
///
/// Used by [Inspector].
typedef OnAction = bool Function<T>(T oldValue, T newValue, Object action);

/// A special kind of component which can be used to inspect all value changes
/// in the tree.
///
/// All [Maestro]s will look to the nearest [Maestro] ancestor with a
/// [Inspector] value in the tree and call its [onAction] method
/// whenever the [Maestro]'s value changed.
abstract class Inspector {
  /// Creates a [Inspector].
  const factory Inspector(OnAction onAction) = _DelegatedInspector;

  /// Called every time the value of a [Maestro] child changes.
  ///
  /// Return true to cancel the action bubbling.
  /// Return false to allow the action to continue to be dispatched to further
  /// ancestors.
  bool onAction<T>(T oldValue, T newValue, Object action);
}

class _DelegatedInspector implements Inspector {
  const _DelegatedInspector(this._onAction) : assert(_onAction != null);

  final OnAction _onAction;

  @override
  bool onAction<T>(T oldValue, T newValue, Object action) {
    return _onAction(oldValue, newValue, action);
  }
}

/// A special [Maestro] used to inspect all value changes in descendants.
///
/// All [Maestro]s will look to the nearest [Maestro] ancestor with a
/// [Inspector] value in the tree and call its [onAction] method
/// whenever the [Maestro]'s value changed.
class MaestroInspector extends StatelessWidget
    with Relocatable<MaestroInspector> {
  /// Exposes the specified [onAction] through a [Maestro<Inspector>].
  MaestroInspector(
    OnAction onAction, {
    Key key,
    Widget child,
  }) : this.custom(
          _DelegatedInspector(onAction),
          key: key,
          child: child,
        );

  /// Exposes the specified [inspector] through a [Maestro<Inspector>].
  const MaestroInspector.custom(
    this.inspector, {
    Key key,
    this.child,
  })  : assert(inspector != null),
        super(key: key);

  /// The inspector exposed by this widget.
  final Inspector inspector;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  MaestroInspector copyWithNewChild(Widget newChild) {
    return MaestroInspector.custom(
      inspector,
      key: key,
      child: newChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Maestro<Inspector>(
      inspector,
      child: child,
    );
  }
}
