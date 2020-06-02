import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:infinite_list/home/state.dart';
import 'package:infinite_list/models/post.dart';
import 'package:maestro/maestro.dart';

class HomeComposer with Composer {
  HomeComposer({
    http.Client httpClient,
  }) : httpClient = httpClient ?? http.Client();

  final http.Client httpClient;

  @override
  Future<void> play() => fetch();

  Future<void> fetch() async {
    final HomeState currentState = read<HomeState>();
    if (!_hasReachedMax(currentState)) {
      try {
        if (currentState is HomeStateInitial) {
          final List<Post> posts = await _fetchPosts(0, 20);
          write(HomeState.success(posts: posts, hasReachedMax: false));
        } else if (currentState is HomeStateSuccess) {
          final int startIndex = currentState.posts.length;
          final List<Post> posts = await _fetchPosts(startIndex, 20);
          final HomeState state = posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : HomeState.success(
                  posts: currentState.posts + posts,
                  hasReachedMax: false,
                );
          write(state);
        }
      } catch (_) {
        write(const HomeState.failure());
      }
    }
  }

  bool _hasReachedMax(HomeState state) =>
      state is HomeStateSuccess && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final http.Response response =
        await httpClient.get('https://jsonplaceholder.typicode.com/posts');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data
          .map((rawPost) {
            return Post(
              id: rawPost['id'],
              title: rawPost['title'],
              body: rawPost['body'],
            );
          })
          .skip(startIndex)
          .take(limit)
          .toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
