import 'package:flutter/material.dart';
import 'package:maestro/maestro.dart';
import 'package:users_devices/composers/device_assignment.dart';
import 'package:users_devices/composers/device_store.dart';
import 'package:users_devices/composers/fake_connection_status_handler.dart';
import 'package:users_devices/composers/user_store.dart';
import 'package:users_devices/core/store.dart';
import 'package:users_devices/data/sources/fake_api_client.dart';
import 'package:users_devices/models/device.dart';
import 'package:users_devices/models/user.dart';
import 'package:users_devices/modules/assignment/page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Maestros(
      [
        Maestro(MaestroInspector(_logAction)),
        Maestro(FakeApiClient()),
        Maestro(Store<int, User>((user) => user.id)),
        Maestro(Store<int, Device>((device) => device.id)),
        Maestro(UserStoreComposer()),
        Maestro(DeviceStoreComposer()),
        Maestro(DeviceAssigmentComposer()),
        Maestro(FakeConnectionStatusHandler()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AssignmentPage(),
      ),
    );
  }
}

bool _logAction<T>(T oldValue, T newValue, Object action) {
  final String description = action == null ? '' : '($action)';
  debugPrint('Maestro$description: $oldValue => $newValue');
  return true;
}
