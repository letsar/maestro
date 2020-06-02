import 'package:flutter/widgets.dart';
import 'package:maestro/src/maestro.dart';

/// A widget which listens the value of the nearest [Maestro<T>] ancestor.
class MaestroListener<T> extends StatefulWidget {
  /// Creates a [MaestroListener].
  ///
  /// We can use a [MaestroListener] in two ways:
  ///  - Either we want to gets the value and rebuild every time it changes. In
  ///    this case, you must set a [builder] and on optional [child]. The
  ///    [child] will be passed to the [builder] when rebuilding.
  ///  - Either we only want to listen for changes and make an action (like
  ///    navigate or show a dialog) depending on the new value. In this case,
  ///    you must set a [listener] and a [child].
  const MaestroListener({
    Key key,
    this.builder,
    this.listener,
    this.child,
  })  : assert(builder != null || (listener != null && child != null)),
        super(key: key);

  /// The builder called every time the depending value changes.
  /// Used to build a new widget when the value changes.
  final ValueWidgetBuilder<T> builder;

  /// The listener called every time the depending value changes.
  /// Used to make an action when the value changes.
  final void Function(BuildContext context, T oldValue, T value) listener;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  _MaestroListenerState<T> createState() => _MaestroListenerState<T>();
}

class _MaestroListenerState<T> extends State<MaestroListener<T>> {
  T _value;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final T oldValue = _value;
    _value = context.listen<T>();
    if (_initialized && widget.listener != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.listener(context, oldValue, _value);
      });
    }
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder(
        context,
        _value,
        widget.child,
      );
    } else {
      return widget.child;
    }
  }
}
