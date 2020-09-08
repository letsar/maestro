import 'package:meta/meta.dart';
import 'package:maestro/maestro.dart';
import 'package:users_devices/composers/busy_state.dart';
import 'package:users_devices/models/identifiable.dart';

abstract class Store<T extends Identifiable> with Composer, BusyStateComposer {
  Map<int, T> get state => read<Map<int, T>>();
  set state(Map<int, T> value) => write<Map<int, T>>(value);

  int get length => state.length;

  List<T> get values => state.values.toList();

  T get(int id) => state[id];

  @override
  Future<void> play() async {
    busy();
    final Iterable<T> all = await fetch();
    state = Map<int, T>.fromEntries(all.map((e) => MapEntry<int, T>(e.id, e)));
    idle();
  }

  @protected
  Future<Iterable<T>> fetch();

  void overwrite(T value) {
    state = state.clone();
    state[value.id] = value;
  }
}

extension _MapExtensions<T extends Identifiable> on Map<int, T> {
  clone() => Map<int, T>.from(this);
}
