import 'package:flutter/material.dart';

class PaginationListViewPage extends StatefulWidget {
  @override
  _PaginationListViewPageState createState() => _PaginationListViewPageState();
}

class _PaginationListViewPageState extends State<PaginationListViewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginationListView Example'),
      ),
      body: Center(
        child: Text('PaginationListView'),
      ),
    );
  }
}
