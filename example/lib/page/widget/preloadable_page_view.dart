import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class PreloadablePageViewPage extends StatefulWidget {
  const PreloadablePageViewPage({Key? key}) : super(key: key);

  @override
  State<PreloadablePageViewPage> createState() => _PreloadablePageViewPageState();
}

class _PreloadablePageViewPageState extends State<PreloadablePageViewPage> with SingleTickerProviderStateMixin {
  static const _pageCount = 20;

  late final _tabController = TabController(length: _pageCount, vsync: this);
  final _pageController = PageController(initialPage: 0);
  var _horizontal = true;
  var _changePageWhenFinished = true;
  var _largerHintSize = false;

  @override
  void initState() {
    super.initState();
    _tabController.addListener(() async {
      _pageController.jumpToPage(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PreloadablePageView example'),
        actions: [
          IconButton(
            icon: Text(_horizontal ? 'Hori' : 'Vert'),
            onPressed: () {
              _horizontal = !_horizontal;
              if (mounted) setState(() {});
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: List.generate(_pageCount, (i) => Tab(text: i.toString())),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PreloadablePageView.builder(
              controller: _pageController,
              scrollDirection: _horizontal ? Axis.horizontal : Axis.vertical,
              preloadPagesCount: 2,
              changePageWhenFinished: _changePageWhenFinished,
              onPageChanged: (i) {
                _tabController.index = _pageController.page?.round() ?? 0;
              },
              pageMainAxisHintSize: !_largerHintSize
                  ? null
                  : _horizontal
                      ? MediaQuery.of(context).size.width + 5
                      : MediaQuery.of(context).size.height + 5 /* <<< */,
              itemCount: _pageCount,
              itemBuilder: (c, i) => _TestPage(i: i),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                const Text('preloadPagesCount: 2'),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('changePageWhenFinished'),
                    Switch(value: _changePageWhenFinished, onChanged: (b) => mountedSetState(() => _changePageWhenFinished = b)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('largerHintSize'),
                    Switch(value: _largerHintSize, onChanged: (b) => mountedSetState(() => _largerHintSize = b)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TestPage extends StatefulWidget {
  const _TestPage({
    Key? key,
    required this.i,
  }) : super(key: key);

  final int i;

  @override
  State<_TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<_TestPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    printLog('init page ${widget.i}');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Text('Page ${widget.i}'),
      ),
    );
  }
}
