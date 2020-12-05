import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class DrawerListViewPage extends StatefulWidget {
  const DrawerListViewPage({Key key}) : super(key: key);

  @override
  _DrawerListViewPageState createState() => _DrawerListViewPageState();
}

class _DrawerListViewPageState extends State<DrawerListViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DrawerListView Example'),
      ),
      drawer: MyDrawer(
        currentDrawerSelection: DrawerSelection.indexPage,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('_PageA'),
      ),
      drawer: MyDrawer(
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
        title: Text('_PageB'),
      ),
      drawer: MyDrawer(
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
        title: Text('_PageC'),
      ),
      drawer: MyDrawer(
        currentDrawerSelection: DrawerSelection.pageC,
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

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key key,
    @required this.currentDrawerSelection,
  })  : assert(currentDrawerSelection != null),
        super(key: key);
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
      DrawerPage(title: 'DrawerListViewPage', icon: Icons.home, view: DrawerListViewPage(), selection: DrawerSelection.indexPage),
      DrawerPage(title: '_PageA', icon: Icons.favorite, view: _PageA(), selection: DrawerSelection.pageA),
      DrawerPage(title: '_PageB', icon: Icons.history, view: _PageB(), selection: DrawerSelection.pageB),
      DrawerPage(title: '_PageC', icon: Icons.file_download, view: _PageC(), selection: DrawerSelection.pageC),
      DrawerDivider(divider: Divider(thickness: 1, height: 1)),
      DrawerAction(title: 'ActionA', icon: Icons.cached, action: () => print('ActionA')),
      DrawerAction(title: 'ActionB', icon: Icons.feedback, action: () => print('ActionB')),
      DrawerAction(title: 'ActionC', icon: Icons.info, action: () => print('ActionC')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Text(
                    'XXX - YYY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DrawerListView<DrawerSelection>(
            items: _items,
            highlightColor: Colors.grey[200],
            currentDrawerSelection: widget.currentDrawerSelection,
            rootSelection: DrawerSelection.indexPage,
          ),
        ],
      ),
    );
  }
}
