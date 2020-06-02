import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

import 'common.dart';

class _DelegatedComposer with Composer {
  _DelegatedComposer(this._play);

  final VoidCallback _play;

  @override
  void play() => _play();
}

class _FetchWhenAttachedComposer<T> with Composer {
  _FetchWhenAttachedComposer(this.fetch);
  final ValueChanged<T> fetch;

  @override
  void play() {
    fetch(read<T>());
  }
}

void main() {
  group('Composer', () {
    testWidgets('attached when added in the tree', (tester) async {
      final List<bool> play = [false, false];

      final List<_DelegatedComposer> composers = List.generate(
        2,
        (i) => _DelegatedComposer(
          () {
            play[i] = true;
          },
        ),
      );

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            Maestro(composers[0], key: UniqueKey()),
          ],
          child: const SizedBox(),
        ),
      );

      expect(play[0], equals(true));
      expect(play[1], equals(false));

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            Maestro(composers[1], key: UniqueKey()),
          ],
          child: const SizedBox(),
        ),
      );

      // The new composer is attached the Maestro is added with a new key.
      expect(play[0], equals(true));
      expect(play[1], equals(true));
    });

    testWidgets('can read an ancestor maestro when attached', (tester) async {
      int value;

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            Maestro(_FetchWhenAttachedComposer<int>((int x) => value = x)),
          ],
          child: const SizedBox(),
        ),
      );

      expect(value, equals(1));

      await tester.pumpWidget(
        Maestros(
          [
            Maestro(2, key: UniqueKey()),
            Maestro(
              _FetchWhenAttachedComposer<int>((int x) => value = x),
              key: UniqueKey(),
            ),
          ],
          child: const SizedBox(),
        ),
      );

      expect(value, equals(2));
    });

    testWidgets('can write an ancestor maestro', (tester) async {
      final DefaultComposer composer = DefaultComposer();

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            Maestro(composer),
          ],
          child: const SizedBox(),
        ),
      );

      composer.store(2);

      // The value should still be 1 because 2 will be readable after the next
      // frame.
      expect(composer.fetch<int>(), equals(1));

      await tester.pump();

      expect(composer.fetch<int>(), equals(2));
    });
  });
}
