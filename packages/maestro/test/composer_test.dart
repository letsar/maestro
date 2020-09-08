import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

import 'common.dart';

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
    testWidgets('can read an ancestor maestro when attached', (tester) async {
      int value;

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro.readOnly(1),
            Maestro(_FetchWhenAttachedComposer<int>((int x) => value = x)),
          ],
          child: const SizedBox(),
        ),
      );

      expect(value, equals(1));

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro.readOnly(2),
            Maestro(_FetchWhenAttachedComposer<int>((int x) => value = x)),
          ],
          child: const SizedBox(),
        ),
      );

      // The new instance does not replace the old one, and the play method
      // is not called.
      expect(value, equals(1));
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

      expect(composer.fetch<int>(), equals(2));

      await tester.pump();

      expect(composer.fetch<int>(), equals(2));
    });
  });
}
