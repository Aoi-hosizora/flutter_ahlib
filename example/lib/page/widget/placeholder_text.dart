import 'package:flutter/material.dart';

class PlaceholderTextPage extends StatefulWidget {
  const PlaceholderTextPage({Key key}) : super(key: key);

  @override
  _PlaceholderTextPageState createState() => _PlaceholderTextPageState();
}

class _PlaceholderTextPageState extends State<PlaceholderTextPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('PlaceholderText Example'),
      ),
      body: Center(
        child: Text('TODO'),
      ),
    );
  }
}
