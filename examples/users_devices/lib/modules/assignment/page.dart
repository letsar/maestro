import 'package:flutter/material.dart';
import 'package:maestro/maestro.dart';
import 'package:users_devices/composers/device_assignment.dart';
import 'package:users_devices/composers/device_store.dart';
import 'package:users_devices/composers/user_store.dart';
import 'package:users_devices/core/widgets/sliver_pinned_header.dart';
import 'package:users_devices/models/device.dart';
import 'package:users_devices/models/user.dart';

/// A widget.
class AssignmentPage extends StatelessWidget {
  /// Creates a [AssignmentPage].
  const AssignmentPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: _Page(),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _debugPrint('_Page');

    return CustomScrollView(
      slivers: <Widget>[
        const SliverPinnedHeader(
          height: 120,
          child: _UnassignedDevices(),
        ),
        const _Users(),
      ],
    );
  }
}

class _Users extends StatelessWidget {
  const _Users({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<User> users =
        context.select((Map<int, User> userMap) => userMap.values.toList());

    _debugPrint('_Users');

    return SliverFixedExtentList(
      itemExtent: 120,
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Maestro<User>.readOnly(
            users[index],
            onWrite: (r) => context.read<UserStore>().overwrite(r.value),
            child: const _Assignments(),
          );
        },
        childCount: users.length,
      ),
    );
  }
}

class _UnassignedDevices extends StatelessWidget {
  const _UnassignedDevices({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Device> unassignedDevices = context
        .select((Map<int, Device> deviceMap) => deviceMap.unassignedDevices());
    _debugPrint('_UnassignedDevices');

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Maestro.readOnly(
        unassignedDevices,
        child: const _DeviceList(),
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Device> devices = context.listen<List<Device>>();

    _debugPrint('_DeviceList');

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return Maestro<Device>.readOnly(
          devices[index],
          onWrite: (r) => context.read<DeviceStore>().overwrite(r.value),
          child: const _Device(),
        );
      },
    );
  }
}

class _Device extends StatelessWidget {
  const _Device({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int deviceId = context.select((Device device) => device.id);
    final bool connected = context.select((Device device) => device.connected);

    _debugPrint('_Device $deviceId');

    final Widget item = _Item(
      backgroundColor: connected ? Colors.green : Colors.grey,
      text: deviceId.toString(),
    );

    return Draggable<int>(
      data: deviceId,
      feedback: item,
      child: item,
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: item,
      ),
    );
  }
}

class _Assignments extends StatelessWidget {
  const _Assignments({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _debugPrint('_Assignments ${context.read<User>().initials}');

    final List<Device> assignedDevices = context.select(
        (Map<int, Device> deviceMap) => context
            .select((User user) => user.deviceIds)
            .map((id) => deviceMap[id])
            .toList());

    return Maestro.readOnly(
      assignedDevices,
      child: Row(
        children: <Widget>[
          const _UserAvatar(),
          const Expanded(
            child: _AssignedDevices(),
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool connected = context.select((List<Device> assignedDevices) =>
        assignedDevices.any((device) => device.connected));
    final String initials = context.select((User user) => user.initials);

    _debugPrint('_UserAvatar $initials');

    final Widget child = _Item(
      text: initials,
      backgroundColor: connected ? Colors.green.shade900 : Colors.blue.shade900,
    );

    return DragTarget<int>(
      onWillAccept: (deviceId) =>
          !context.read<User>().deviceIds.contains(deviceId),
      onAccept: (deviceId) {
        context
            .read<DeviceAssigmentComposer>()
            .assign(deviceId, context.read<User>().id);
      },
      builder: (context, candidateData, rejectedData) {
        return child;
      },
    );
  }
}

class _AssignedDevices extends StatelessWidget {
  const _AssignedDevices({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _debugPrint('_AssignedDevices ${context.read<User>().initials}');

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: const _DeviceList(),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key key,
    @required this.text,
    this.backgroundColor,
    this.foregroundColor,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    _debugPrint('_Item $text');

    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor ?? Colors.white,
        minRadius: 40,
        child: Text(text),
      ),
    );
  }
}

extension on Map<int, Device> {
  List<Device> unassignedDevices() {
    return values.where((device) => device.ownerId == null).toList();
  }
}

int _debugCount = 0;

void _debugPrint(String text) {
  _debugCount++;
  debugPrint('$_debugCount $text');
}
