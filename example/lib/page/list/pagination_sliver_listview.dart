import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class PaginationSliverListViewPage extends StatefulWidget {
  @override
  _PaginationSliverListViewPageState createState() => _PaginationSliverListViewPageState();
}

class _PaginationSliverListViewPageState extends State<PaginationSliverListViewPage> {
  final _controller = UpdatableDataViewController();
  final _scrollController = ScrollController();
  final _fabController = AnimatedFabController();
  var _isError = false;
  var _data = <String>[];

  Future<List<String>> _getData({int page}) async {
    print('_getData: $page');
    await Future.delayed(Duration(seconds: 2));
    if (_isError) {
      return Future.error('something wrong');
    }
    if (page > 4) {
      return [];
    }
    return List.generate(10, (i) => 'Item $page - ${i + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginationSliverListView Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.refresh(),
          ),
          IconButton(
            icon: BannedIcon(
              banned: !_isError,
              icon: Icon(Icons.error),
              color: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              offset: 1.5,
            ),
            onPressed: () {
              _isError = !_isError;
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (c, _) => [
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Colors.yellow,
            ),
          ),
        ],
        body: PaginationSliverListView<String>(
          data: _data,
          strategy: PaginationStrategy.offsetBased,
          paginationSetting: PaginationSetting(initialPage: 1),
          getDataByOffset: ({int page}) => _getData(page: page),
          controller: _controller,
          scrollController: _scrollController,
          setting: UpdatableDataViewSetting(
            refreshFirst: true,
            clearWhenError: true,
            clearWhenRefresh: true,
            onStateChanged: (_, __) => _fabController.hide(),
            onStartLoading: () => print('onStartLoading'),
            onStopLoading: () => print('onStopLoading'),
            onRefresh: () => print('onRefresh'),
            onAppend: (l) => print('onAppend: ${l.length}'),
            onError: (e) => print('onError: $e'),
            showScrollbar: true,
          ),
          itemBuilder: (_, item) => ListTile(
            title: Text(item),
            onTap: () {},
          ),
        ),
      ),
      floatingActionButton: ScrollAnimatedFab(
        controller: _fabController,
        scrollController: _scrollController,
        fab: FloatingActionButton(
          child: Icon(Icons.vertical_align_top),
          onPressed: () => _scrollController.scrollToTop(),
          heroTag: 'RefreshableListViewPage',
        ),
      ),
    );
  }
}
