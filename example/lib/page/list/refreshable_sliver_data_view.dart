import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class RefreshableSliverDataViewPage extends StatefulWidget {
  const RefreshableSliverDataViewPage({Key? key}) : super(key: key);

  @override
  _RefreshableSliverDataViewPageState createState() => _RefreshableSliverDataViewPageState();
}

enum _Style {
  list,
  grid,
  masonryGrid,
}

class _RefreshableSliverDataViewPageState extends State<RefreshableSliverDataViewPage> {
  final _rdvKey = GlobalKey<RefreshableDataViewState>();
  final _scrollController = ScrollController();
  final _fabController = AnimatedFabController();
  var _style = _Style.list;
  var _isEmpty = false;
  var _isError = false;
  final _data = <String>[];

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    super.dispose();
  }

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
  var _listTopS = true;
  var _listTopW = true;
  var _listBottomW = true;
  var _listBottomS = true;
  var _innerBottomD = true;
  var _innerBottomW = true;
  var _outerBottomD = true;
  var _outerBottomW = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RefreshableDataView (With Sliver) Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _rdvKey.currentState?.refresh(),
          ),
          IconButton(
            icon: Icon(_style == _Style.list ? Icons.list : (_style == _Style.grid ? Icons.grid_view : Icons.space_dashboard)),
            onPressed: () {
              _style = _style == _Style.list ? _Style.grid : (_style == _Style.grid ? _Style.masonryGrid : _Style.list);
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
              _listTopS = (n == 'listTopS' && !_listTopS) || (n != 'listTopS' && _listTopS);
              _listTopW = (n == 'listTopW' && !_listTopW) || (n != 'listTopW' && _listTopW);
              _listBottomW = (n == 'listBottomW' && !_listBottomW) || (n != 'listBottomW' && _listBottomW);
              _listBottomS = (n == 'listBottomS' && !_listBottomS) || (n != 'listBottomS' && _listBottomS);
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
              'listTopS ' + (_listTopS ? 'on' : 'off'),
              'listTopW ' + (_listTopW ? 'on' : 'off'),
              'listBottomW ' + (_listBottomW ? 'on' : 'off'),
              'listBottomS ' + (_listBottomS ? 'on' : 'off'),
              'innerBottomD ' + (_innerBottomD ? 'on' : 'off'),
              'innerBottomW ' + (_innerBottomW ? 'on' : 'off'),
              'outerBottomD ' + (_outerBottomD ? 'on' : 'off'),
              'outerBottomW ' + (_outerBottomW ? 'on' : 'off'),
            ].map((s) => PopupMenuItem(value: s, child: Text(s))).toList(),
          ),
        ],
      ),
      body: NestedScrollView(
        controller: _scrollController,
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
              delegate: SliverHeaderDelegate(
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Container(
                    color: Colors.red,
                    child: const Center(
                      child: Text('Pinned header'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Builder(
            builder: (c) => Scaffold(
              body: RefreshableDataView<String>(
                key: _rdvKey,
                data: _data,
                style: _style == _Style.list
                    ? UpdatableDataViewStyle.sliverListView
                    : _style == _Style.grid
                        ? UpdatableDataViewStyle.sliverGridView
                        : UpdatableDataViewStyle.sliverMasonryGridView,
                getData: () => _getData(),
                scrollController: PrimaryScrollController.of(c),
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
                itemBuilder: (_, idx, item) => _style == _Style.list
                    ? ListTile(
                        title: Text(item),
                        onTap: () {},
                      )
                    : SizedBox(
                        height: _style == _Style.grid //
                            ? 50.0
                            : 50.0 + (idx % 5) * 10,
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
                useOverlapInjector: false,
                crossAxisCount: 4,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 1.0,
                ),
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
                  listTopSlivers: [
                    if (_listTopS) ...[
                      const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list top sliver 1', style: TextStyle(fontStyle: FontStyle.italic))))),
                      const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list top sliver 2', style: TextStyle(fontStyle: FontStyle.italic))))),
                      const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list top sliver 3', style: TextStyle(fontStyle: FontStyle.italic))))),
                      SliverToBoxAdapter(child: Divider(height: 1, thickness: 1, color: Theme.of(context).primaryColor)),
                    ]
                  ],
                  listBottomSlivers: [
                    if (_listBottomS) ...[
                      SliverToBoxAdapter(child: Divider(height: 1, thickness: 1, color: Theme.of(context).primaryColor)),
                      const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list bottom sliver 1', style: TextStyle(fontStyle: FontStyle.italic))))),
                      const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list bottom sliver 2', style: TextStyle(fontStyle: FontStyle.italic))))),
                      const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('list bottom sliver 3', style: TextStyle(fontStyle: FontStyle.italic))))),
                    ]
                  ],
                ),
              ),
              floatingActionButton: ScrollAnimatedFab(
                controller: _fabController,
                scrollController: PrimaryScrollController.of(c)!, // <<<
                condition: ScrollAnimatedCondition.direction,
                fab: FloatingActionButton(
                  child: const Icon(Icons.vertical_align_top),
                  onPressed: () => _scrollController.scrollToTop(),
                  heroTag: null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
