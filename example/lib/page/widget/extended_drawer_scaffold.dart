import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class ExtendedDrawerScaffoldPage extends StatefulWidget {
  const ExtendedDrawerScaffoldPage({Key? key}) : super(key: key);

  @override
  State<ExtendedDrawerScaffoldPage> createState() => _ExtendedDrawerScaffoldPageState();
}

class _ExtendedDrawerScaffoldPageState extends State<ExtendedDrawerScaffoldPage> with TickerProviderStateMixin {
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
    return ExtendedDrawerScaffold(
      appBar: AppBar(
        title: const Text('ExtendedDrawerScaffold Example'),
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
              SwitchListTile(
                title: const Text('only single page'),
                value: _length == 1,
                onChanged: (v) {
                  _length = v ? 1 : 4;
                  _tabController = TabController(length: _length, vsync: this);
                  if (mounted) setState(() {});
                },
              ),
              SwitchListTile(
                title: const Text('hasDrawer'),
                value: _hasDrawer,
                onChanged: (v) => mountedSetState(() => _hasDrawer = v),
              ),
              SwitchListTile(
                title: const Text('hasEndDrawer'),
                value: _hasEndDrawer,
                onChanged: (v) => mountedSetState(() => _hasEndDrawer = v),
              ),
              SwitchListTile(
                title: const Text('neverScrollable'),
                value: _neverScrollable,
                onChanged: (v) => mountedSetState(() => _neverScrollable = v),
              ),
              SwitchListTile(
                title: const Text('hasPhysicsController'),
                value: _hasPhysicsController,
                onChanged: (v) => mountedSetState(() => _hasPhysicsController = v),
              ),
              SwitchListTile(
                title: const Text('useAppBarActionButton'),
                value: _useAppBarActionButton,
                onChanged: (v) => mountedSetState(() => _useAppBarActionButton = v),
              ),
            ],
          ),
          Builder(
            builder: (c) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text('drawer'),
                  onPressed: () => ExtendedDrawerScaffold.of(c)?.openDrawer(),
                ),
                ElevatedButton(
                  child: const Text('end drawer'),
                  onPressed: () => ExtendedDrawerScaffold.of(c)?.openEndDrawer(),
                ),
                ElevatedButton(
                  child: const Text('drawer 2'),
                  onPressed: () => ExtendedDrawerScaffold.of(c)?.scaffoldState?.openDrawer(),
                ),
                ElevatedButton(
                  child: const Text('end drawer 2'),
                  onPressed: () => ExtendedDrawerScaffold.of(c)?.scaffoldState?.openEndDrawer(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
