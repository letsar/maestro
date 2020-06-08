/// Signature for logging an action.
///
/// Return true to cancel the action bubbling.
/// Return false to allow the action to continue to be dispatched to further
/// ancestors.
///
/// Used by [MaestroInspector].
typedef OnAction = bool Function<T>(T oldValue, T value, Object action);

/// A special kind of component which can be used to inspect all value changes
/// in the tree.
///
/// All [Maestro]s will look to the nearest [Maestro] ancestor with a
/// [MaestroInspector] value in the tree and call its [onAction] method
/// whenever the [Maestro]'s value changed.
abstract class MaestroInspector {
  /// Creates a [MaestroInspector].
  const factory MaestroInspector(OnAction onAction) =
      _DelegatedMaestroInspector;

  /// Called every time the value of a [Maestro] child changes.
  ///
  /// Return true to cancel the action bubbling.
  /// Return false to allow the action to continue to be dispatched to further
  /// ancestors.
  bool onAction<T>(T oldValue, T value, Object action);
}

class _DelegatedMaestroInspector implements MaestroInspector {
  const _DelegatedMaestroInspector(this._onAction) : assert(_onAction != null);

  final OnAction _onAction;

  @override
  bool onAction<T>(T oldValue, T value, Object action) {
    return _onAction(oldValue, value, action);
  }
}
