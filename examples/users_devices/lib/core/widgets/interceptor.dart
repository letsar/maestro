import 'package:flutter/widgets.dart';
import 'package:maestro/maestro.dart';

class Interceptor<T> extends StatelessWidget {
  const Interceptor({
    Key key,
    @required this.value,
    @required this.onChanged,
    @required this.child,
  })  : assert(onChanged != null),
        assert(child != null),
        super(key: key);

  final T value;
  final ValueChanged<T> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Maestros(
      [
        Maestro(MaestroInspector(_onAction)),
        Maestro<T>(value, key: ValueKey(value)),
      ],
      child: child,
    );
  }

  bool _onAction<X>(X oldValue, X newValue, Object action) {
    if (newValue is T) {
      onChanged(newValue);
    }
    return true;
  }
}
