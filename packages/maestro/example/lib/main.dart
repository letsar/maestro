import 'package:flutter/material.dart';
import 'package:maestro/maestro.dart';

// This is a way to create the default Flutter application using Maestro.

void main() => runApp(const MyApp());

/// The application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget.
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// [Maestros] is a widget to easily add multiple [Maestro]s inside
    /// the widget tree.
    /// Each [Maestro] hold a single value. When this value changes, all
    /// dependents widgets are rebuilt.
    return Maestros(
      [
        // This is a special component used to listen any changes from
        // Maestro descendants.
        MaestroInspector(_onAction),

        // This is how we expose data.
        const Maestro(Counter(0)),

        // We separate the Maestros containing data from the Maestros acting on
        // these data. We call them composers.
        Maestro(CounterComposer()),
      ],
      child: MaterialApp(
        title: 'Maestro Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maestro Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('You have pushed the button this many times:'),
            _CounterText(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // We get the composer to act on the data.
        onPressed: () => context.read<CounterComposer>().increment(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _CounterText extends StatelessWidget {
  const _CounterText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The call to `listen`, makes `CounterText` rebuild when `Counter`changes.
    final Counter counter = context.listen<Counter>();
    return Text(
      '${counter.value}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

/// Data classes hold the state of your application in multiple places.
/// It's better to have immutable objects.
///
/// This is how you can create one by hand.
///
/// You can also use freezed: https://pub.dev/packages/freezed to easily
/// generate them.
@immutable
class Counter {
  /// Creates a [Counter].
  const Counter(this.value);

  /// The value of the counter.
  final int value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other.runtimeType != runtimeType) {
      return false;
    } else {
      return other is Counter && other.value == value;
    }
  }

  @override
  int get hashCode {
    return value.hashCode;
  }

  @override
  String toString() {
    return 'Counter: $value';
  }
}

/// A composer is a object which mutate the values held by ancestors [Maestro]s.
class CounterComposer with Composer {
  /// We create a getter to read the nearest [Counter] in the tree in order to
  /// see quickly on what this composer depends on.
  /// This is just a convention.
  Counter get _counter => read<Counter>();

  /// Increments the value of the current [Counter].
  void increment() {
    // We read the nearest Counter in order to increment its value.
    final Counter incrementedCounter = Counter(_counter.value + 1);

    // We write the new value.
    write(incrementedCounter, 'counter.increment');
  }
}

bool _onAction<T>(T oldValue, T value, Object action) {
  debugPrint('$action made a transition from $oldValue to $value');
  return true;
}
