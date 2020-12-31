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
      DrawerPageItem.simple('DrawerListViewPage', Icons.home, DrawerListViewPage(), DrawerSelection.indexPage),
      DrawerPageItem.simple('_PageA', Icons.favorite, _PageA(), DrawerSelection.pageA),
      DrawerPageItem.simple('_PageB', Icons.history, _PageB(), DrawerSelection.pageB),
      DrawerPageItem.simple('_PageC', Icons.file_download, _PageC(), DrawerSelection.pageC),
      DrawerWidgetItem.simple(Divider(thickness: 1, height: 1)),
      DrawerActionItem.simple('ActionA', Icons.cached, () => print('ActionA')),
      DrawerActionItem.simple('ActionB', Icons.feedback, () => print('ActionB')),
      DrawerActionItem.simple('ActionC', Icons.info, () => print('ActionC')),
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
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'XXX - YYY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                ),
              ),
            ),
          ),
          DrawerListView<DrawerSelection>(
            items: _items,
            currentSelection: widget.currentDrawerSelection,
            onGoto: (t, v) {
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
