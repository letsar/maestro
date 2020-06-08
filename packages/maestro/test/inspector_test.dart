import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

import 'common.dart';

void main() {
  group('Inspector', () {
    testWidgets('method is called as soon as the value changed',
        (tester) async {
      final List<String> logs = <String>[];

      bool onAction<T>(T old, T value, Object action) {
        logs.add('$old => $value');
        return true;
      }

      final MaestroInspector inspector = MaestroInspector(onAction);
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

    testWidgets('method is called with action name', (tester) async {
      final List<String> logs = <String>[];

      bool onAction<T>(T old, T value, Object action) {
        logs.add('$action: $old => $value');
        return true;
      }

      final MaestroInspector inspector = MaestroInspector(onAction);
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

      composer.store(2, 'IntStorage');
      expect(logs, <String>['IntStorage: 1 => 2']);

      composer.store('b', 'StringStorage');
      expect(logs, <String>['IntStorage: 1 => 2', 'StringStorage: a => b']);
    });

    testWidgets('methods are called in order', (tester) async {
      final List<String> logs = <String>[];

      bool onAction01<T>(T old, T value, Object action) {
        logs.add('01 $action: $old => $value');
        return false;
      }

      bool onAction02<T>(T old, T value, Object action) {
        logs.add('02 $action: $old => $value');
        return false;
      }

      final MaestroInspector inspector01 = MaestroInspector(onAction01);
      final MaestroInspector inspector02 = MaestroInspector(onAction02);
      final DefaultComposer composer = DefaultComposer();

      await tester.pumpWidget(
        Maestros(
          [
            Maestro(inspector01),
            const Maestro(1),
            Maestro(inspector02),
            const Maestro('a'),
            Maestro(composer),
          ],
          child: const SizedBox(),
        ),
      );

      expect(logs, isEmpty);

      composer.store(2, 'IntStorage');
      expect(logs, <String>['01 IntStorage: 1 => 2']);

      composer.store('b', 'StringStorage');
      expect(logs, <String>[
        '01 IntStorage: 1 => 2',
        '02 StringStorage: a => b',
        '01 StringStorage: a => b',
      ]);
    });

    testWidgets('methods are called in order and cascading is respected',
        (tester) async {
      final List<String> logs = <String>[];

      bool onAction01<T>(T old, T value, Object action) {
        logs.add('01 $action: $old => $value');
        return false;
      }

      bool onAction02<T>(T old, T value, Object action) {
        logs.add('02 $action: $old => $value');
        return true;
      }

      final MaestroInspector inspector01 = MaestroInspector(onAction01);
      final MaestroInspector inspector02 = MaestroInspector(onAction02);
      final DefaultComposer composer = DefaultComposer();

      await tester.pumpWidget(
        Maestros(
          [
            Maestro(inspector01),
            const Maestro(1),
            Maestro(inspector02),
            const Maestro('a'),
            Maestro(composer),
          ],
          child: const SizedBox(),
        ),
      );

      expect(logs, isEmpty);

      composer.store(2, 'IntStorage');
      expect(logs, <String>['01 IntStorage: 1 => 2']);

      composer.store('b', 'StringStorage');
      expect(logs, <String>[
        '01 IntStorage: 1 => 2',
        '02 StringStorage: a => b',
      ]);
    });
  });
}
