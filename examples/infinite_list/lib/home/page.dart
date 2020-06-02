import 'package:flutter/material.dart';
import 'package:infinite_list/home/composer.dart';
import 'package:infinite_list/home/state.dart';
import 'package:infinite_list/models/post.dart';
import 'package:infinite_list/widgets/infinite_list_view.dart';
import 'package:maestro/maestro.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Maestros(
      [
        const Maestro(HomeState.initial()),
        Maestro(HomeComposer()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('Posts')),
        body: const _Page(),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeState currentState = context.listen<HomeState>();
    return currentState.map(
      initial: (s) => const _Initial(),
      success: (s) => _Success(state: s),
      failure: (s) => const _Failure(),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({Key key, this.state}) : super(key: key);

  final HomeStateSuccess state;

  @override
  Widget build(BuildContext context) {
    if (state.posts.isEmpty) {
      return Center(
        child: Text('no posts'),
      );
    } else {
      return InfiniteListView(
        onFetch: () => context.read<HomeComposer>().fetch(),
        itemCount: state.posts.length,
        itemBuilder: (context, index) {
          return _Post(post: state.posts[index]);
        },
        hasReachedEnd: state.hasReachedMax,
      );
    }
  }
}

class _Failure extends StatelessWidget {
  const _Failure({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('failed to fetch posts'),
    );
  }
}

class _Post extends StatelessWidget {
  const _Post({Key key, @required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${post.id}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text(post.title),
      isThreeLine: true,
      subtitle: Text(post.body),
      dense: true,
    );
  }
}
