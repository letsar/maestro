import 'package:flutter/material.dart';
import 'package:maestro/maestro.dart';
import 'package:users_devices/composers/device_assignment.dart';
import 'package:users_devices/core/store.dart';
import 'package:users_devices/core/widgets/interceptor.dart';
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
    final Store<int, User> userStore = context.listen<Store<int, User>>();
    final List<User> users = userStore.values.toList();

    return CustomScrollView(
      slivers: <Widget>[
        const SliverPinnedHeader(
          height: 120,
          child: _UnassignedDevices(),
        ),
        SliverFixedExtentList(
          itemExtent: 120,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Interceptor(
                value: users[index],
                onChanged: (value) => userStore.write(value),
                child: const _Assignments(),
              );
            },
            childCount: users.length,
          ),
        )
      ],
    );
  }
}

class _UnassignedDevices extends StatelessWidget {
  const _UnassignedDevices({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Device> unassignedDevices =
        context.select<Store<int, Device>, List<Device>>(
            (deviceStore) => deviceStore.unassignedDevices());

    // Should be read-only.
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Maestro(
        unassignedDevices,
        child: const _DeviceList(),
        key: UniqueKey(),
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
    final Store<int, Device> deviceStore = context.read<Store<int, Device>>();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return Interceptor(
          value: devices[index],
          onChanged: (value) => deviceStore.write(value),
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
    final Device device = context.listen<Device>();

    final Widget item = _Item(
      backgroundColor: device.connected ? Colors.green : Colors.grey,
      text: device.id.toString(),
    );

    return Draggable<int>(
      data: device.id,
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
    return Row(
      children: <Widget>[
        const _UserAvatar(),
        const Expanded(
          child: _AssignedDevices(),
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.listen<User>();

    return DragTarget<int>(
      onWillAccept: (deviceId) => !user.deviceIds.contains(deviceId),
      onAccept: (deviceId) {
        context.read<DeviceAssigmentComposer>().assign(deviceId, user.id);
      },
      builder: (context, candidateData, rejectedData) {
        return _Item(text: user.initials);
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
    final Store<int, Device> deviceStore = context.read<Store<int, Device>>();
    final List<Device> assignedDevices = context.select<User, List<Device>>(
        (user) => user.deviceIds.map((id) => deviceStore.read(id)).toList());

    // Should be read-only.
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Maestro(
        assignedDevices,
        child: const _DeviceList(),
        key: UniqueKey(),
      ),
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

extension on Store<int, Device> {
  List<Device> unassignedDevices() {
    return values.where((device) => device.ownerId == null).toList();
  }
}
