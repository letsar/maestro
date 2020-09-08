import 'package:users_devices/composers/store.dart';
import 'package:users_devices/data/sources/fake_api_client.dart';
import 'package:users_devices/models/user.dart';

class UserStore extends Store<User> {
  FakeApiClient get _apiClient => read<FakeApiClient>();

  @override
  Future<Iterable<User>> fetch() {
    return _apiClient.getUsers();
  }
}
