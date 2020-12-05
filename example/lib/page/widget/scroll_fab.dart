import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ScrollFloatingActionButtonPage extends StatefulWidget {
  const ScrollFloatingActionButtonPage({Key key}) : super(key: key);

  @override
  _ScrollFloatingActionButtonPageState createState() => _ScrollFloatingActionButtonPageState();
}

class _ScrollFloatingActionButtonPageState extends State<ScrollFloatingActionButtonPage> {
  var _controller = ScrollMoreController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScrollFloatingActionButton Example'),
      ),
      body: ListView(
        controller: _controller,
        children: List.generate(
          30,
          (num) => ListTile(
            title: Text('Item $num'),
            onTap: () => print('Item $num'),
          ),
        ),
      ),
      floatingActionButton: ScrollFloatingActionButton(
        scrollController: _controller,
        fab: FloatingActionButton(
          child: Icon(Icons.vertical_align_top),
          onPressed: () => _controller.scrollTop(),
        ),
      ),
    );
  }
}
