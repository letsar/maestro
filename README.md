# Maestro

[![Pub](https://img.shields.io/pub/v/maestro.svg)](https://pub.dartlang.org/packages/maestro)

A simple way for orchestrating the state of an entire Flutter application.

This is an experimentation around `InheritedWidget`s and `StatefulWidget`s for managing the state of an entire Flutter application.

The main philosophy behind this package is to have immutable data representing your app state and separate objects able to manipulate that data.

## Exposing your app state

We often have different types of data, which when gathered together, form the app state.
For this purpose we have one widget responsible for storing and exposing the app data to its entire subtree. This widget is called `Maestro`.

A `Maestro` is created with an initial value which can evolves during the execution of the application.

The following example shows how to expose a `String` object with an initial value of `'Hello World!'`:
```dart
Maestro(
  'Hello World!',
  child: SubTree(),
)
```

You can nest multiple `Maestro`s in order to expose different types of data:
```dart
Maestro(
  'Hello World!',
  child: Maestro(
    42,
    child: SubTree(),
  ),
)
```

To simplify the syntax of such code, we can use another widget called `Maestros` which is responsible to create a nested tree of `Maestro`s.
The previous code can be rewritten like this:
```dart
Maestros(
  [
    Maestro('Hello World!'),
    Maestro(42),
  ],
  child: SubTree(),
)
```

## Manipulating your app state

There are four ways to manipulate the data exposed with `Maestro` depending on what you want.

### I want to read the value and rebuild my widget every time the value changes.

You can either use `Maestro.listen<T>(...);` inside the build method of your widget, or the extension method on `BuildContext` called `listen<T>()`;

If you don't want to create your own widget, you can use the `MaestroListener<T>` widget and provide a `builder`.

### I want to read the value, but only one time because I know the value never change.

You can either use `Maestro.read<T>(...);` inside the build method of your widget, or the extension method on `BuildContext` called `read<T>()`;

### I want to read a part of the value and rebuild my widget every time that part changes.

You can either use `Maestro.select<T, R>(...);` inside the build method of your widget, or the extension method on `BuildContext` called `select<T, R>(...)`;

If you don't want to create your own widget, you can use the `MaestroSelector<T, R>` widget and provide a `builder` and a `selector`.

### I want to update the value

You can either use `Maestro.write<T>(...);` inside an event handler, or the extension method on `BuildContext` called `write<T>(...)`;

The value you pass to `write<T>` will update the value held by the nearest `Maestro<T>` ancestor. A build with the new value will be triggered and all listeners will be rebuilt.

### I want to separate the logic from the widget tree

This package promotes the clear separation between the app business logic and the widgets by introducing a concept of `Composer`.

A `Composer` is an object which is responsible for managing a part of the state of your app. It's able to read and write data declared in a `Maestro` higher than itself in the widget tree.

To create a `Composer` you'll need to create a class which will apply the mixin `Composer`. With this mixin, your object will also be able to execute some code when the `Composer` is initialized and before it is no longer used.

For example, let's considering we have an immutable `Counter` class and we want to manipulate this counter in a `Composer` called `CounterComposer`.
We would declare the `Maestro`s like this:

```dart
Maestros(
  [
    // This is how we expose a [Counter] model with an initial value of 0.
    const Maestro(Counter(0)),

    // This is how we declare the [CounterComposer].
    Maestro(CounterComposer()),
  ],
  child: SubTree(),
)
```

The `CounterComposer` would be implemented like this:

```dart
class CounterComposer with Composer {
  /// Increments the value of the current [Counter].
  void increment() {
    // We read the nearest Counter in order to increment its value.
    final Counter counter = read<Counter>();
    final Counter incrementedCounter = Counter(counter.value + 1);

    // We write the new value.
    write(incrementedCounter);
  }
}
```

In a button somewhere in the `SubTree` we could call the `increment` method like this:

```dart
FloatingActionButton(
  onPressed: () => context.read<CounterComposer>().increment(),
  tooltip: 'Increment',
  child: Icon(Icons.add),
),
```

To execute some code when the `Composer` is initialized, you can override the `play` method.

## Limitations

The value passed to a `Maestro` is only used for its initial state. Therefore if you want to change the current value from a parent you need to pass a different key to the `Maestro` in order to replace the old `Maestro` by the new one.

## Advanced use

### MaestroInspector

All `Maestro`s can report when their value changed to the nearest `Maestro<MaestroInspector>`. It can be used to log all the intermediates states that lead to a bug for example.

You can declare an inspector like this:

```dart
void onValueUpdated<T>(T oldValue, T newValue) => print('from $oldValue to $newValue');
...
Maestros(
  [
    Maestro(MaestroInspector(onValueUpdated)),
    Maestro(Data())
    Maestro(Composer())
    ...
  ],
  child : SubTree(),
)
```

## Changelog

Please see the [Changelog](https://github.com/letsar/maestro/blob/master/CHANGELOG.md) page to know what's recently changed.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/letsar/maestro/issues).  
If you fixed a bug or implemented a feature, please send a [pull request](https://github.com/letsar/maestro/pulls).