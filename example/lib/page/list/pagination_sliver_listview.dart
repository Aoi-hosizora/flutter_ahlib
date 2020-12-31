import 'package:flutter/material.dart';

class PaginationSliverListViewPage extends StatefulWidget {
  @override
  _PaginationSliverListViewPageState createState() => _PaginationSliverListViewPageState();
}

class _PaginationSliverListViewPageState extends State<PaginationSliverListViewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginationSliverListView Example'),
      ),
      body: Center(
        child: Text('PaginationSliverListView'),
      ),
    );
  }
}
