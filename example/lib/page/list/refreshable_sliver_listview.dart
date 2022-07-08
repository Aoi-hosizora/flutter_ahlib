import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class RefreshableSliverListViewPage extends StatefulWidget {
  const RefreshableSliverListViewPage({Key? key}) : super(key: key);

  @override
  _RefreshableSliverListViewPageState createState() => _RefreshableSliverListViewPageState();
}

class _RefreshableSliverListViewPageState extends State<RefreshableSliverListViewPage> {
  final _controller = UpdatableDataViewController();
  final _scrollController = ScrollController();
  final _fabController = AnimatedFabController();
  var _isError = false;
  final _data = <String>[];

  Future<List<String>> _getData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (_isError) {
      return Future.error('something wrong');
    }
    return List.generate(50, (i) => 'Item ${i + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RefreshableSliverListView Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
                showScrollbar: true,
                scrollbarInteractive: true,
                alwaysShowScrollbar: true,
                refreshFirst: true,
                clearWhenError: true,
                clearWhenRefresh: true,
                onStateChanged: (_, __) => _fabController.hide(),
                onStartLoading: () => printLog('onStartLoading'),
                onStopLoading: () => printLog('onStopLoading'),
                onStartRefreshing: () => printLog('onStartRefreshing'),
                onStopRefreshing: () => printLog('onStopRefreshing'),
                onAppend: (l) => printLog('onAppend: ${l.length}'),
                onError: (e) => printLog('onError: $e'),
              ),
              itemBuilder: (_, item) => ListTile(
                title: Text(item),
                onTap: () {},
              ),
              separator: const Divider(height: 1, thickness: 1),
              // hasOverlapAbsorber: true,
              useOverlapInjector: false,
              extra: UpdatableDataViewExtraWidgets(
                innerTopWidget: const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner top widget'))),
                innerBottomWidget: const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner bottom widget'))),
                outerTopWidget: const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 23, 10, 8), child: Text('outer top widget'))),
                outerBottomWidget: const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer bottom widget'))),
                inListTopWidgets: [const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('in list top widget')))].repeat(3),
                inListBottomWidgets: [const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('in list bottom widget')))].repeat(3),
                innerTopDivider: const Divider(thickness: 1, height: 1),
                innerBottomDivider: const Divider(thickness: 1, height: 1),
                outerTopDivider: const Divider(thickness: 1, height: 1),
                outerBottomDivider: const Divider(thickness: 1, height: 1),
              ),
            ),
            floatingActionButton: ScrollAnimatedFab(
              controller: _fabController,
              scrollController: PrimaryScrollController.of(c)!, // <<<
              condition: ScrollAnimatedCondition.direction,
              fab: FloatingActionButton(
                child: const Icon(Icons.vertical_align_top),
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
