import 'package:flutter/material.dart';

class RefreshableStaggeredGridViewPage extends StatefulWidget {
  @override
  _RefreshableStaggeredGridViewPageState createState() => _RefreshableStaggeredGridViewPageState();
}

class _RefreshableStaggeredGridViewPageState extends State<RefreshableStaggeredGridViewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('RefreshableStaggeredGridView Example'),
      ),
      body: Center(
        child: Text('RefreshableStaggeredGridView'),
      ),
    );
  }
}
