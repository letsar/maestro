import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/src/evicting_queue.dart';

void main() {
  group('EvictingQueue', () {
    test('isEmpty returns true if no elements and false when at least one', () {
      final EvictingQueue<int> queue = EvictingQueue<int>(1);
      expect(queue.isEmpty, isTrue);
      queue.enqueue(0);
      expect(queue.isEmpty, isFalse);
    });

    test('isNotEmpty returns false if no elements and true when at least one',
        () {
      final EvictingQueue<int> queue = EvictingQueue<int>(1);
      expect(queue.isNotEmpty, isFalse);
      queue.enqueue(0);
      expect(queue.isNotEmpty, isTrue);
    });

    test('calling clear removes all the items', () {
      final EvictingQueue<int> queue = EvictingQueue<int>(1);
      expect(queue.isEmpty, isTrue);
      queue.clear();
      expect(queue.isEmpty, isTrue);
      queue.enqueue(0);
      queue.enqueue(0);
      queue.enqueue(0);
      expect(queue.isEmpty, isFalse);
      queue.clear();
      expect(queue.isEmpty, isTrue);
    });

    group('maxCapacity', () {
      test('returns the specified maximum capacity', () {
        final EvictingQueue<int> queue = EvictingQueue<int>(4);
        expect(queue.maxCapacity, equals(4));
      });

      test('must not be null', () {
        expect(() => EvictingQueue<int>(null), throwsAssertionError);
      });

      test('must be positive', () {
        expect(() => EvictingQueue<int>(-1), throwsAssertionError);
        expect(() => EvictingQueue<int>(0), throwsAssertionError);
      });
    });

    group('calling enqueue', () {
      test('increments the length until full capacity is reached', () {
        final EvictingQueue<int> queue = EvictingQueue<int>(2);
        expect(queue.length, equals(0));
        queue.enqueue(1);
        expect(queue.length, equals(1));
        queue.enqueue(1);
        expect(queue.length, equals(2));
        queue.enqueue(1);
        expect(queue.length, equals(2));
      });

      group('calling dequeue', () {
        test('throws a StateError if the queue is empty', () {
          final EvictingQueue<int> queue = EvictingQueue<int>(2);
          expect(queue.isEmpty, isTrue);
          expect(() => queue.dequeue(), throwsA(isA<StateError>()));
        });

        test('removes the last added item', () {
          final EvictingQueue<int> queue = EvictingQueue<int>(6);
          queue.enqueue(1);
          queue.enqueue(2);
          queue.enqueue(3);
          queue.enqueue(4);
          queue.enqueue(5);
          queue.enqueue(6);
          expect(queue.dequeue(), equals(6));
          expect(queue.dequeue(), equals(5));
          expect(queue.dequeue(), equals(4));
          expect(queue.dequeue(), equals(3));
          expect(queue.dequeue(), equals(2));
          expect(queue.dequeue(), equals(1));
          expect(() => queue.dequeue(), throwsA(isA<StateError>()));
        });

        test('when enqueued too many items, removes only the last ones', () {
          final EvictingQueue<int> queue = EvictingQueue<int>(3);
          queue.enqueue(1);
          queue.enqueue(2);
          queue.enqueue(3);
          queue.enqueue(4);
          queue.enqueue(5);
          queue.enqueue(6);
          expect(queue.dequeue(), equals(6));
          expect(queue.dequeue(), equals(5));
          expect(queue.dequeue(), equals(4));
          expect(() => queue.dequeue(), throwsA(isA<StateError>()));
        });
      });
    });
  });
}
