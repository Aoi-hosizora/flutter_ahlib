import 'package:flutter/material.dart';

class IconTextPage extends StatefulWidget {
  const IconTextPage({Key key}) : super(key: key);

  @override
  _IconTextPageState createState() => _IconTextPageState();
}

class _IconTextPageState extends State<IconTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IconText Example'),
      ),
      body: Center(
        child: Text('IconTextPage'),
      ),
    );
  }
}
