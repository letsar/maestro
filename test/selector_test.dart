import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

@immutable
class User {
  const User(this.firstName, this.lastName);

  final String firstName;
  final String lastName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other.runtimeType != runtimeType) {
      return false;
    } else {
      return other is User &&
          other.firstName == firstName &&
          other.lastName == lastName;
    }
  }

  @override
  int get hashCode {
    return hashValues(firstName, lastName);
  }
}

void main() {
  group('Selector', () {
    testWidgets('not rebuilt if the model is considered the same',
        (tester) async {
      int buildCount01 = 0;
      int buildCount02 = 0;

      final Widget child = Builder(
        builder: (context) {
          buildCount01++;
          context.listen<User>();
          return Builder(
            builder: (context) {
              buildCount02++;
              context.select<User, String>((user) => user.firstName);
              return const SizedBox();
            },
          );
        },
      );

      await tester.pumpWidget(Maestro(
        const User(
          'Darth',
          'Vader',
        ),
        child: child,
      ));

      expect(buildCount01, equals(1));
      expect(buildCount02, equals(1));

      await tester.pumpWidget(Maestro(
        const User(
          'Darth',
          'Vader',
        ),
        child: child,
      ));

      expect(buildCount01, equals(1));
      expect(buildCount02, equals(1));
    });

    testWidgets('throws if `selector` and `builder` are null', (tester) async {
      expect(
        () {
          return MaestroSelector<int, int>(
            selector: null,
            builder: (context, value, child) => const SizedBox(),
          );
        },
        throwsAssertionError,
      );

      expect(
        () {
          return MaestroSelector<int, int>(
            selector: (a) => 0,
            builder: null,
          );
        },
        throwsAssertionError,
      );
    });

    testWidgets('rebuilt only when the selected value changes', (tester) async {
      int buildCount = 0;
      BuildContext ctx;

      final Widget child = MaestroSelector<User, String>(
        selector: (user) => user.firstName,
        builder: (context, firstName, child) {
          buildCount++;
          ctx = context;
          return const SizedBox();
        },
      );

      await tester.pumpWidget(Maestro(
        const User(
          'Darth',
          'Vader',
        ),
        child: child,
      ));

      expect(buildCount, equals(1));

      Maestro.write(ctx, const User('Darth', 'Skywalker'));
      await tester.pump();

      // The first name didn't changed.
      expect(buildCount, equals(1));

      Maestro.write(ctx, const User('Anakin', 'Skywalker'));
      await tester.pump();

      expect(buildCount, equals(2));
    });

    testWidgets(
        'rebuilt only when the selected value changes according to a comparer',
        (tester) async {
      int buildCount = 0;
      BuildContext ctx;

      final Widget child = MaestroSelector<User, String>(
        selector: (user) => user.firstName,
        equalityComparer: (x, y) => x.toLowerCase() == y.toLowerCase(),
        builder: (context, firstName, child) {
          buildCount++;
          ctx = context;
          return const SizedBox();
        },
      );

      await tester.pumpWidget(Maestro(
        const User(
          'Darth',
          'Vader',
        ),
        child: child,
      ));

      expect(buildCount, equals(1));

      Maestro.write(ctx, const User('DARTH', 'Vader'));
      await tester.pump();

      // The first name letters didn't changed.
      expect(buildCount, equals(1));

      Maestro.write(ctx, const User('Anakin', 'Vader'));
      await tester.pump();

      expect(buildCount, equals(2));
    });
  });
}
