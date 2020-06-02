import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_list/models/post.dart';

part 'state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeStateInitial;

  const factory HomeState.success({
    @required List<Post> posts,
    bool hasReachedMax,
  }) = HomeStateSuccess;

  const factory HomeState.failure() = HomeStateFailure;
}
