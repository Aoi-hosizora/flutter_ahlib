import 'package:flutter/material.dart';

class PaginationStaggeredGridViewPage extends StatefulWidget {
  @override
  _PaginationStaggeredGridViewPageState createState() => _PaginationStaggeredGridViewPageState();
}

class _PaginationStaggeredGridViewPageState extends State<PaginationStaggeredGridViewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginationStaggeredGrid Example'),
      ),
      body: Center(
        child: Text('PaginationStaggeredGrid'),
      ),
    );
  }
}
