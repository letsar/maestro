// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Device _$_$_DeviceFromJson(Map<String, dynamic> json) {
  return _$_Device(
    id: json['id'] as int,
    name: json['name'] as String,
    ownerId: json['ownerId'] as int,
    connected: json['connected'] as bool ?? false,
  );
}

Map<String, dynamic> _$_$_DeviceToJson(_$_Device instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ownerId': instance.ownerId,
      'connected': instance.connected,
    };
