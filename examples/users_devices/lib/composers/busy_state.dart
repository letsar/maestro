import 'package:maestro/maestro.dart';

enum BusyState {
  idle,
  busy,
}

mixin BusyStateComposer on Composer {
  void idle() => write(BusyState.idle);
  void busy() => write(BusyState.busy);
}
