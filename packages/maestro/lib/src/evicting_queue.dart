/// A queue which have a predetermined maximum capacity. The oldest element is
/// replaced when the full capacity is reached.
class EvictingQueue<T> {
  /// Creates a queue with the specified [maxCapacity].
  EvictingQueue([this.maxCapacity = _defaultMaxCapacity])
      : assert(maxCapacity != null && maxCapacity > 0),
        _items = <T>[],
        _tail = 0;

  static const int _defaultMaxCapacity = 8;

  /// The total number of elements this queue can hold.
  final int maxCapacity;

  final List<T> _items;

  int _tail;

  /// The number of items.
  int get length => _items.length;

  /// Returns `true` if there are no items.
  bool get isEmpty => _items.isEmpty;

  /// Returns `true` if there is at least one item.
  bool get isNotEmpty => _items.isNotEmpty;

  /// Adds an item at the tail.
  ///
  /// If full capacity of this queue is reached, then the oldest item is
  /// replaced.
  void enqueue(T item) {
    if (length == maxCapacity) {
      // We evict the oldest element.
      _tail = (_tail + 1) % maxCapacity;
      _items[_tail] = item;
    } else {
      // We add a new item.
      _tail = length;
      _items.add(item);
    }
  }

  /// Removes the item at the tail.
  ///
  /// The queue must not be empty when this method is called.
  T dequeue() {
    if (isEmpty) {
      throw StateError('No elements');
    }
    final T item = _items.removeAt(_tail);
    _tail = (_tail - 1) % maxCapacity;
    return item;
  }

  /// Removes all the items.
  void clear() {
    _items.clear();
    _tail = 0;
  }
}
