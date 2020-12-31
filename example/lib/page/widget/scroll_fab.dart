import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ScrollFloatingActionButtonPage extends StatefulWidget {
  const ScrollFloatingActionButtonPage({Key key}) : super(key: key);

  @override
  _ScrollFloatingActionButtonPageState createState() => _ScrollFloatingActionButtonPageState();
}

class _ScrollFloatingActionButtonPageState extends State<ScrollFloatingActionButtonPage> {
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScrollFloatingActionButton Example'),
        actions: [
          IconButton(icon: Text('Top'), onPressed: () => _controller.scrollToTop()),
          IconButton(icon: Text('Bottom'), onPressed: () => _controller.scrollToBottom()),
          IconButton(icon: Text('Up'), onPressed: () => _controller.scrollUp()),
          IconButton(icon: Text('Down'), onPressed: () => _controller.scrollDown()),
        ],
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
          onPressed: () => _controller.scrollToTop(),
        ),
      ),
    );
  }
}
