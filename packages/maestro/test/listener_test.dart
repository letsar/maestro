import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

import 'common.dart';

void main() {
  group('Listener', () {
    testWidgets('gets its value from an ancestor', (tester) async {
      int maestroValue;
      final DefaultComposer composer = DefaultComposer();

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            const Maestro('a'),
            Maestro(composer),
          ],
          child: MaestroListener<int>(
            builder: (context, value, child) {
              maestroValue = value;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(maestroValue, 1);

      composer.store(2);

      // The widget is not yet rebuilt.
      expect(maestroValue, 1);

      await tester.pump();

      expect(maestroValue, 2);
    });

    testWidgets('can listen for changes', (tester) async {
      int previousValue;
      int newValue;
      final DefaultComposer composer = DefaultComposer();

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            const Maestro('a'),
            Maestro(composer),
          ],
          child: MaestroListener<int>(
            listener: (context, oldValue, value) {
              previousValue = oldValue;
              newValue = value;
            },
            child: const SizedBox(),
          ),
        ),
      );

      // The listener callback is not called the first time.
      expect(previousValue, null);
      expect(newValue, null);

      composer.store(1);
      await tester.pump();

      // The value didn't changed (1==1).
      expect(previousValue, null);
      expect(newValue, null);

      composer.store(2);
      await tester.pump();

      expect(previousValue, 1);
      expect(newValue, 2);

      composer.store(3);
      await tester.pump();

      expect(previousValue, 2);
      expect(newValue, 3);
    });

    testWidgets('throws if `builder` and `listener` are null', (tester) async {
      expect(
        () {
          return MaestroListener<int>();
        },
        throwsAssertionError,
      );

      expect(
        () {
          return MaestroListener<int>(
            child: const SizedBox(),
          );
        },
        throwsAssertionError,
      );

      expect(
        () {
          return MaestroListener<int>(
            listener: (context, oldValue, value) {},
          );
        },
        throwsAssertionError,
      );
    });
  });
}
