import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maestro/maestro.dart';

Type typeOf<T>() => T;

class DefaultComposer with Composer {
  T fetch<T>() => read<T>();
  void store<T>(T value) => write(value);
}

Matcher matchesInOrder(List<Matcher> matchers) {
  return _InOrderMatcher(matchers);
}

class _InOrderMatcher extends Matcher {
  const _InOrderMatcher(this.matchers);

  final List<Matcher> matchers;

  @override
  Description describe(Object description) {
    throw UnimplementedError();
  }

  @override
  bool matches(covariant Finder finder, Map<dynamic, dynamic> matchState) {
    assert(matchers != null);
    final List<Widget> widgets =
        finder.evaluate().map((e) => e.widget).toList(growable: false);

    if (widgets.length == matchers.length) {
      bool result = true;
      for (int i = 0; i < widgets.length && result; i++) {
        result &= matchers[i].matches(widgets[i], <dynamic, dynamic>{});
      }
      return result;
    }
    return false;
  }
}
