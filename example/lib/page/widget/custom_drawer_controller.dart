import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class CustomDrawerControllerPage extends StatefulWidget {
  const CustomDrawerControllerPage({Key? key}) : super(key: key);

  @override
  State<CustomDrawerControllerPage> createState() => _CustomDrawerControllerPageState();
}

class _CustomDrawerControllerPageState extends State<CustomDrawerControllerPage> {
  final _drawerKey = GlobalKey<CustomDrawerControllerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomDrawerController Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              if (_drawerKey.currentState?.controller.value != 1.0) {
                // not completely opened => open
                _drawerKey.currentState?.open();
              } else {
                _drawerKey.currentState?.close();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.horizontal_distribute),
            onPressed: () => _drawerKey.currentState?.controller.value = 0.5,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 50,
            right: 50,
            bottom: 50,
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n is OverscrollNotification && n.dragDetails != null) {
                  _drawerKey.currentState?.move(n.dragDetails!);
                } else if (n is ScrollEndNotification && n.dragDetails != null) {
                  _drawerKey.currentState?.settle(n.dragDetails!);
                }
                return false;
              },
              child: PageView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    color: Colors.yellow,
                    child: const Center(
                      child: Text('Drag here to open drawer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomDrawerController(
            key: _drawerKey,
            alignment: DrawerAlignment.start,
            child: Drawer(
              child: ListView(
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: SizedBox.shrink(),
                  ),
                  ListTile(
                    title: const Text('Close by close'),
                    onTap: () => _drawerKey.currentState?.close(),
                  ),
                  ListTile(
                    title: const Text('Close by pop'),
                    onTap: () => Navigator.of(context).pop(),
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
