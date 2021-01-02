import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RefreshableStaggeredGridViewPage extends StatefulWidget {
  @override
  _RefreshableStaggeredGridViewPageState createState() => _RefreshableStaggeredGridViewPageState();
}

class _RefreshableStaggeredGridViewPageState extends State<RefreshableStaggeredGridViewPage> {
  final _controller = UpdatableDataViewController();
  final _scrollController = ScrollController();
  final _fabController = AnimatedFabController();
  var _isError = false;
  var _data = <String>[];

  Future<List<String>> _getData() async {
    await Future.delayed(Duration(seconds: 2));
    if (_isError) {
      return Future.error('something wrong');
    }
    return List.generate(50, (i) => 'Item ${i + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RefreshableStaggeredGridView Example'),
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
      body: RefreshableStaggeredGridView<String>(
        data: _data,
        getData: () => _getData(),
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
        crossAxisCount: 2 * 3,
        staggeredTileBuilder: (_) => StaggeredTile.fit(2),
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
          heroTag: 'RefreshableSliverListViewPage',
        ),
      ),
    );
  }
}
