import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

class _DelegatedPerformer implements Performer {
  const _DelegatedPerformer(this.onAttached, this.onDispose);

  final void Function(Score score) onAttached;
  final VoidCallback onDispose;

  @override
  void attach(Score score) => onAttached(score);

  @override
  void detach() => onDispose();
}

void main() {
  group('Performer', () {
    testWidgets('methods are called when they should', (tester) async {
      final List<bool> attached = [false, false];
      final List<bool> disposed = [false, false];

      final List<_DelegatedPerformer> performers = List.generate(
        2,
        (i) => _DelegatedPerformer(
          (score) => attached[i] = true,
          () => disposed[i] = true,
        ),
      );

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            Maestro(performers[0]),
          ],
          child: const SizedBox(),
        ),
      );

      expect(attached[0], equals(true));
      expect(disposed[0], equals(false));

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            Maestro(performers[1], key: UniqueKey()),
          ],
          child: const SizedBox(),
        ),
      );

      expect(attached[0], equals(true));
      expect(disposed[0], equals(true));

      expect(attached[1], equals(true));
      expect(disposed[1], equals(false));

      await tester.pumpWidget(
        const Maestros(
          [
            Maestro(1),
          ],
          child: SizedBox(),
        ),
      );

      expect(attached[0], equals(true));
      expect(disposed[0], equals(true));

      expect(attached[1], equals(true));
      expect(disposed[1], equals(true));
    });
  });
}
