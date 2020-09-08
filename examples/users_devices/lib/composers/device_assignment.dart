import 'package:maestro/maestro.dart';
import 'package:users_devices/composers/device_store.dart';
import 'package:users_devices/composers/user_store.dart';
import 'package:users_devices/models/device.dart';
import 'package:users_devices/models/user.dart';

class DeviceAssigmentComposer with Composer {
  UserStore get _userStore => read<UserStore>();

  DeviceStore get _deviceStore => read<DeviceStore>();

  /// Assign the device with this [deviceId] to the user with this [userId].
  void assign(int deviceId, int userId) {
    final User user = _userStore.get(userId);
    final Device device = _deviceStore.get(deviceId);

    if (user != null && device != null) {
      if (device.ownerId != null) {
        // The device was assigned to another user before.
        // After the assignment, it should only by assigned to one person only.
        final User owner = _userStore.get(device.ownerId);
        final User newOwner = owner.newDeviceIds((l) => l..remove(deviceId));
        _userStore.overwrite(newOwner);
      }

      // We change the owner of the device.
      final Device newDevice = device.copyWith(ownerId: userId);

      // We assign the device to the user.
      final User newUser = user.newDeviceIds((l) => l..add(deviceId));

      // We persist the data.
      write(_userStore.overwrite(newUser));
      write(_deviceStore.overwrite(newDevice));
    }
  }
}
