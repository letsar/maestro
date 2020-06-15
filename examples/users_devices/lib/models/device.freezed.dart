// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Device _$DeviceFromJson(Map<String, dynamic> json) {
  return _Device.fromJson(json);
}

class _$DeviceTearOff {
  const _$DeviceTearOff();

  _Device call(
      {@required int id,
      @required String name,
      int ownerId,
      bool connected = false}) {
    return _Device(
      id: id,
      name: name,
      ownerId: ownerId,
      connected: connected,
    );
  }
}

// ignore: unused_element
const $Device = _$DeviceTearOff();

mixin _$Device {
  int get id;
  String get name;
  int get ownerId;
  bool get connected;

  Map<String, dynamic> toJson();
  $DeviceCopyWith<Device> get copyWith;
}

abstract class $DeviceCopyWith<$Res> {
  factory $DeviceCopyWith(Device value, $Res Function(Device) then) =
      _$DeviceCopyWithImpl<$Res>;
  $Res call({int id, String name, int ownerId, bool connected});
}

class _$DeviceCopyWithImpl<$Res> implements $DeviceCopyWith<$Res> {
  _$DeviceCopyWithImpl(this._value, this._then);

  final Device _value;
  // ignore: unused_field
  final $Res Function(Device) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object ownerId = freezed,
    Object connected = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as String,
      ownerId: ownerId == freezed ? _value.ownerId : ownerId as int,
      connected: connected == freezed ? _value.connected : connected as bool,
    ));
  }
}

abstract class _$DeviceCopyWith<$Res> implements $DeviceCopyWith<$Res> {
  factory _$DeviceCopyWith(_Device value, $Res Function(_Device) then) =
      __$DeviceCopyWithImpl<$Res>;
  @override
  $Res call({int id, String name, int ownerId, bool connected});
}

class __$DeviceCopyWithImpl<$Res> extends _$DeviceCopyWithImpl<$Res>
    implements _$DeviceCopyWith<$Res> {
  __$DeviceCopyWithImpl(_Device _value, $Res Function(_Device) _then)
      : super(_value, (v) => _then(v as _Device));

  @override
  _Device get _value => super._value as _Device;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object ownerId = freezed,
    Object connected = freezed,
  }) {
    return _then(_Device(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as String,
      ownerId: ownerId == freezed ? _value.ownerId : ownerId as int,
      connected: connected == freezed ? _value.connected : connected as bool,
    ));
  }
}

@JsonSerializable()
class _$_Device with DiagnosticableTreeMixin implements _Device {
  const _$_Device(
      {@required this.id,
      @required this.name,
      this.ownerId,
      this.connected = false})
      : assert(id != null),
        assert(name != null),
        assert(connected != null);

  factory _$_Device.fromJson(Map<String, dynamic> json) =>
      _$_$_DeviceFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int ownerId;
  @JsonKey(defaultValue: false)
  @override
  final bool connected;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Device(id: $id, name: $name, ownerId: $ownerId, connected: $connected)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Device'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('ownerId', ownerId))
      ..add(DiagnosticsProperty('connected', connected));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Device &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.ownerId, ownerId) ||
                const DeepCollectionEquality()
                    .equals(other.ownerId, ownerId)) &&
            (identical(other.connected, connected) ||
                const DeepCollectionEquality()
                    .equals(other.connected, connected)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(ownerId) ^
      const DeepCollectionEquality().hash(connected);

  @override
  _$DeviceCopyWith<_Device> get copyWith =>
      __$DeviceCopyWithImpl<_Device>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DeviceToJson(this);
  }
}

abstract class _Device implements Device {
  const factory _Device(
      {@required int id,
      @required String name,
      int ownerId,
      bool connected}) = _$_Device;

  factory _Device.fromJson(Map<String, dynamic> json) = _$_Device.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get ownerId;
  @override
  bool get connected;
  @override
  _$DeviceCopyWith<_Device> get copyWith;
}
