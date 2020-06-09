import 'package:maestro/maestro.dart';
import 'package:users_devices/core/store.dart';
import 'package:users_devices/models/device.dart';
import 'package:users_devices/models/user.dart';

class DeviceAssigmentComposer with Composer {
  Store<int, User> get _userStore => read<Store<int, User>>();

  Store<int, Device> get _deviceStore => read<Store<int, Device>>();

  /// Assign the device with this [deviceId] to the user with this [userId].
  void assign(int deviceId, int userId) {
    final User user = _userStore.read(userId);
    final Device device = _deviceStore.read(deviceId);

    Store<int, User> newUserStore = _userStore;

    if (user != null && device != null) {
      if (device.ownerId != null) {
        // The device was assigned to another user before.
        // After the assignment, it should only by assigned to one person only.
        final User owner = _userStore.read(device.ownerId);
        final User newOwner = owner.newDeviceIds((l) => l..remove(deviceId));
        newUserStore = newUserStore.write(newOwner);
      }

      // We change the owner of the device.
      final Device newDevice = device.copyWith(ownerId: userId);

      // We assign the device to the user.
      final User newUser = user.newDeviceIds((l) => l..add(deviceId));

      // We persist the data.
      write(newUserStore.write(newUser));
      write(_deviceStore.write(newDevice));
    }
  }
}
