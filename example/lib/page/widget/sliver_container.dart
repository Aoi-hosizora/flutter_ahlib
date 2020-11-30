import 'package:flutter/material.dart';

class SliverContainerPage extends StatefulWidget {
  const SliverContainerPage({Key key}) : super(key: key);

  @override
  _SliverContainerPageState createState() => _SliverContainerPageState();
}

class _SliverContainerPageState extends State<SliverContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverContainer Example'),
      ),
      body: Center(
        child: Text('SliverContainerPage'),
      ),
    );
  }
}
