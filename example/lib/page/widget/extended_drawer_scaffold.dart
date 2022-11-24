import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ExtendedDrawerScaffoldPage extends StatefulWidget {
  const ExtendedDrawerScaffoldPage({Key? key}) : super(key: key);

  @override
  State<ExtendedDrawerScaffoldPage> createState() => _ExtendedDrawerScaffoldPageState();
}

class _ExtendedDrawerScaffoldPageState extends State<ExtendedDrawerScaffoldPage> with TickerProviderStateMixin {
  var _length = 4;
  late var _tabController = TabController(length: _length, vsync: this);
  final _physicsController = CustomScrollPhysicsController();

  @override
  Widget build(BuildContext context) {
    return ExtendedDrawerScaffold(
      appBar: AppBar(
        title: const Text('ExtendedDrawerScaffold Example'),
        actions: [
          IconButton(
            icon: const Text('1'),
            onPressed: () {
              _length = 1;
              _tabController = TabController(length: _length, vsync: this);
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: const Text('4'),
            onPressed: () {
              _length = 4;
              _tabController = TabController(length: _length, vsync: this);
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      drawer: const Drawer(
        child: Center(
          child: Text('Test drawer'),
        ),
      ),
      drawerEdgeDragWidth: 20,
      physicsController: _physicsController,
      body: TabBarView(
        controller: _tabController,
        physics: CustomScrollPhysics(
          controller: _physicsController,
        ),
        children: [
          for (var i = 0; i < _length; i++)
            Row(
              children: [
                Container(
                  width: 20, // drawerEdgeDragWidth
                  color: Colors.grey,
                ),
                Expanded(
                  child: Container(
                    color: [Colors.red, Colors.yellow, Colors.blue, Colors.green][i % 4],
                    child: Center(
                      child: Text('Page ${i + 1}'),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
