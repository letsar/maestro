// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AssignmentResult _$_$_AssignmentResultFromJson(Map<String, dynamic> json) {
  return _$_AssignmentResult(
    users: (json['users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    device: json['device'] == null
        ? null
        : Device.fromJson(json['device'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_AssignmentResultToJson(
        _$_AssignmentResult instance) =>
    <String, dynamic>{
      'users': instance.users,
      'device': instance.device,
    };
