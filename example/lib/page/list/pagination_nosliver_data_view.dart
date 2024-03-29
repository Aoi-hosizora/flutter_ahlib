import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PaginationNoSliverDataViewPage extends StatefulWidget {
  const PaginationNoSliverDataViewPage({Key? key}) : super(key: key);

  @override
  _PaginationNoSliverDataViewPageState createState() => _PaginationNoSliverDataViewPageState();
}

enum _Style {
  list,
  grid,
  masonryGrid,
  custom,
}

class _PaginationNoSliverDataViewPageState extends State<PaginationNoSliverDataViewPage> {
  final _pdvKey = GlobalKey<PaginationDataViewState>();
  final _scrollController = ScrollController();
  final _fabController = AnimatedFabController();
  var _style = _Style.list;
  var _isEmpty = false;
  var _isError = false;
  final _data = <String>[]; // <String>['1', '2', '3', '4', '5']

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  Future<PagedList<String>> _getData({required int page}) async {
    printLog('_getData: $page');
    if (page > 5) {
      return const PagedList(list: [], next: 0);
    }
    await Future.delayed(const Duration(milliseconds: 1500));
    if (_isEmpty) {
      return const PagedList(list: [], next: 0);
    }
    if (_isError) {
      return Future.error('something wrong');
    }
    return PagedList(
      list: List.generate(10, (i) => 'Item $page - ${(page - 1) * 10 + i + 1}'),
      next: page == 5 ? 0 : page + 1,
    );
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
        title: const Text('PaginationDataView (No Sliver) Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _pdvKey.currentState?.refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: () => _pdvKey.currentState?.append(),
          ),
          IconButton(
            icon: Icon(
              _style == _Style.list
                  ? Icons.list
                  : _style == _Style.grid
                      ? Icons.grid_view
                      : _style == _Style.masonryGrid
                          ? Icons.space_dashboard
                          : Icons.view_carousel,
            ),
            onPressed: () {
              _style = _style == _Style.list
                  ? _Style.grid
                  : _style == _Style.grid
                      ? _Style.masonryGrid
                      : _style == _Style.masonryGrid
                          ? _Style.custom
                          : _Style.list;
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
      body: PaginationDataView<String>(
        key: _pdvKey,
        data: _data,
        style: _style == _Style.list
            ? UpdatableDataViewStyle.listView
            : _style == _Style.grid
                ? UpdatableDataViewStyle.gridView
                : _style == _Style.masonryGrid
                    ? UpdatableDataViewStyle.masonryGridView
                    : UpdatableDataViewStyle.customView,
        getData: ({indicator}) => _getData(page: indicator),
        scrollController: _scrollController,
        paginationSetting: const PaginationSetting(
          initialIndicator: 1,
          nothingIndicator: 0,
          // currentNextIndicator: 1,
        ),
        setting: UpdatableDataViewSetting(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          scrollbar: true,
          alwaysShowScrollbar: false,
          interactiveScrollbar: true,
          scrollbarCrossAxisMargin: 2,
          refreshFirst: false,
          clearWhenError: true,
          clearWhenRefresh: true,
          updateOnlyIfNotEmpty: false,
          onPlaceholderStateChanged: (_, __) => _fabController.hide(),
          onStartRefreshing: () => printLog('onStartRefreshing'),
          onStartGettingData: () => printLog('onStartGettingData'),
          onAppend: (i, l) => printLog('onAppend: $i (${_pdvKey.currentState?.currentIndicator}), #=${l.length}'),
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
                height: _style == _Style.grid || _style == _Style.custom //
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
        crossAxisCount: 4,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          childAspectRatio: 1.0,
        ),
        customViewBuilder: (c, v) => GridView.custom(
          controller: PreviouslySwitchedWidget.isPrevious(context) ? null : v.scrollController,
          padding: v.setting.padding,
          physics: v.setting.physics ?? const AlwaysScrollableScrollPhysics(),
          reverse: v.setting.reverse ?? false,
          shrinkWrap: v.setting.shrinkWrap ?? false,
          cacheExtent: v.setting.cacheExtent,
          dragStartBehavior: v.setting.dragStartBehavior ?? DragStartBehavior.start,
          keyboardDismissBehavior: v.setting.keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
          restorationId: v.setting.restorationId,
          clipBehavior: v.setting.clipBehavior ?? Clip.hardEdge,
          // ===================================
          gridDelegate: SliverWovenGridDelegate.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            pattern: const [
              WovenGridTile(1),
              WovenGridTile(5 / 7, alignment: AlignmentDirectional.centerEnd),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            (c, idx) => v.itemBuilder(c, idx, v.data[idx]), // ignore extra listTopWidgets and listBottomWidgets
            childCount: v.data.length,
          ),
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
        ),
      ),
      floatingActionButton: ScrollAnimatedFab(
        controller: _fabController,
        scrollController: _scrollController,
        condition: ScrollAnimatedCondition.direction,
        fab: FloatingActionButton(
          child: const Icon(Icons.vertical_align_top),
          onPressed: () => _scrollController.scrollToTop(),
          heroTag: null,
        ),
      ),
    );
  }
}
