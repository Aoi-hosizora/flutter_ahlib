import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class NestedPageViewNotifierPage extends StatefulWidget {
  const NestedPageViewNotifierPage({Key? key}) : super(key: key);

  @override
  _NestedPageViewNotifierPageState createState() => _NestedPageViewNotifierPageState();
}

class _NestedPageViewNotifierPageState extends State<NestedPageViewNotifierPage> with SingleTickerProviderStateMixin {
  late final _controller = TabController(length: 4, vsync: this);
  PageController? _pageController; // for testing NestedPageViewNotifier
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _pageController = context.visitDescendantElementsBFS<PageController>(
        (el) => (el.widget is! PageView) ? null : (el.widget as PageView).controller,
      )!; // <<< use visitDescendantElementsBFS
    });
    _controller.addListener(() {
      _currentIndex = _controller.index.toInt();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NestedPageViewNotifier Example'),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.yellow,
            child: const Center(child: Text('Page A (in TabBarView)')),
          ),
          _PageB(parentController: _pageController),
          const _PageC(),
          Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.purple,
            child: const Center(child: Text('Page D (in TabBarView)')),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: ['A', 'B', 'C', 'D']
            .map(
              (t) => BottomNavigationBarItem(
                icon: const Icon(Icons.chevron_right),
                label: t,
              ),
            )
            .toList(),
        onTap: (index) {
          _controller.animateTo(index);
          _currentIndex = index;
          if (mounted) setState(() {});
        },
      ),
    );
  }
}

class _PageB extends StatefulWidget {
  const _PageB({
    Key? key,
    required this.parentController,
  }) : super(key: key);
  final PageController? parentController;

  @override
  _PageBState createState() => _PageBState();
}

class _PageBState extends State<_PageB> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            tabs: const [
              Tab(text: 'B1'),
              Tab(text: 'B2'),
            ],
          ),
          Expanded(
            child: NestedPageViewNotifier(
              parentController: widget.parentController,
              child: TabBarView(
                children: [
                  Container(
                    constraints: const BoxConstraints.expand(),
                    color: Colors.green,
                    child: const Center(child: Text('Page B1 (in TabBarView->TabBarView)')), // <<< T->T
                  ),
                  Container(
                    constraints: const BoxConstraints.expand(),
                    color: Colors.grey,
                    child: const Center(child: Text('Page B2 (in TabBarView->TabBarView)')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageC extends StatefulWidget {
  const _PageC({Key? key}) : super(key: key);

  @override
  State<_PageC> createState() => _PageCState();
}

class _PageCState extends State<_PageC> with AutomaticKeepAliveClientMixin {
  late final PageController? _parentController = // for testing NestedPageViewNotifier
      context.findAncestorWidgetOfExactType<PageView>()?.controller; // <<< use findAncestorWidgetOfExactType

  final _controller = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedPageViewNotifier(
      parentController: _parentController,
      child: PageView(
        controller: _controller,
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.teal,
            child: const Center(child: Text('Page C1 (in TabBarView->PageView)')), // <<< T->P
          ),
          Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.deepOrange,
            child: const Center(child: Text('Page C2 (in TabBarView->PageView)')),
          ),
          DefaultTabController(
            length: 2,
            child: NestedPageViewNotifier(
              parentController: _controller,
              child: TabBarView(
                key: const PageStorageKey('C3'),
                children: [
                  Container(
                    constraints: const BoxConstraints.expand(),
                    color: Colors.amber,
                    child: const Center(child: Text('Page C3.1 (in TabBarView->PageView->TabBarView)')), // <<< P->T
                  ),
                  Container(
                    constraints: const BoxConstraints.expand(),
                    color: Colors.blueGrey,
                    child: const Center(child: Text('Page C3.2 (in TabBarView->PageView->TabBarView)')),
                  ),
                ],
              ),
            ),
          ),
          NestedPageViewNotifier(
            parentController: _controller,
            child: PageView(
              key: const PageStorageKey('C4'),
              children: [
                Container(
                  constraints: const BoxConstraints.expand(),
                  color: Colors.deepPurple,
                  child: const Center(child: Text('Page C4.1 (in TabBarView->PageView->PageView)')), // <<< P->T
                ),
                Container(
                  constraints: const BoxConstraints.expand(),
                  color: Colors.red,
                  child: const Center(child: Text('Page C4.2 (in TabBarView->PageView->PageView)')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
