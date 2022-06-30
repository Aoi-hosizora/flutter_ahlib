import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class TabInPageNotificationPage extends StatefulWidget {
  const TabInPageNotificationPage({Key? key}) : super(key: key);

  @override
  _TabInPageNotificationPageState createState() => _TabInPageNotificationPageState();
}

class _TabInPageNotificationPageState extends State<TabInPageNotificationPage> {
  var _currentIndex = 0;
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _currentIndex = _controller.page!.toInt();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabInPageNotification Example'),
      ),
      body: PageView(
        controller: _controller,
        children: [
          _PageA(),
          _PageB(pageController: _controller),
          _PageC(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: ['A', 'B', 'C']
            .map(
              (t) =>
              BottomNavigationBarItem(
                icon: const Icon(Icons.chevron_right),
                label: t,
              ),
        )
            .toList(),
        onTap: (index) {
          _currentIndex = index;
          _controller.defaultAnimateToPage(index);
          if (mounted) setState(() {});
        },
      ),
    );
  }
}

class _PageA extends StatefulWidget {
  @override
  __PageAState createState() => __PageAState();
}

class __PageAState extends State<_PageA> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('A'));
  }
}

class _PageB extends StatefulWidget {
  const _PageB({required this.pageController});

  final PageController pageController;

  @override
  __PageBState createState() => __PageBState();
}

class __PageBState extends State<_PageB> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _controller,
          unselectedLabelColor: Theme
              .of(context)
              .textTheme
              .bodyText1!
              .color,
          labelColor: Theme
              .of(context)
              .primaryColor,
          indicatorColor: Colors.transparent,
          isScrollable: true,
          tabs: const [
            Text('B1', style: TextStyle(height: 2)),
            Text('B2', style: TextStyle(height: 2)),
          ],
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: TabInPageNotification(
            pageController: widget.pageController, // <<<
            child: TabBarView(
              controller: _controller,
              children: const [
                Center(child: Text('B1')),
                Center(child: Text('B2')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PageC extends StatefulWidget {
  @override
  __PageCState createState() => __PageCState();
}

class __PageCState extends State<_PageC> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('C'));
  }
}
