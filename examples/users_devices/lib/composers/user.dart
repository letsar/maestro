import 'package:maestro/maestro.dart';
import 'package:users_devices/core/store.dart';
import 'package:users_devices/models/user.dart';

class UserComposer with Composer {
  UserComposer(this.userId);

  final int userId;

  Store<int, User> get _userStore => read<Store<int, User>>();

  User get _user => _userStore.read(userId);

  Future<void> assignDevice(int deviceId) {}
}
