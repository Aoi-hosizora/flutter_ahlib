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
      // DrawerPageItem.simple('DrawerListViewPage', Icons.home, DrawerListViewPage(), DrawerSelection.indexPage),
      // DrawerWidgetItem.simple(Divider(thickness: 1)),
      // DrawerPageItem.simple('_PageA', Icons.favorite, _PageA(), DrawerSelection.pageA),
      // DrawerPageItem.simple('_PageB', Icons.history, _PageB(), DrawerSelection.pageB),
      // DrawerPageItem.simple('_PageC', Icons.file_download, _PageC(), DrawerSelection.pageC),
      // DrawerWidgetItem.simple(Divider(thickness: 1)),
      // DrawerActionItem.simple('ActionA', Icons.cached, () => print('ActionA')),
      // DrawerActionItem.simple('ActionB', Icons.feedback, () => print('ActionB')),
      // DrawerActionItem.simple('ActionC', Icons.info, () => print('ActionC')),
      DrawerPageItem(
        title: Text('DrawerListViewPage'),
        leading: Icon(Icons.home),
        trailing: Icon(Icons.check),
        page: DrawerListViewPage(),
        selection: DrawerSelection.indexPage,
      ),
      DrawerWidgetItem.simple(Divider(thickness: 1)),
      DrawerPageItem(
        title: Text('_PageA'),
        leading: Icon(Icons.favorite),
        page: _PageA(),
        selection: DrawerSelection.pageA,
        autoCloseWhenTapped: true,
        autoCloseWhenAlreadySelected: false,
      ),
      DrawerPageItem(
        title: Text('_PageB'),
        leading: Icon(Icons.history),
        page: _PageB(),
        selection: DrawerSelection.pageB,
        autoCloseWhenTapped: false,
        autoCloseWhenAlreadySelected: true,
      ),
      DrawerPageItem(
        title: Text('_PageC'),
        leading: Icon(Icons.file_download),
        page: _PageC(),
        selection: DrawerSelection.pageC,
      ),
      DrawerWidgetItem.simple(Divider(thickness: 1)),
      DrawerActionItem(
        title: Text('ActionA'),
        leading: Icon(Icons.cached),
        action: () => print('ActionA'),
        longPressAction: () => print('ActionA2'),
        autoCloseWhenTapped: true,
        autoCloseWhenLongPressed: false,
      ),
      DrawerActionItem(
        title: Text('ActionB'),
        leading: Icon(Icons.feedback),
        action: () => print('ActionB'),
      ),
      DrawerActionItem(
        title: Text('ActionC'),
        leading: Icon(Icons.info),
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
