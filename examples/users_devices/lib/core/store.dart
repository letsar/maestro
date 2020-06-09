import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Immutable map.
@immutable
class Store<K, V> extends Equatable {
  Store(this.selector, [Iterable<V> items])
      : assert(selector != null),
        _map = items == null
            ? <K, V>{}
            : Map<K, V>.fromEntries(
                items.map((e) => MapEntry<K, V>(selector(e), e)),
              );

  Store._(this.selector, Map<K, V> items)
      : assert(selector != null),
        assert(items != null),
        _map = Map<K, V>.from(items);

  final K Function(V value) selector;
  final Map<K, V> _map;

  Iterable<V> get values => _map.values;

  int get length => _map.length;

  @override
  List<Object> get props => [_map, selector];

  V read(K key) => _map[key];

  Store<K, V> write(V value) {
    return copy().._map[selector(value)] = value;
  }

  Store<K, V> writeAll(Iterable<V> values) {
    if (values == null || values.isEmpty) {
      return this;
    }

    final Store<K, V> result = copy();
    result._map.addEntries(values.map((e) => MapEntry<K, V>(selector(e), e)));
    return result;
  }

  Store<K, V> delete(K key) => copy().._map.remove(key);

  Store<K, V> clear() => Store<K, V>(selector);

  Store<K, V> copy() => Store<K, V>._(selector, _map);
}
