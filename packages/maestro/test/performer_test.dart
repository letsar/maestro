import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

class _DelegatedPerformer implements Performer {
  const _DelegatedPerformer(
    this.onAttach,
    this.onPlay,
    this.onDetach,
  );

  final void Function(Score score) onAttach;
  final void Function() onPlay;
  final VoidCallback onDetach;

  @override
  void attach(Score score) => onAttach(score);

  @override
  FutureOr<void> play() async => onPlay();

  @override
  void detach() => onDetach();
}

void main() {
  group('Performer', () {
    testWidgets('methods are called when they should', (tester) async {
      final List<String> logs = <String>[];

      final List<_DelegatedPerformer> performers = List.generate(
        2,
        (i) => _DelegatedPerformer(
          (score) => logs.add('attach $i'),
          () => logs.add('play $i'),
          () => logs.add('detach $i'),
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

      expect(logs, <String>[
        'attach 0',
        'play 0',
      ]);
      logs.clear();

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            Maestro(performers[1]),
          ],
          child: const SizedBox(),
        ),
      );

      expect(logs, <String>[]);
      logs.clear();

      await tester.pumpWidget(
        Maestros(
          [
            const Maestro(1),
            Maestro(performers[1], key: UniqueKey()),
          ],
          child: const SizedBox(),
        ),
      );

      expect(logs, <String>[
        'attach 1',
        'detach 0',
        'play 1',
      ]);
      logs.clear();

      await tester.pumpWidget(
        const Maestros(
          [
            Maestro(1),
          ],
          child: SizedBox(),
        ),
      );

      expect(logs, <String>[
        'detach 1',
      ]);
    });
  });
}
