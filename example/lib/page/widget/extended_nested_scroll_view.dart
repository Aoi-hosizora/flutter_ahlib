import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ExtendedNestedScrollViewPage extends StatefulWidget {
  const ExtendedNestedScrollViewPage({Key? key}) : super(key: key);

  @override
  State<ExtendedNestedScrollViewPage> createState() => _ExtendedNestedScrollViewPageState();
}

class _ExtendedNestedScrollViewPageState extends State<ExtendedNestedScrollViewPage> with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late final _tabController = TabController(length: 3, vsync: this)
    ..addListener(() {
      if (mounted) setState(() {});
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExtendedNestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (c, __) => [
          SliverOverlapAbsorber(
            handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(c),
            sliver: SliverAppBar(
              title: const Text('ExtendedNestedScrollView Example'),
              pinned: true,
              expandedHeight: 200,
              forceElevated: true,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Page 0'),
                  Tab(text: 'Page 1'),
                  Tab(text: 'Page 2'),
                ],
              ),
            ),
          ),
        ],
        innerControllerCount: _tabController.length,
        activeControllerIndex: _tabController.index,
        bodyBuilder: (c, controllers) => TabBarView(
          controller: _tabController,
          children: [
            // ScrollController attached to multiple scroll views.
            // The provided ScrollController is currently attached to more than one ScrollPosition.
            // The provided ScrollController must be unique to a Scrollable widget.
            _TestPage(
              title: 'Page 0',
              color: Colors.pink,
              outerScrollController: _scrollController,
              innerScrollController: controllers[0],
            ),
            _TestPage(
              title: 'Page 1',
              color: Colors.teal,
              outerScrollController: _scrollController,
              innerScrollController: controllers[1],
            ),
            _TestPage(
              title: 'Page 2',
              color: Colors.lime,
              outerScrollController: _scrollController,
              innerScrollController: controllers[2],
            ),
          ],
        ),
      ),
    );
  }
}

class _TestPage extends StatefulWidget {
  const _TestPage({
    Key? key,
    required this.title,
    required this.color,
    required this.outerScrollController,
    required this.innerScrollController,
  }) : super(key: key);

  final String title;
  final Color color;
  final ScrollController outerScrollController;
  final ScrollController innerScrollController;

  @override
  State<_TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<_TestPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // <<<

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Scrollbar(
        isAlwaysShown: true, // The provided ScrollController must be unique to a Scrollable widget.
        interactive: true,
        controller: widget.innerScrollController, // The provided ScrollController is currently attached to more than one ScrollPosition.
        child: CustomScrollView(
          controller: widget.innerScrollController,
          slivers: [
            SliverOverlapInjector(
              handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: Card(
                child: Container(
                  color: widget.color,
                  height: 150,
                  child: Center(
                    child: Text(widget.title),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (c, i) => ListTile(
                    title: Center(
                      child: Text('${widget.title} - Item $i'),
                    ),
                    onTap: () {},
                  ),
                  childCount: 8,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 2.3,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (c, i) => ListTile(
                  title: Text('${widget.title} - Item $i'),
                  onTap: () {},
                ),
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScrollAnimatedFab(
        scrollController: widget.innerScrollController, // ScrollController attached to multiple scroll views.
        condition: ScrollAnimatedCondition.direction,
        fab: FloatingActionButton(
          child: const Icon(Icons.vertical_align_top),
          heroTag: null,
          onPressed: () => widget.outerScrollController.scrollToTop(),
        ),
      ),
    );
  }
}
