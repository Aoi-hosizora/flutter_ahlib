import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class RefreshableMasonryGridViewPage extends StatefulWidget {
  const RefreshableMasonryGridViewPage({Key? key}) : super(key: key);

  @override
  State<RefreshableMasonryGridViewPage> createState() => _RefreshableMasonryGridViewPageState();
}

class _RefreshableMasonryGridViewPageState extends State<RefreshableMasonryGridViewPage> {
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
        title: const Text('RefreshableStaggeredGridView Example'),
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
      body: RefreshableMasonryGridView<String>(
        data: _data,
        getData: () => _getData(),
        controller: _controller,
        scrollController: _scrollController,
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
        itemBuilder: (_, item) => Card(
          child: ListTile(
            title: SizedBox(
              height: 20.0 + Random().nextInt(10) * 10,
              child: Text(item),
            ),
            onTap: () {},
          ),
        ),
        crossAxisCount: 4,
        extra: UpdatableDataViewExtraWidgets(
          innerTopWidget: const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner top widget'))),
          innerBottomWidget: const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner bottom widget'))),
          outerTopWidget: const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer top widget'))),
          outerBottomWidget: const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer bottom widget'))),
          inListTopWidgets: [const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('in list top widget')))].repeat(3),
          // ignore
          inListBottomWidgets: [const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('in list bottom widget')))].repeat(3),
          // ignore
          innerTopDivider: const Divider(thickness: 1, height: 1),
          innerBottomDivider: const Divider(thickness: 1, height: 1),
          outerTopDivider: const Divider(thickness: 1, height: 1),
          outerBottomDivider: const Divider(thickness: 1, height: 1),
        ),
      ),
      floatingActionButton: ScrollAnimatedFab(
        controller: _fabController,
        scrollController: _scrollController,
        condition: ScrollAnimatedCondition.direction,
        fab: FloatingActionButton(
          child: const Icon(Icons.vertical_align_top),
          onPressed: () => _scrollController.scrollToTop(),
          heroTag: 'RefreshableStaggeredGridView',
        ),
      ),
    );
  }
}
