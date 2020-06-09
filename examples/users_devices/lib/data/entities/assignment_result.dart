import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:users_devices/models/device.dart';
import 'package:users_devices/models/user.dart';

part 'assignment_result.freezed.dart';
part 'assignment_result.g.dart';

@freezed
abstract class AssignmentResult with _$AssignmentResult {
  const factory AssignmentResult({
    List<User> users,
    Device device,
  }) = _AssignmentResult;

  factory AssignmentResult.fromJson(Map<String, dynamic> json) =>
      _$AssignmentResultFromJson(json);
}
