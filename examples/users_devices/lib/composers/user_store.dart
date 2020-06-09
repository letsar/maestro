import 'package:maestro/maestro.dart';
import 'package:users_devices/composers/busy_state.dart';
import 'package:users_devices/core/store.dart';
import 'package:users_devices/data/sources/fake_api_client.dart';
import 'package:users_devices/models/user.dart';

class UserStoreComposer with Composer, BusyStateComposer {
  FakeApiClient get _apiClient => read<FakeApiClient>();

  Store<int, User> get _userStore => read<Store<int, User>>();

  @override
  Future<void> play() async {
    busy();
    final List<User> users = await _apiClient.getUsers();
    write(_userStore.writeAll(users));
    idle();
  }
}
