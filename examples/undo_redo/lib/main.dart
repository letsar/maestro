import 'package:flutter/material.dart';
import 'package:maestro/maestro.dart';
import 'package:undo_redo/memory.dart';
import 'package:undo_redo/memory_performer.dart';

final Memory _memory = Memory();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Maestros(
      [
        Maestro(MaestroInspector(onAction)),
        Maestro<MaestroInspector>(_memory),
        Maestro(0),
        Maestro(MemoryPerformer(_memory)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(),
      ),
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

bool onAction<T>(T oldValue, T value, Object action) {
  print('[$action] from $oldValue to $value');
  return true;
}
