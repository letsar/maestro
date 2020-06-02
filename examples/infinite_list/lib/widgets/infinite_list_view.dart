import 'package:flutter/material.dart';

/// A widget.
class InfiniteListView extends StatefulWidget {
  /// Creates an [InfiniteListView].
  const InfiniteListView({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.hasReachedEnd = false,
    this.loadThreshold = 200,
    @required this.onFetch,
  })  : assert(itemBuilder != null),
        assert(itemCount != null),
        assert(hasReachedEnd != null),
        assert(loadThreshold != null),
        assert(onFetch != null),
        super(key: key);

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final bool hasReachedEnd;
  final double loadThreshold;
  final VoidCallback onFetch;

  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return index >= widget.itemCount
            ? const _BottomLoader()
            : widget.itemBuilder(context, index);
      },
      itemCount: widget.hasReachedEnd ? widget.itemCount : widget.itemCount + 1,
    );
  }

  void _handleScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= widget.loadThreshold) {
      widget.onFetch();
    }
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
