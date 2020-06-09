import 'package:maestro/maestro.dart';
import 'package:users_devices/core/store.dart';
import 'package:users_devices/models/device.dart';

class DeviceComposer with Composer {
  DeviceComposer(this.deviceId);

  final int deviceId;

  Store<int, Device> get _deviceStore => read<Store<int, Device>>();

  Device get _device => _deviceStore.read(deviceId);
}
