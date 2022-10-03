import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class RefreshableNoSliverDataViewPage extends StatefulWidget {
  const RefreshableNoSliverDataViewPage({Key? key}) : super(key: key);

  @override
  _RefreshableNoSliverDataViewPageState createState() => _RefreshableNoSliverDataViewPageState();
}

class _RefreshableNoSliverDataViewPageState extends State<RefreshableNoSliverDataViewPage> {
  final _rdvKey = GlobalKey<RefreshableDataViewState>();
  final _scrollController = ScrollController();
  final _fabController = AnimatedFabController();
  var _listOrGrid = true;
  var _isEmpty = false;
  var _isError = false;
  final _data = <String>[];

  Future<List<String>> _getData() async {
    printLog('_getData');
    await Future.delayed(const Duration(milliseconds: 1500));
    if (_isEmpty) {
      return [];
    }
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
        title: const Text('RefreshableDataView (No Sliver) Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _rdvKey.currentState?.refresh(),
          ),
          IconButton(
            icon: Icon(_listOrGrid ? Icons.list : Icons.grid_view),
            onPressed: () {
              _listOrGrid = !_listOrGrid;
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: Icon(_isEmpty
                ? Icons.delete
                : _isError
                    ? Icons.error
                    : Icons.check),
            onPressed: () {
              if (_isEmpty) {
                _isEmpty = false;
                _isError = true;
              } else if (_isError) {
                _isEmpty = false;
                _isError = false;
              } else {
                _isEmpty = true;
                _isError = false;
              }
              if (mounted) setState(() {});
            },
          ),
          PopupMenuButton<String>(
            onSelected: (s) {
              var n = s.split(' ')[0];
              _outerTopW = (n == 'outerTopW' && !_outerTopW) || (n != 'outerTopW' && _outerTopW);
              _outerTopD = (n == 'outerTopD' && !_outerTopD) || (n != 'outerTopD' && _outerTopD);
              _innerTopW = (n == 'innerTopW' && !_innerTopW) || (n != 'innerTopW' && _innerTopW);
              _innerTopD = (n == 'innerTopD' && !_innerTopD) || (n != 'innerTopD' && _innerTopD);
              _listTopW = (n == 'listTopW' && !_listTopW) || (n != 'listTopW' && _listTopW);
              _listBottomW = (n == 'listBottomW' && !_listBottomW) || (n != 'listBottomW' && _listBottomW);
              _innerBottomD = (n == 'innerBottomD' && !_innerBottomD) || (n != 'innerBottomD' && _innerBottomD);
              _innerBottomW = (n == 'innerBottomW' && !_innerBottomW) || (n != 'innerBottomW' && _innerBottomW);
              _outerBottomD = (n == 'outerBottomD' && !_outerBottomD) || (n != 'outerBottomD' && _outerBottomD);
              _outerBottomW = (n == 'outerBottomW' && !_outerBottomW) || (n != 'outerBottomW' && _outerBottomW);
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
      body: RefreshableDataView<String>(
        key: _rdvKey,
        data: _data,
        style: _listOrGrid ? UpdatableDataViewStyle.listView : UpdatableDataViewStyle.masonryGridView,
        getData: () => _getData(),
        scrollController: _scrollController,
        setting: UpdatableDataViewSetting(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          scrollbar: true,
          alwaysShowScrollbar: false,
          interactiveScrollbar: true,
          scrollbarCrossAxisMargin: 2,
          refreshFirst: true,
          clearWhenError: true,
          clearWhenRefresh: true,
          onPlaceholderStateChanged: (_, __) => _fabController.hide(),
          onStartRefreshing: () => printLog('onStartRefreshing'),
          onStartGettingData: () => printLog('onStartGettingData'),
          onAppend: (i, l) => printLog('onAppend: $i (null), #=${l.length}'),
          onError: (e) => printLog('onError: $e'),
          onStopGettingData: () => printLog('onStopGettingData'),
          onStopRefreshing: () => printLog('onStopRefreshing'),
          onFinalSetState: () => printLog('onFinalSetState'),
        ),
        itemBuilder: (_, idx, item) => _listOrGrid
            ? ListTile(
                title: Text(item),
                onTap: () {},
              )
            : SizedBox(
                height: 50.0 + (idx % 5) * 10,
                child: Card(
                  elevation: 4.0,
                  child: InkWell(
                    child: Center(
                      child: Text(item),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
        separator: const Divider(height: 1, thickness: 1),
        crossAxisCount: 4,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
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
          listTopWidgets: [
            if (_listTopW) ...[
              const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list top widget 1'))),
              const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list top widget 2'))),
              const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list top widget 3'))),
            ]
          ],
          listBottomWidgets: [
            if (_listBottomW) ...[
              const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list bottom widget 1'))),
              const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list bottom widget 2'))),
              const Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list bottom widget 3'))),
            ]
          ],
        ),
      ),
      floatingActionButton: ScrollAnimatedFab(
        controller: _fabController,
        scrollController: _scrollController,
        condition: ScrollAnimatedCondition.direction,
        fab: FloatingActionButton(
          child: const Icon(Icons.vertical_align_top),
          onPressed: () => _scrollController.scrollToTop(),
          heroTag: 'RefreshableNoSliverDataViewPage',
        ),
      ),
    );
  }
}
