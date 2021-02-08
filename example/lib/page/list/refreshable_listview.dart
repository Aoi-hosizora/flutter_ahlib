import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class RefreshableListViewPage extends StatefulWidget {
  @override
  _RefreshableListViewPageState createState() => _RefreshableListViewPageState();
}

class _RefreshableListViewPageState extends State<RefreshableListViewPage> {
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

  var _innerTopW = true;
  var _innerBottomW = true;
  var _outerTopW = true;
  var _outerBottomW = true;
  var _inListTopW = true;
  var _inListBottomW = true;
  var _innerTopD = true;
  var _innerBottomD = true;
  var _outerTopD = true;
  var _outerBottomD = true;

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
            icon: Icon(!_isError ? Icons.error : Icons.check),
            onPressed: () {
              _isError = !_isError;
              if (mounted) setState(() {});
            },
          ),
          PopupMenuButton<String>(
            onSelected: (s) {
              switch (s) {
                case 'innerTopW':
                  _innerTopW = !_innerTopW;
                  break;
                case 'innerBottomW':
                  _innerBottomW = !_innerBottomW;
                  break;
                case 'outerTopW':
                  _outerTopW = !_outerTopW;
                  break;
                case 'outerBottomW':
                  _outerBottomW = !_outerBottomW;
                  break;
                case 'inListTopW':
                  _inListTopW = !_inListTopW;
                  break;
                case 'inListBottomW':
                  _inListBottomW = !_inListBottomW;
                  break;
                case 'innerTopD':
                  _innerTopD = !_innerTopD;
                  break;
                case 'innerBottomD':
                  _innerBottomD = !_innerBottomD;
                  break;
                case 'outerTopD':
                  _outerTopD = !_outerTopD;
                  break;
                case 'outerBottomD':
                  _outerBottomD = !_outerBottomD;
                  break;
              }
              if (mounted) setState(() {});
            },
            itemBuilder: (_) => [
              'outerTopW',
              'outerTopD',
              'innerTopW',
              'innerTopD',
              'inListTopW',
              'inListBottomW',
              'innerBottomD',
              'innerBottomW',
              'outerBottomD',
              'outerBottomW',
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
        extra: UpdatableDataViewExtraWidgets(
          innerTopWidget: _innerTopW ? Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner top widget'))) : null,
          innerBottomWidget: _innerBottomW ? Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.fromLTRB(10, 8, 0, 8), child: Text('inner bottom widget'))) : null,
          outerTopWidget: _outerTopW ? Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer top widget'))) : null,
          outerBottomWidget: _outerBottomW ? Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 10, 8), child: Text('outer bottom widget'))) : null,
          inListTopWidgets: _inListTopW ? [Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('in list top widget')))].repeat(3) : null,
          inListBottomWidgets: _inListBottomW ? [Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text('in list bottom widget')))].repeat(3) : null,
          innerTopDivider: _innerTopD ? Divider(thickness: 1, height: 1) : null,
          innerBottomDivider: _innerBottomD ? Divider(thickness: 1, height: 1) : null,
          outerTopDivider: _outerTopD ? Divider(thickness: 1, height: 1) : null,
          outerBottomDivider: _outerBottomD ? Divider(thickness: 1, height: 1) : null,
        ),
      ),
      floatingActionButton: ScrollAnimatedFab(
        controller: _fabController,
        scrollController: _scrollController,
        condition: ScrollAnimatedCondition.direction,
        fab: FloatingActionButton(
          child: Icon(Icons.vertical_align_top),
          onPressed: () => _scrollController.scrollToTop(),
          heroTag: 'RefreshableListViewPage',
        ),
      ),
    );
  }
}
