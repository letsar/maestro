import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

import 'common.dart';

void main() {
  group('Inspector', () {
    testWidgets('method is called as soon as the value changed',
        (tester) async {
      final List<String> logs = <String>[];

      void onValueUpdated<T>(T old, T value) {
        logs.add('$old => $value');
      }

      final MaestroInspector inspector = MaestroInspector(onValueUpdated);
      final DefaultComposer composer = DefaultComposer();

      await tester.pumpWidget(
        Maestros(
          [
            Maestro(inspector),
            const Maestro(1),
            const Maestro('a'),
            Maestro(composer),
          ],
          child: const SizedBox(),
        ),
      );

      expect(logs, isEmpty);

      composer.store(2);
      expect(logs, <String>['1 => 2']);

      composer.store('b');
      expect(logs, <String>['1 => 2', 'a => b']);
    });
  });
}
