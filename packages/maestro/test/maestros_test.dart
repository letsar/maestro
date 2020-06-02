import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

import 'common.dart';

void main() {
  group('Maestros', () {
    testWidgets('throws if `maestros` argument is null', (tester) async {
      expect(
        () => Maestros(null, child: const SizedBox()),
        throwsAssertionError,
      );
    });

    testWidgets('throws if one maestro is null', (tester) async {
      const Maestros maestros = Maestros(
        [null],
        child: SizedBox(),
      );

      expect(
        () => maestros.build(null),
        throwsAssertionError,
      );
    });

    testWidgets('inserts maestros in same order in the tree', (tester) async {
      await tester.pumpWidget(
        const Maestros(
          [
            Maestro(1),
            Maestro(2),
            Maestro(3),
          ],
          child: SizedBox(),
        ),
      );
      final Type type = typeOf<Maestro<int>>();

      Matcher _matcher(int value) {
        return isA<Maestro<int>>()
            .having((x) => x.initialValue, 'initialValue', value);
      }

      expect(
          find.byType(type),
          matchesInOrder([
            _matcher(1),
            _matcher(2),
            _matcher(3),
          ]));
    });

    testWidgets('copyWithNewChild should keep all properties except child',
        (tester) async {
      final Key key = UniqueKey();
      // ignore: prefer_function_declarations_over_variables
      final EqualityComparer<int> comparer = (x, y) => true;

      await tester.pumpWidget(
        Maestros(
          [
            Maestro(
              1,
              key: key,
              equalityComparer: comparer,
            ),
          ],
          child: const SizedBox(),
        ),
      );
      final Type type = typeOf<Maestro<int>>();

      Matcher _matcher(int value) {
        return isA<Maestro<int>>()
            .having((x) => x.initialValue, 'initialValue', value)
            .having((x) => x.key, 'key', key)
            .having((x) => x.equalityComparer, 'equalityComparer', comparer);
      }

      expect(
          find.byType(type),
          matchesInOrder([
            _matcher(1),
          ]));
    });
  });
}
