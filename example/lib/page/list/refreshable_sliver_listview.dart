import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class RefreshableSliverListViewPage extends StatefulWidget {
  @override
  _RefreshableSliverListViewPageState createState() => _RefreshableSliverListViewPageState();
}

class _RefreshableSliverListViewPageState extends State<RefreshableSliverListViewPage> {
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
        title: Text('RefreshableSliverListView Example'),
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
            body: RefreshableSliverListView<String>(
              data: _data,
              getData: () => _getData(),
              controller: _controller,
              scrollController: PrimaryScrollController.of(c),
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
              // hasOverlapAbsorber: true,
              useOverlapInjector: false,
              extra: UpdatableDataViewExtraWidgets(
                innerTopWidget: Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner top widget'))),
                innerBottomWidget: Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner bottom widget'))),
                outerTopWidget: Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 23, 10, 8), child: Text('outer top widget'))),
                outerBottomWidget: Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer bottom widget'))),
                inListTopWidgets: [Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('in list top widget')))].repeat(3),
                inListBottomWidgets: [Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('in list bottom widget')))].repeat(3),
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
                heroTag: 'RefreshableSliverListViewPage',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
