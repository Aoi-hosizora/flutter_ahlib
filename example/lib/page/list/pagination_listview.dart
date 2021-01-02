import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class PaginationListViewPage extends StatefulWidget {
  @override
  _PaginationListViewPageState createState() => _PaginationListViewPageState();
}

class _PaginationListViewPageState extends State<PaginationListViewPage> {
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
        title: Text('RefreshableListView Example'),
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
      body: PaginationListView<String>(
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
          updateOnlyIfNotEmpty: false,
          onStateChanged: (_, __) => _fabController.hide(),
          onStartLoading: () => print('onStartLoading'),
          onStopLoading: () => print('onStopLoading'),
          onAppend: (l) => print('onAppend: ${l.length}'),
          onError: (e) => print('onError: $e'),
          showScrollbar: true,
        ),
        itemBuilder: (_, item) => ListTile(
          title: Text(item),
          onTap: () {},
        ),
        innerTopWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
              child: Text('inner top widget'),
            ),
            Divider(height: 1, thickness: 1),
          ],
        ),
        innerBottomWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 1, thickness: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
              child: Text('inner bottom widget'),
            ),
          ],
        ),
        outerTopWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 10, 8),
              child: Text('outer top widget'),
            ),
            Divider(height: 1, thickness: 1),
          ],
        ),
        outerBottomWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Divider(height: 1, thickness: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 10, 8),
              child: Text('outer bottom widget'),
            ),
          ],
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
