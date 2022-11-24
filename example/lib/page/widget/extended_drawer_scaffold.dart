import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ExtendedDrawerScaffoldPage extends StatefulWidget {
  const ExtendedDrawerScaffoldPage({Key? key}) : super(key: key);

  @override
  State<ExtendedDrawerScaffoldPage> createState() => _ExtendedDrawerScaffoldPageState();
}

class _ExtendedDrawerScaffoldPageState extends State<ExtendedDrawerScaffoldPage> with SingleTickerProviderStateMixin {
  final _length = 4;
  late final _tabController = TabController(length: _length, vsync: this);
  final _physicsController = CustomScrollPhysicsController();

  @override
  Widget build(BuildContext context) {
    return ExtendedDrawerScaffold(
      appBar: AppBar(
        title: const Text('ExtendedDrawerScaffold Example'),
      ),
      drawer: const Drawer(
        child: Center(
          child: Text('xxx'),
        ),
      ),
      drawerEdgeDragWidth: 20,
      physicsController: _physicsController,
      bodyBuilder: (_) => TabBarView(
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

/*
  final _length = 4;
  late final _tabController = TabController(length: _length, vsync: this);
  final _drawerKey = GlobalKey<CustomDrawerControllerState>();
  var _drawerOpening = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener(
          onNotification: (n) {
            if (n is OverscrollNotification && n.dragDetails != null) {
              if (n.dragDetails!.delta.dx > 0) {
                if (!_drawerOpening) {
                  _drawerOpening = true;
                  if (_tabController.length > 1) {
                    if (mounted) setState(() {});
                  }
                }
                _drawerKey.currentState?.move(n.dragDetails!);
              } else if (_drawerOpening && n.dragDetails!.delta.dx < 0) {
                _drawerKey.currentState?.move(n.dragDetails!);
              }
            }
            if (n is ScrollEndNotification && _drawerOpening) {
              _drawerOpening = false;
              if (_tabController.length > 1) {
                if (mounted) setState(() {});
              }
              _drawerKey.currentState?.settle(n.dragDetails ?? DragEndDetails());
            }
            if (n is OverscrollIndicatorNotification && _drawerOpening) {
              n.disallowIndicator();
            }
            return false;
          },
          child: Scaffold(
            drawerEdgeDragWidth: 50,
            drawer: const Drawer(
              child: Center(
                child: Text('yyy'),
              ),
            ),
            appBar: AppBar(
              title: const Text('TestPage'),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: !_drawerOpening ? const AlwaysScrollableScrollPhysics() : const AlwaysOverscrollPhysics(),
              children: [
                for (var i = 0; i < _length; i++)
                  Row(
                    children: [
                      Container(width: 20, color: Colors.purple),
                      Container(width: 50 - 20, color: Colors.grey),
                      Expanded(
                        child: Container(
                          color: [Colors.red, Colors.yellow, Colors.blue, Colors.green][i % 4],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        CustomDrawerController(
          key: _drawerKey,
          edgeDragWidth: 20,
          alignment: DrawerAlignment.start,
          child: const Drawer(
            child: Center(
              child: Text('xxx'),
            ),
          ),
        ),
      ],
    );
  }
   */
}
