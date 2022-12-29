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
  var _callPageChangedAtEnd = false;
  var _largerHintSize = false;
  var _animateToPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PreloadablePageView Example'),
        actions: [
          IconButton(
            icon: Text(_horizontal ? 'Hori' : 'Vert'),
            onPressed: () {
              _horizontal = !_horizontal;
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: const Text('TabBarView'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => const _TestTabBarViewPage(),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (i) => (_animateToPage ? _pageController.defaultAnimateToPage : _pageController.jumpToPage)(_tabController.index),
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
              callPageChangedAtEnd: _callPageChangedAtEnd,
              onPageChanged: (i) {
                _tabController.index = i;
                printLog('i: $i, page: ${_pageController.page}');
              },
              pageMainAxisHintSize: !_largerHintSize
                  ? null
                  : _horizontal
                      ? MediaQuery.of(context).size.width + 5
                      : MediaQuery.of(context).size.height + 5 /* <<< */,
              itemCount: _pageCount,
              itemBuilder: (c, i) => _TestBlock(i: i),
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
                    const Text('callPageChangedAtEnd'),
                    Switch(value: _callPageChangedAtEnd, onChanged: (b) => mountedSetState(() => _callPageChangedAtEnd = b)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('largerHintSize'),
                    Switch(value: _largerHintSize, onChanged: (b) => mountedSetState(() => _largerHintSize = b)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('jumpToPage(off) / animateToPage(on)'),
                    Switch(value: _animateToPage, onChanged: (b) => mountedSetState(() => _animateToPage = b)),
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

class _TestTabBarViewPage extends StatefulWidget {
  const _TestTabBarViewPage({Key? key}) : super(key: key);

  @override
  State<_TestTabBarViewPage> createState() => _TestTabBarViewPageState();
}

class _TestTabBarViewPageState extends State<_TestTabBarViewPage> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 20, vsync: this);
  var _callPageChangedAtEnd = false;
  var _onPageMetricsChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageChangedListener Example'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            for (int i = 0; i < 20; i++) Tab(text: 'Tab $i'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageChangedListener(
              initialPage: 0,
              onPageChanged: (i) => printLog('i: $i, index: ${_tabController.index}'),
              onPageMetricsChanged: !_onPageMetricsChanged ? null : (m) => printLog(m),
              callPageChangedAtEnd: _callPageChangedAtEnd,
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (int i = 0; i < 20; i++) _TestBlock(i: i),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('callPageChangedAtEnd'),
                    Switch(value: _callPageChangedAtEnd, onChanged: (b) => mountedSetState(() => _callPageChangedAtEnd = b)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('onPageMetricsChanged'),
                    Switch(value: _onPageMetricsChanged, onChanged: (b) => mountedSetState(() => _onPageMetricsChanged = b)),
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

class _TestBlock extends StatefulWidget {
  const _TestBlock({
    Key? key,
    required this.i,
  }) : super(key: key);

  final int i;

  @override
  State<_TestBlock> createState() => _TestBlockState();
}

class _TestBlockState extends State<_TestBlock> with AutomaticKeepAliveClientMixin {
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
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 100, width: 50, color: Colors.blue),
              Container(height: 100, width: 50, color: Colors.green),
            ],
          ),
          Positioned.fill(
            child: Center(
              child: Text('Page ${widget.i}'),
            ),
          ),
        ],
      ),
    );
  }
}
