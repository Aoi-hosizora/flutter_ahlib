import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class RefreshableListViewPage extends StatefulWidget {
  const RefreshableListViewPage({Key? key}) : super(key: key);

  @override
  _RefreshableListViewPageState createState() => _RefreshableListViewPageState();
}

class _RefreshableListViewPageState extends State<RefreshableListViewPage> {
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

  var _outerTopW = true;
  var _outerTopD = true;
  var _innerTopW = true;
  var _innerTopD = true;
  var _listTopW = true;
  var _listBottomW = true;
  var _innerBottomD = true;
  var _innerBottomW = true;
  var _outerBottomD = true;
  var _outerBottomW = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RefreshableListView Example'),
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
          PopupMenuButton<String>(
            onSelected: (s) {
              switch (s.split(' ')[0]) {
                case 'outerTopW':
                  _outerTopW = !_outerTopW;
                  break;
                case 'outerTopD':
                  _outerTopD = !_outerTopD;
                  break;
                case 'innerTopW':
                  _innerTopW = !_innerTopW;
                  break;
                case 'innerTopD':
                  _innerTopD = !_innerTopD;
                  break;
                case 'listTopW':
                  _listTopW = !_listTopW;
                  break;
                case 'listBottomW':
                  _listBottomW = !_listBottomW;
                  break;
                case 'innerBottomD':
                  _innerBottomD = !_innerBottomD;
                  break;
                case 'innerBottomW':
                  _innerBottomW = !_innerBottomW;
                  break;
                case 'outerBottomD':
                  _outerBottomD = !_outerBottomD;
                  break;
                case 'outerBottomW':
                  _outerBottomW = !_outerBottomW;
                  break;
              }
              if (mounted) setState(() {});
            },
            itemBuilder: (_) => [
              'outerTopW ' + (_outerTopW ? 'on' : 'off'),
              'outerTopD ' + (_outerTopD ? 'on' : 'off'),
              'innerTopW ' + (_innerTopW ? 'on' : 'off'),
              'innerTopD ' + (_innerTopD ? 'on' : 'off'),
              'listTopW ' + (_listTopW ? 'on' : 'off'),
              'listBottomW ' + (_listBottomW ? 'on' : 'off'),
              'innerBottomD ' + (_innerBottomD ? 'on' : 'off'),
              'innerBottomW ' + (_innerBottomW ? 'on' : 'off'),
              'outerBottomD ' + (_outerBottomD ? 'on' : 'off'),
              'outerBottomW ' + (_outerBottomW ? 'on' : 'off'),
            ].map((s) => PopupMenuItem(value: s, child: Text(s))).toList(),
          ),
        ],
      ),
      body: RefreshableListView<String>(
        data: _data,
        getData: () => _getData(),
        controller: _controller,
        scrollController: _scrollController,
        setting: UpdatableDataViewSetting(
          showScrollbar: true,
          alwaysShowScrollbar: true,
          scrollbarInteractive: true,
          scrollbarCrossAxisMargin: 2,
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
        extra: UpdatableDataViewExtraWidgets(
          outerTopWidgets: [
            if (_outerTopW) const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer top widget'))),
            if (_outerTopD) const Divider(thickness: 1, height: 1),
          ],
          innerTopWidgets: [
            if (_innerTopW) const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner top widget'))),
            if (_innerTopD) const Divider(thickness: 1, height: 1),
          ],
          innerBottomWidgets: [
            if (_innerBottomD) const Divider(thickness: 1, height: 1),
            if (_innerBottomW) const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner bottom widget'))),
          ],
          outerBottomWidgets: [
            if (_outerBottomD) const Divider(thickness: 1, height: 1),
            if (_outerBottomW) const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer bottom widget'))),
          ],
          listTopWidgets: _listTopW
              ? [
                  const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list top widget'))),
                ].repeat(3)
              : null,
          listBottomWidgets: _listBottomW
              ? [
                  const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list bottom widget'))),
                ].repeat(3)
              : null,
        ),
      ),
      floatingActionButton: ScrollAnimatedFab(
        controller: _fabController,
        scrollController: _scrollController,
        condition: ScrollAnimatedCondition.direction,
        fab: FloatingActionButton(
          child: const Icon(Icons.vertical_align_top),
          onPressed: () => _scrollController.scrollToTop(),
          heroTag: 'RefreshableListViewPage',
        ),
      ),
    );
  }
}
