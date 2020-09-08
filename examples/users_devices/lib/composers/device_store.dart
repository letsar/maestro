import 'package:users_devices/composers/store.dart';
import 'package:users_devices/data/sources/fake_api_client.dart';
import 'package:users_devices/models/device.dart';

class DeviceStore extends Store<Device> {
  FakeApiClient get _apiClient => read<FakeApiClient>();

  @override
  Future<Iterable<Device>> fetch() {
    return _apiClient.getDevices();
  }
}
