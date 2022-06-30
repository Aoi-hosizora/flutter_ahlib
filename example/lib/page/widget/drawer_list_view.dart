import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class DrawerListViewPage extends StatefulWidget {
  const DrawerListViewPage({Key? key}) : super(key: key);

  @override
  _DrawerListViewPageState createState() => _DrawerListViewPageState();
}

class _DrawerListViewPageState extends State<DrawerListViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DrawerListView Example'),
      ),
      drawer: const MyDrawer(
        currentDrawerSelection: DrawerSelection.indexPage,
      ),
    );
  }
}

enum DrawerSelection {
  indexPage,
  pageA,
  pageB,
  pageC,
}

class _PageA extends StatefulWidget {
  @override
  __PageAState createState() => __PageAState();
}

class __PageAState extends State<_PageA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('_PageA'),
      ),
      drawer: const MyDrawer(
        currentDrawerSelection: DrawerSelection.pageA,
      ),
    );
  }
}

class _PageB extends StatefulWidget {
  @override
  __PageBState createState() => __PageBState();
}

class __PageBState extends State<_PageB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('_PageB'),
      ),
      drawer: const MyDrawer(
        currentDrawerSelection: DrawerSelection.pageB,
      ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('_PageC'),
      ),
      drawer: const MyDrawer(
        currentDrawerSelection: DrawerSelection.pageC,
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
    required this.currentDrawerSelection,
  }) : super(key: key);
  final DrawerSelection currentDrawerSelection;

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var _items = <DrawerItem>[];

  @override
  void initState() {
    super.initState();
    _items = [
      const DrawerPageItem(
        title: Text('DrawerListViewPage'),
        leading: Icon(Icons.home),
        trailing: Icon(Icons.check),
        page: DrawerListViewPage(),
        selection: DrawerSelection.indexPage,
      ),
      DrawerWidgetItem.simple(
        const Divider(thickness: 1),
      ),
      DrawerPageItem(
        title: const Text('_PageA'),
        leading: const Icon(Icons.favorite),
        page: _PageA(),
        selection: DrawerSelection.pageA,
        autoCloseWhenTapped: true,
        autoCloseWhenAlreadySelected: false,
      ),
      DrawerPageItem(
        title: const Text('_PageB'),
        leading: const Icon(Icons.history),
        page: _PageB(),
        selection: DrawerSelection.pageB,
        autoCloseWhenTapped: false,
        autoCloseWhenAlreadySelected: true,
      ),
      DrawerPageItem(
        title: const Text('_PageC'),
        leading: const Icon(Icons.file_download),
        page: _PageC(),
        selection: DrawerSelection.pageC,
      ),
      DrawerWidgetItem.simple(
        const Divider(thickness: 1),
      ),
      DrawerActionItem(
        title: const Text('ActionA'),
        leading: const Icon(Icons.cached),
        action: () => print('ActionA'),
        longPressAction: () => print('ActionA2'),
        autoCloseWhenTapped: true,
        autoCloseWhenLongPressed: false,
      ),
      DrawerActionItem(
        title: const Text('ActionB'),
        leading: const Icon(Icons.feedback),
        action: () => print('ActionB'),
      ),
      DrawerActionItem(
        title: const Text('ActionC'),
        leading: const Icon(Icons.info),
        action: () => print('ActionC'),
        longPressAction: () => print('ActionC2'),
        autoCloseWhenTapped: false,
        autoCloseWhenLongPressed: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'XXX - YYY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.subtitle2!.fontSize,
                ),
              ),
            ),
          ),
          DrawerListView<DrawerSelection>(
            items: _items,
            currentSelection: widget.currentDrawerSelection,
            onNavigatorTo: (t, v) {
              if (t == DrawerSelection.indexPage) {
                Navigator.of(context).popUntil((route) => route.settings.name == '.');
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (c) => v));
              }
            },
          ),
        ],
      ),
    );
  }
}
