import 'package:flutter/material.dart';

class RefreshableListViewPage extends StatefulWidget {
  @override
  _RefreshableListViewPageState createState() => _RefreshableListViewPageState();
}

class _RefreshableListViewPageState extends State<RefreshableListViewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('RefreshableListView Example'),
      ),
      body: Center(
        child: Text('RefreshableListView'),
      ),
    );
  }
}
