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

  Future<PagedList<String>> _getData({int page}) async {
    print('_getData: $page');
    await Future.delayed(Duration(seconds: 2));
    if (_isError) {
      return Future.error('something wrong');
    }
    if (page > 5) {
      return PagedList(list: [], next: 0);
    }
    return PagedList(
      list: List.generate(10, (i) => 'Item $page - ${(page - 1) * 10 + i + 1}'),
      next: page + 1,
    );
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
            icon: Icon(!_isError ? Icons.error : Icons.check),
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
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(c),
            sliver: SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: SliverAppBarSizedDelegate(
                minHeight: 15,
                maxHeight: 15,
                child: Container(color: Colors.red),
              ),
            ),
          ),
        ],
        controller: _scrollController,
        body: Builder(
          builder: (c) => Scaffold(
            body: PaginationSliverListView<String>(
              data: _data,
              getData: ({indicator}) => _getData(page: indicator),
              controller: _controller,
              scrollController: PrimaryScrollController.of(c),
              paginationSetting: PaginationSetting(
                initialIndicator: 1,
                nothingIndicator: 0,
              ),
              setting: UpdatableDataViewSetting(
                refreshFirst: true,
                clearWhenError: true,
                clearWhenRefresh: true,
                onStateChanged: (_, __) => _fabController.hide(),
                onStartLoading: () => print('onStartLoading'),
                onStopLoading: () => print('onStopLoading'),
                onStartRefreshing: () => print('onStartRefreshing'),
                onStopRefreshing: () => print('onStopRefreshing'),
                onAppend: (l) => print('onAppend: ${l.length}'),
                onError: (e) => print('onError: $e'),
              ),
              itemBuilder: (_, item) => ListTile(
                title: Text(item),
                onTap: () {},
              ),
              separator: Divider(height: 1, thickness: 1),
              useOverlapInjector: true,
              extra: UpdatableDataViewExtraWidgets(
                innerTopWidget: Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner top widget'))),
                innerBottomWidget: Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner bottom widget'))),
                outerTopWidget: Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 23, 10, 8), child: Text('outer top widget'))),
                outerBottomWidget: Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer bottom widget'))),
                inListTopWidgets: [Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('in list top widget')))],
                inListBottomWidgets: [Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('in list bottom widget')))],
                innerTopDivider: Divider(thickness: 1, height: 1),
                innerBottomDivider: Divider(thickness: 1, height: 1),
                outerTopDivider: Divider(thickness: 1, height: 1),
                outerBottomDivider: Divider(thickness: 1, height: 1),
              ),
            ),
            floatingActionButton: ScrollAnimatedFab(
              controller: _fabController,
              scrollController: PrimaryScrollController.of(c), // <<<
              condition: ScrollAnimatedCondition.direction,
              fab: FloatingActionButton(
                child: Icon(Icons.vertical_align_top),
                onPressed: () => _scrollController.scrollToTop(),
                heroTag: 'RefreshableListViewPage',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
