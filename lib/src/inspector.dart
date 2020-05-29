typedef OnValueUpdated = void Function<T>(T oldValue, T value);

/// A special kind of component which can be used to inspect all value changes
/// in the tree.
///
/// All [Maestro]s will look to the nearest [Maestro] ancestor with a
/// [MaestroInspector] value in the tree and call its [onValueUpdated] method
/// whenever the [Maestro]'s value changed.
abstract class MaestroInspector {
  /// Creates a [MaestroInspector].
  const factory MaestroInspector(OnValueUpdated onValueUpdated) =
      _DelegatedMaestroInspector;

  /// Called every time the value of a [Maestro] child changes.
  void onValueUpdated<T>(T oldValue, T value);
}

class _DelegatedMaestroInspector implements MaestroInspector {
  const _DelegatedMaestroInspector(this._onValueUpdated)
      : assert(_onValueUpdated != null);

  final OnValueUpdated _onValueUpdated;

  @override
  void onValueUpdated<T>(T oldValue, T value) {
    _onValueUpdated(oldValue, value);
  }
}
