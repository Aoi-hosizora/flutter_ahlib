import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class FlutterExtensionPage extends StatefulWidget {
  const FlutterExtensionPage({Key? key}) : super(key: key);

  @override
  State<FlutterExtensionPage> createState() => _FlutterExtensionPageState();
}

class _FlutterExtensionPageState extends State<FlutterExtensionPage> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(vsync: this, length: 3);

  Widget _fab({required IconData icon, required VoidCallback onPressed}) {
    return FloatingActionButton(
      child: Icon(icon),
      heroTag: null,
      mini: true,
      onPressed: onPressed,
    );
  }

  final _scrollController = ScrollController();
  var _lessItems = false;

  Widget _page1() {
    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        interactive: true,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _lessItems ? 5 : 50,
          itemBuilder: (_, i) => ListTile(
            title: Text('$i'),
            onTap: () {},
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _fab(
            icon: _lessItems ? Icons.add : Icons.remove,
            onPressed: () => mountedSetState(() => _lessItems = !_lessItems),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.vertical_align_top,
            onPressed: () => _scrollController.scrollToTop(),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.vertical_align_bottom,
            onPressed: () => _scrollController.scrollToBottom(),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.keyboard_arrow_up,
            onPressed: () => _scrollController.scrollUp(),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.keyboard_arrow_down,
            onPressed: () => _scrollController.scrollDown(),
          ),
        ],
      ),
    );
  }

  Widget _page2() {
    return const Center(
      child: Text('2'),
    );
  }

  Widget _page3() {
    return const Center(
      child: Text('3'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterExtension Example'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Scrollable related'),
            Tab(text: 'PageView related'),
            Tab(text: 'RenderObject related'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _page1(),
          _page2(),
          _page3(),
        ],
      ),
    );
  }
}
