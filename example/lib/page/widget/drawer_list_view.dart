import 'package:flutter/material.dart';

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
      body: Center(
        child: Text('DrawerListViewPage'),
      ),
    );
  }
}
