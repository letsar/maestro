import 'package:flutter/material.dart';
import 'package:maestro/maestro.dart';
import 'package:undo_redo/memory.dart';
import 'package:undo_redo/memory_performer.dart';

final Memory _memory = Memory();

void main() {
  runApp(MyMaestros(child: MyApp()));
}

class MyMaestros extends StatelessWidget {
  const MyMaestros({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Maestros(
      [
        Maestro(MaestroInspector(onAction)),
        Maestro<MaestroInspector>(_memory),
        Maestro(0),
        Maestro(Colors.blue),
        Maestro(MemoryPerformer(_memory)),
      ],
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: context.listen<MaterialColor>(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int counter = context.listen<int>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const _ColorChanger(color: Colors.blue),
                const _ColorChanger(color: Colors.red),
                const _ColorChanger(color: Colors.green),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton(
              onPressed: () => context.write(counter + 1, 'increment'),
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton(
              onPressed: () => context.read<MemoryPerformer>().undo(),
              tooltip: 'Undo',
              child: Icon(Icons.undo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton(
              onPressed: () => context.read<MemoryPerformer>().redo(),
              tooltip: 'Redo',
              child: Icon(Icons.redo),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorChanger extends StatelessWidget {
  const _ColorChanger({
    Key key,
    this.color,
  }) : super(key: key);

  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.write(color, 'skin'),
      child: Container(
        color: color,
        margin: const EdgeInsets.all(8),
        height: 50,
        width: 50,
      ),
    );
  }
}

bool onAction<T>(T oldValue, T value, Object action) {
  final String oldLog = oldValue.toLog();
  final String newLog = value.toLog();
  print('[$action] from $oldLog to $newLog');
  return true;
}

extension LogStringExtensions<T> on T {
  String toLog() {
    final T value = this;
    if (value is MaterialColor) {
      return 'Color(0x${value.value.toRadixString(16).padLeft(8, '0')})';
    } else {
      return toString();
    }
  }
}
