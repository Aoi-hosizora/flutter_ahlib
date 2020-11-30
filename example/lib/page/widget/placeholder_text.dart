import 'package:flutter/material.dart';

class PlaceholderTextPage extends StatefulWidget {
  const PlaceholderTextPage({Key key}) : super(key: key);

  @override
  _PlaceholderTextPageState createState() => _PlaceholderTextPageState();
}

class _PlaceholderTextPageState extends State<PlaceholderTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlaceholderText Example'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Text(''),
          ),
          Flexible(
            flex: 1,
            child: Text(''),
          ),
        ],
      ),
    );
  }
}
