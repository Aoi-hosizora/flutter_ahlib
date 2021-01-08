import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class PaginationListViewPage extends StatefulWidget {
  @override
  _PaginationListViewPageState createState() => _PaginationListViewPageState();
}

class _PaginationListViewPageState extends State<PaginationListViewPage> {
  /*
  final _controller = UpdatableDataViewController();
  final _scrollController = ScrollController();
  final _fabController = AnimatedFabController();
  var _isError = false;
  var _useSeek = false;
  var _data = <String>[];

  Future<List<String>> _getData({int page}) async {
    print('_getData: $page');
    await Future.delayed(Duration(seconds: 2));
    if (_isError) {
      return Future.error('something wrong');
    }
    if (page > 4) {
      return [];
    }
    return List.generate(10, (i) => 'Item $page - ${i + 1}');
  }

  Future<SeekList<String>> _getData2({dynamic maxId}) async {
    print('_getData2: $maxId');
    await Future.delayed(Duration(seconds: 2));
    if (_isError) {
      return Future.error('something wrong');
    }
    if (maxId == 40) {
      return SeekList(list: List.generate(10, (i) => 'Item $maxId - ${maxId - i}').toList(), nextMaxId: 30);
    }
    if (maxId == 30) {
      return SeekList(list: List.generate(10, (i) => 'Item $maxId - ${maxId - i}').toList(), nextMaxId: 20);
    }
    if (maxId == 20) {
      return SeekList(list: List.generate(10, (i) => 'Item $maxId - ${maxId - i}').toList(), nextMaxId: 10);
    }
    if (maxId == 10) {
      return SeekList(list: List.generate(10, (i) => 'Item $maxId - ${maxId - i}').toList(), nextMaxId: 0);
    }
    return SeekList(list: [], nextMaxId: 0);
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RefreshableListView Example'),
        /*
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
          IconButton(
            icon: BannedIcon(
              banned: !_useSeek,
              icon: Icon(Icons.place),
              color: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              offset: 1.5,
            ),
            onPressed: () {
              _useSeek = !_useSeek;
              if (mounted) setState(() {});
              _controller.refresh();
            },
          ),
        ],
         */
      ),
      /*
      body: PaginationListView<String>(
        data: _data,
        strategy: !_useSeek ? PaginationStrategy.offsetBased : PaginationStrategy.seekBased,
        paginationSetting: PaginationSetting(
          initialPage: 1,
          initialMaxId: 40,
          nothingMaxId: 0,
        ),
        getDataByOffset: !_useSeek ? ({int page}) => _getData(page: page) : null,
        getDataBySeek: _useSeek ? ({dynamic maxId}) => _getData2(maxId: maxId) : null,
        controller: _controller,
        scrollController: _scrollController,
        setting: UpdatableDataViewSetting(
          refreshFirst: true,
          clearWhenError: true,
          clearWhenRefresh: true,
          updateOnlyIfNotEmpty: false,
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
      ),
      floatingActionButton: ScrollAnimatedFab(
        controller: _fabController,
        scrollController: _scrollController,
        fab: FloatingActionButton(
          child: Icon(Icons.vertical_align_top),
          onPressed: () => _scrollController.scrollToTop(),
          heroTag: 'RefreshableListViewPage',
        ),
      ),
       */
    );
  }
}
