import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ScrollAnimatedFabPage extends StatefulWidget {
  const ScrollAnimatedFabPage({Key key}) : super(key: key);

  @override
  _ScrollAnimatedFabPageState createState() => _ScrollAnimatedFabPageState();
}

class _ScrollAnimatedFabPageState extends State<ScrollAnimatedFabPage> {
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScrollAnimatedFab Example'),
        actions: [
          IconButton(icon: Icon(Icons.vertical_align_top), onPressed: () => _controller.scrollToTop()),
          IconButton(icon: Icon(Icons.vertical_align_bottom), onPressed: () => _controller.scrollToBottom()),
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
      floatingActionButton: ScrollAnimatedFab(
        scrollController: _controller,
        fab: FloatingActionButton(
          child: Icon(Icons.vertical_align_top),
          onPressed: () => _controller.scrollToTop(),
        ),
      ),
    );
  }
}
