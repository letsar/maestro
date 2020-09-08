import 'dart:async';
import 'dart:math';

import 'package:maestro/maestro.dart';
import 'package:users_devices/composers/device_store.dart';
import 'package:users_devices/models/device.dart';

class FakeConnectionStatusHandler with Composer {
  DeviceStore get _deviceStore => read<DeviceStore>();
  Timer _timer;
  Random _rnd = Random();

  @override
  void play() {
    _timer = Timer(const Duration(seconds: 2), _changeOneConnectionStatus);
  }

  void _changeOneConnectionStatus() {
    final Device randomDevice =
        _deviceStore.values.elementAt(_rnd.nextInt(_deviceStore.length));

    _deviceStore
        .overwrite(randomDevice.copyWith(connected: !randomDevice.connected));
    play();
  }

  @override
  void detach() {
    _timer?.cancel();
  }
}
