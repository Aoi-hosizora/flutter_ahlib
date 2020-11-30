import 'package:flutter/material.dart';

class ScrollFloatingActionButtonPage extends StatefulWidget {
  const ScrollFloatingActionButtonPage({Key key}) : super(key: key);

  @override
  _ScrollFloatingActionButtonPageState createState() => _ScrollFloatingActionButtonPageState();
}

class _ScrollFloatingActionButtonPageState extends State<ScrollFloatingActionButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScrollFloatingActionButton Example'),
      ),
      body: Center(
        child: Text('ScrollFloatingActionButtonPage'),
      ),
    );
  }
}
