import 'dart:async';
import 'dart:math';

import 'package:maestro/maestro.dart';
import 'package:users_devices/core/store.dart';
import 'package:users_devices/models/device.dart';

class FakeConnectionStatusHandler with Composer {
  Store<int, Device> get _deviceStore => read<Store<int, Device>>();
  Timer _timer;
  Random _rnd = Random();

  @override
  void play() {
    _timer = Timer(const Duration(seconds: 1), _changeOneConnectionStatus);
  }

  void _changeOneConnectionStatus() {
    final Device randomDevice =
        _deviceStore.values.elementAt(_rnd.nextInt(_deviceStore.length));
    write(_deviceStore
        .write(randomDevice.copyWith(connected: !randomDevice.connected)));
    play();
  }

  @override
  void detach() {
    _timer?.cancel();
  }
}
