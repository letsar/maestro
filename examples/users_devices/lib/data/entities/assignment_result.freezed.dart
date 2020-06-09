// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'assignment_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
AssignmentResult _$AssignmentResultFromJson(Map<String, dynamic> json) {
  return _AssignmentResult.fromJson(json);
}

class _$AssignmentResultTearOff {
  const _$AssignmentResultTearOff();

  _AssignmentResult call({List<User> users, Device device}) {
    return _AssignmentResult(
      users: users,
      device: device,
    );
  }
}

// ignore: unused_element
const $AssignmentResult = _$AssignmentResultTearOff();

mixin _$AssignmentResult {
  List<User> get users;
  Device get device;

  Map<String, dynamic> toJson();
  $AssignmentResultCopyWith<AssignmentResult> get copyWith;
}

abstract class $AssignmentResultCopyWith<$Res> {
  factory $AssignmentResultCopyWith(
          AssignmentResult value, $Res Function(AssignmentResult) then) =
      _$AssignmentResultCopyWithImpl<$Res>;
  $Res call({List<User> users, Device device});

  $DeviceCopyWith<$Res> get device;
}

class _$AssignmentResultCopyWithImpl<$Res>
    implements $AssignmentResultCopyWith<$Res> {
  _$AssignmentResultCopyWithImpl(this._value, this._then);

  final AssignmentResult _value;
  // ignore: unused_field
  final $Res Function(AssignmentResult) _then;

  @override
  $Res call({
    Object users = freezed,
    Object device = freezed,
  }) {
    return _then(_value.copyWith(
      users: users == freezed ? _value.users : users as List<User>,
      device: device == freezed ? _value.device : device as Device,
    ));
  }

  @override
  $DeviceCopyWith<$Res> get device {
    if (_value.device == null) {
      return null;
    }
    return $DeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

abstract class _$AssignmentResultCopyWith<$Res>
    implements $AssignmentResultCopyWith<$Res> {
  factory _$AssignmentResultCopyWith(
          _AssignmentResult value, $Res Function(_AssignmentResult) then) =
      __$AssignmentResultCopyWithImpl<$Res>;
  @override
  $Res call({List<User> users, Device device});

  @override
  $DeviceCopyWith<$Res> get device;
}

class __$AssignmentResultCopyWithImpl<$Res>
    extends _$AssignmentResultCopyWithImpl<$Res>
    implements _$AssignmentResultCopyWith<$Res> {
  __$AssignmentResultCopyWithImpl(
      _AssignmentResult _value, $Res Function(_AssignmentResult) _then)
      : super(_value, (v) => _then(v as _AssignmentResult));

  @override
  _AssignmentResult get _value => super._value as _AssignmentResult;

  @override
  $Res call({
    Object users = freezed,
    Object device = freezed,
  }) {
    return _then(_AssignmentResult(
      users: users == freezed ? _value.users : users as List<User>,
      device: device == freezed ? _value.device : device as Device,
    ));
  }
}

@JsonSerializable()
class _$_AssignmentResult
    with DiagnosticableTreeMixin
    implements _AssignmentResult {
  const _$_AssignmentResult({this.users, this.device});

  factory _$_AssignmentResult.fromJson(Map<String, dynamic> json) =>
      _$_$_AssignmentResultFromJson(json);

  @override
  final List<User> users;
  @override
  final Device device;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AssignmentResult(users: $users, device: $device)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AssignmentResult'))
      ..add(DiagnosticsProperty('users', users))
      ..add(DiagnosticsProperty('device', device));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AssignmentResult &&
            (identical(other.users, users) ||
                const DeepCollectionEquality().equals(other.users, users)) &&
            (identical(other.device, device) ||
                const DeepCollectionEquality().equals(other.device, device)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(users) ^
      const DeepCollectionEquality().hash(device);

  @override
  _$AssignmentResultCopyWith<_AssignmentResult> get copyWith =>
      __$AssignmentResultCopyWithImpl<_AssignmentResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AssignmentResultToJson(this);
  }
}

abstract class _AssignmentResult implements AssignmentResult {
  const factory _AssignmentResult({List<User> users, Device device}) =
      _$_AssignmentResult;

  factory _AssignmentResult.fromJson(Map<String, dynamic> json) =
      _$_AssignmentResult.fromJson;

  @override
  List<User> get users;
  @override
  Device get device;
  @override
  _$AssignmentResultCopyWith<_AssignmentResult> get copyWith;
}
