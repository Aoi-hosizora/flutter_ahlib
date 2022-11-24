import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class DrawerScaffoldPage extends StatefulWidget {
  const DrawerScaffoldPage({Key? key}) : super(key: key);

  @override
  State<DrawerScaffoldPage> createState() => _DrawerScaffoldPageState();
}

class _DrawerScaffoldPageState extends State<DrawerScaffoldPage> with TickerProviderStateMixin {
  var _length = 4;
  var _hasDrawer = true;
  var _hasEndDrawer = true;
  var _hasPhysicsController = true;
  var _neverScrollable = false;
  var _useAppBarActionButton = false;

  late var _tabController = TabController(length: _length, vsync: this);
  final _physicsController = CustomScrollPhysicsController();

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      appBar: AppBar(
        title: const Text('DrawerScaffold Example'),
        leading: _useAppBarActionButton
            ? AppBarActionButton.leading(
                context: context,
                forceUseBuilder: true,
                splashRadius: 20,
              )
            : null,
      ),
      drawer: _hasDrawer
          ? const Drawer(
              child: Center(
                child: Text('Test drawer'),
              ),
            )
          : null,
      endDrawer: _hasEndDrawer
          ? const Drawer(
              child: Center(
                child: Text('Test end drawer'),
              ),
            )
          : null,
      physicsController: _physicsController,
      onDrawerChanged: (v) => printLog('onDrawerChanged $v'),
      onEndDrawerChanged: (v) => printLog('onEndDrawerChanged $v'),
      drawerEdgeDragWidth: 40,
      endDrawerEdgeDragWidth: 20,
      drawerEnableOpenDragGesture: true,
      endDrawerEnableOpenDragGesture: true,
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: _neverScrollable
                  ? const NeverScrollableScrollPhysics()
                  : _hasPhysicsController
                      ? CustomScrollPhysics(
                          controller: _physicsController,
                        )
                      : null,
              children: [
                for (var i = 0; i < _length; i++)
                  Row(
                    children: [
                      Container(
                        width: 40, // drawerEdgeDragWidth
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Container(
                          color: [Colors.red, Colors.yellow, Colors.blue, Colors.green][i % 4],
                          child: Center(
                            child: Text(_length == 1 ? 'The only page' : 'Page ${i + 1}'),
                          ),
                        ),
                      ),
                      Container(
                        width: 20, // drawerEdgeDragWidth
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('only single page'),
                  Switch(
                    value: _length == 1,
                    onChanged: (b) {
                      _length = b ? 1 : 4;
                      _tabController = TabController(length: _length, vsync: this);
                      if (mounted) setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('hasDrawer'),
                  Switch(value: _hasDrawer, onChanged: (b) => mountedSetState(() => _hasDrawer = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('hasEndDrawer'),
                  Switch(value: _hasEndDrawer, onChanged: (b) => mountedSetState(() => _hasEndDrawer = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('neverScrollable'),
                  Switch(value: _neverScrollable, onChanged: (b) => mountedSetState(() => _neverScrollable = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('hasPhysicsController'),
                  Switch(value: _hasPhysicsController, onChanged: (b) => mountedSetState(() => _hasPhysicsController = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('useAppBarActionButton'),
                  Switch(value: _useAppBarActionButton, onChanged: (b) => mountedSetState(() => _useAppBarActionButton = b)),
                ],
              ),
            ],
          ),
          Builder(
            builder: (c) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text('drawer'),
                  onPressed: () => DrawerScaffold.of(c)?.openDrawer(),
                ),
                ElevatedButton(
                  child: const Text('end drawer'),
                  onPressed: () => DrawerScaffold.of(c)?.openEndDrawer(),
                ),
                ElevatedButton(
                  child: const Text('drawer 2'),
                  onPressed: () => DrawerScaffold.of(c)?.scaffoldState?.openDrawer(),
                ),
                ElevatedButton(
                  child: const Text('end drawer 2'),
                  onPressed: () => DrawerScaffold.of(c)?.scaffoldState?.openEndDrawer(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
