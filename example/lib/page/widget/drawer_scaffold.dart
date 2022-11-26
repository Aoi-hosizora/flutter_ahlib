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
  var _applyPhysicsController = true;
  var _enableOverscrollGesture = true;
  var _enableOpenDragGesture = true;
  var _useAppBarActionButton = false;

  final _anotherTriggerKey = GlobalKey<State<StatefulWidget>>();
  late var _tabController = TabController(length: _length, vsync: this);
  final _physicsController = CustomScrollPhysicsController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double? get anotherTriggerTopDistance => //
      _anotherTriggerKey.currentContext!.findRenderObject()?.getBoundInAncestorCoordinate(context.findRenderObject()).top;

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
      drawerEnableOverscrollGesture: _enableOverscrollGesture,
      endDrawerEnableOverscrollGesture: _enableOverscrollGesture,
      physicsController: _physicsController,
      drawerEnableOpenDragGesture: _enableOpenDragGesture,
      endDrawerEnableOpenDragGesture: _enableOpenDragGesture,
      drawerEdgeDragWidth: 40,
      endDrawerEdgeDragWidth: 20,
      drawerExtraDragTriggers: [
        DrawerDragTrigger(
          left: 0,
          top: 0,
          height: MediaQuery.of(context).padding.top + kToolbarHeight,
          dragWidth: MediaQuery.of(context).size.width,
          forBothSide: true, // <<<
        ),
        if (_anotherTriggerKey.currentContext != null) ...[
          DrawerDragTrigger(
            left: 0,
            top: anotherTriggerTopDistance ?? 0,
            height: 60,
            dragWidth: MediaQuery.of(context).size.width * 1 / 2 /* drawer => 1/2 (+ 1/4) */,
          ),
          DrawerDragTrigger(
            left: MediaQuery.of(context).size.width * 1 / 2,
            top: anotherTriggerTopDistance ?? 0,
            height: 60,
            dragWidth: MediaQuery.of(context).size.width * 1 / 4 /* drawer => (1/2 +) 1/4 */,
            forBothSide: true, // <<<
          ),
        ],
      ],
      endDrawerExtraDragTriggers: [
        // DrawerDragTrigger( // no need
        //   right: 0,
        //   top: 0,
        //   height: kToolbarHeight,
        //   dragWidth: MediaQuery.of(context).size.width,
        //   forBothSide: true, // <<<
        // ),
        if (_anotherTriggerKey.currentContext != null) ...[
          // DrawerDragTrigger( // no need
          //   right: MediaQuery.of(context).size.width * 1 / 4,
          //   top: anotherTriggerTopDistance ?? 0,
          //   height: 60,
          //   dragWidth: MediaQuery.of(context).size.width * 1 / 4 /* drawer => 1/4 (+ 1/4) */,
          //   forBothSide: true, // <<<
          // ),
          DrawerDragTrigger(
            right: 0,
            top: anotherTriggerTopDistance ?? 0,
            height: 60,
            dragWidth: MediaQuery.of(context).size.width * 1 / 4 /* endDrawer => (1/4 +) 1/4 */,
          ),
        ],
      ],
      onDrawerChanged: (v) => printLog('onDrawerChanged $v'),
      onEndDrawerChanged: (v) => printLog('onEndDrawerChanged $v'),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: _applyPhysicsController ? CustomScrollPhysics(controller: _physicsController) : null,
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
          Row(
            key: _anotherTriggerKey,
            children: [
              // drawer only => 1/2
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 1 / 2,
                color: Colors.blue.withOpacity(0.5),
                child: const Center(
                  child: Text('Drawer only\n1/2 (+ 1/4)', textAlign: TextAlign.center),
                ),
              ),
              // both => remained
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * (1 - 1 / 2 - 1 / 4),
                color: Colors.purple.withOpacity(0.5),
                child: const Center(
                  child: Text('Both\n1/4', textAlign: TextAlign.center),
                ),
              ),
              // endDrawer => 1/4
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width / 4,
                color: Colors.red.withOpacity(0.5),
                child: const Center(
                  child: Text('EndDrawer only\n(1/4 +) 1/4', textAlign: TextAlign.center),
                ),
              ),
            ],
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
                  const Text('applyPhysicsController'),
                  Switch(value: _applyPhysicsController, onChanged: (b) => mountedSetState(() => _applyPhysicsController = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('enableOverscrollGesture'),
                  Switch(value: _enableOverscrollGesture, onChanged: (b) => mountedSetState(() => _enableOverscrollGesture = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('enableOpenDragGesture'),
                  Switch(value: _enableOpenDragGesture, onChanged: (b) => mountedSetState(() => _enableOpenDragGesture = b)),
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
