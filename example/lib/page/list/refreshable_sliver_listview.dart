import 'package:flutter/material.dart';

class RefreshableSliverListViewPage extends StatefulWidget {
  @override
  _RefreshableSliverListViewPageState createState() => _RefreshableSliverListViewPageState();
}

class _RefreshableSliverListViewPageState extends State<RefreshableSliverListViewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('RefreshableSliverListView Example'),
      ),
      body: Center(
        child: Text('RefreshableSliverListView'),
      ),
    );
  }
}
