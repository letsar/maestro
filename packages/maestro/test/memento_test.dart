import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

class _DefaultInspector implements Inspector {
  @override
  bool onAction<T>(T oldValue, T value, Object action) {
    return false;
  }
}

void main() {
  group('MaestroMemento', () {
    testWidgets('internal inspector cannot be replaced', (tester) async {
      BuildContext ctx;

      await tester.pumpWidget(
        MaestroMemento<int>(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      Inspector internalInspector = ctx.read<Inspector>();
      expect(internalInspector, isNotNull);

      final Inspector newInspector = _DefaultInspector();
      ctx.write<Inspector>(newInspector);

      await tester.pump();

      internalInspector = ctx.read<Inspector>();
      expect(identical(internalInspector, newInspector), isFalse);
    });

    testWidgets('maximum capacity is used', (tester) async {
      BuildContext ctx;

      await tester.pumpWidget(
        Maestros(
          const [
            MaestroMemento<int>(maxCapacity: 1),
            Maestro<int>(0),
          ],
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      ctx.write<int>(2);
      ctx.write<int>(3);
      await tester.pump();
      expect(ctx.read<int>(), 3);

      ctx.undo<int>();
      ctx.undo<int>();
      await tester.pump();
      expect(ctx.read<int>(), 2);

      ctx.write<int>(3);
      ctx.write<int>(4);
      await tester.pump();
      ctx.undo<int>();
      await tester.pump();
      ctx.undo<int>();
      await tester.pump();
      expect(ctx.read<int>(), 3);
    });

    group('calling undo', () {
      testWidgets('writes the previous state', (tester) async {
        BuildContext ctx;

        await tester.pumpWidget(
          Maestros(
            const [
              MaestroMemento<int>(),
              Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        expect(ctx.read<int>(), equals(0));
        await tester.pump();
        expect(ctx.read<int>(), equals(2));
        ctx.undo<int>();
        // the new state is propagated on the next frame.
        expect(ctx.read<int>(), equals(2));
        await tester.pump();
        expect(ctx.read<int>(), equals(0));
      });

      testWidgets('writes the previous state with a UndoAction',
          (tester) async {
        BuildContext ctx;
        Object lastAction;

        bool onAction<T>(T oldValue, T newValue, Object action) {
          lastAction = action;
          return true;
        }

        await tester.pumpWidget(
          Maestros(
            [
              MaestroInspector(onAction),
              const MaestroMemento<int>(),
              const Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        await tester.pump();
        ctx.undo<int>();
        expect(lastAction, isA<UndoAction>());
      });

      testWidgets('multiple times within the same frame is working',
          (tester) async {
        BuildContext ctx;

        await tester.pumpWidget(
          Maestros(
            [
              const MaestroMemento<int>(),
              const Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        await tester.pump();
        ctx.write<int>(4);
        await tester.pump();
        ctx.undo<int>();
        ctx.undo<int>();
        await tester.pump();
        expect(ctx.read<int>(), equals(0));
      });

      testWidgets('when there is nothing saved, does nothing', (tester) async {
        BuildContext ctx;
        Object lastAction;

        bool onAction<T>(T oldValue, T newValue, Object action) {
          lastAction = action;
          return true;
        }

        await tester.pumpWidget(
          Maestros(
            [
              MaestroInspector(onAction),
              const MaestroMemento<int>(),
              const Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.undo<int>();
        expect(lastAction, isNull);
      });

      testWidgets('of Object works for every type and maintains only one stack',
          (tester) async {
        BuildContext ctx;

        await tester.pumpWidget(
          Maestros(
            [
              const MaestroMemento<Object>(),
              const Maestro<int>(0),
              const Maestro<String>('abcd'),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        await tester.pump();
        ctx.write('efgh');
        await tester.pump();
        ctx.undo<Object>();
        await tester.pump();
        expect(ctx.read<int>(), equals(2));
        expect(ctx.read<String>(), equals('abcd'));
        ctx.undo<Object>();
        await tester.pump();
        expect(ctx.read<int>(), equals(0));
        expect(ctx.read<String>(), equals('abcd'));
      });
    });

    group('calling redo', () {
      testWidgets('writes the previously undone state', (tester) async {
        BuildContext ctx;

        await tester.pumpWidget(
          Maestros(
            const [
              MaestroMemento<int>(),
              Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        await tester.pump();
        ctx.undo<int>();
        await tester.pump();
        expect(ctx.read<int>(), equals(0));
        ctx.redo<int>();
        expect(ctx.read<int>(), equals(0));
        await tester.pump();
        expect(ctx.read<int>(), equals(2));
      });

      testWidgets('write the previously undone state with a RedoAction',
          (tester) async {
        BuildContext ctx;
        Object lastAction;

        bool onAction<T>(T oldValue, T newValue, Object action) {
          lastAction = action;
          return true;
        }

        await tester.pumpWidget(
          Maestros(
            [
              MaestroInspector(onAction),
              const MaestroMemento<int>(),
              const Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        await tester.pump();
        ctx.undo<int>();
        await tester.pump();
        ctx.redo<int>();
        expect(lastAction, isA<RedoAction>());
      });

      testWidgets('multiple times within the same frame is working',
          (tester) async {
        BuildContext ctx;

        await tester.pumpWidget(
          Maestros(
            [
              const MaestroMemento<int>(),
              const Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        await tester.pump();
        ctx.write<int>(4);
        await tester.pump();
        ctx.undo<int>();
        ctx.undo<int>();
        await tester.pump();
        expect(ctx.read<int>(), equals(0));
        ctx.redo<int>();
        ctx.redo<int>();
        await tester.pump();
        expect(ctx.read<int>(), equals(4));
      });

      testWidgets('when there is nothing saved, does nothing', (tester) async {
        BuildContext ctx;
        Object lastAction;

        bool onAction<T>(T oldValue, T newValue, Object action) {
          lastAction = action;
          return true;
        }

        await tester.pumpWidget(
          Maestros(
            [
              MaestroInspector(onAction),
              const MaestroMemento<int>(),
              const Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.redo<int>();
        expect(lastAction, isNull);
      });

      testWidgets('after writing a new value does nothing', (tester) async {
        final List<String> logs = <String>[];
        BuildContext ctx;

        bool onAction<T>(T oldValue, T newValue, Object action) {
          logs.add(action.runtimeType.toString());
          return true;
        }

        await tester.pumpWidget(
          Maestros(
            [
              MaestroInspector(onAction),
              const MaestroMemento<int>(),
              const Maestro<int>(0),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        await tester.pump();
        ctx.undo<int>();
        await tester.pump();
        ctx.write<int>(4);
        await tester.pump();
        ctx.redo<int>();
        expect(logs, ['Null', 'UndoAction', 'Null']);
      });

      testWidgets('of Object works for every type and maintains only one stack',
          (tester) async {
        BuildContext ctx;

        await tester.pumpWidget(
          Maestros(
            [
              const MaestroMemento<Object>(),
              const Maestro<int>(0),
              const Maestro<String>('abcd'),
            ],
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );

        ctx.write<int>(2);
        await tester.pump();
        ctx.write('efgh');
        await tester.pump();
        ctx.undo<Object>();
        await tester.pump();
        expect(ctx.read<int>(), equals(2));
        expect(ctx.read<String>(), equals('abcd'));
        ctx.undo<Object>();
        await tester.pump();
        expect(ctx.read<int>(), equals(0));
        expect(ctx.read<String>(), equals('abcd'));
        ctx.redo<Object>();
        await tester.pump();
        expect(ctx.read<int>(), equals(2));
        expect(ctx.read<String>(), equals('abcd'));
        ctx.redo<Object>();
        await tester.pump();
        expect(ctx.read<int>(), equals(2));
        expect(ctx.read<String>(), equals('efgh'));
      });
    });
  });
}
