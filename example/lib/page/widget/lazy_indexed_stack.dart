import 'package:flutter/material.dart';

class LazyIndexedStackPage extends StatefulWidget {
  const LazyIndexedStackPage({Key key}) : super(key: key);

  @override
  _LazyIndexedStackPageState createState() => _LazyIndexedStackPageState();
}

class _LazyIndexedStackPageState extends State<LazyIndexedStackPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('LazyIndexedStack Example'),
      ),
      body: Center(
        child: Text('TODO'),
      ),
    );
  }
}
