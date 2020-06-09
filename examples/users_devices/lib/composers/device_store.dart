import 'package:maestro/maestro.dart';
import 'package:users_devices/composers/busy_state.dart';
import 'package:users_devices/core/store.dart';
import 'package:users_devices/data/sources/fake_api_client.dart';
import 'package:users_devices/models/device.dart';

class DeviceStoreComposer with Composer, BusyStateComposer {
  FakeApiClient get _apiClient => read<FakeApiClient>();

  Store<int, Device> get _deviceStore => read<Store<int, Device>>();

  @override
  Future<void> play() async {
    busy();
    final List<Device> devices = await _apiClient.getDevices();
    write(_deviceStore.writeAll(devices));
    idle();
  }
}
