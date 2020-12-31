import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class AnimatedFabPage extends StatefulWidget {
  const AnimatedFabPage({Key key}) : super(key: key);

  @override
  _AnimatedFabPageState createState() => _AnimatedFabPageState();
}

class _AnimatedFabPageState extends State<AnimatedFabPage> {
  var _controller = ScrollController();
  var _fabController = AnimatedFabController();
  var _show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimatedFab Example'),
        actions: [
          IconButton(icon: Icon(Icons.vertical_align_top), onPressed: () => _controller.scrollToTop()),
          IconButton(icon: Icon(Icons.vertical_align_bottom), onPressed: () => _controller.scrollToBottom()),
          IconButton(icon: Text('Up'), onPressed: () => _controller.scrollUp()),
          IconButton(icon: Text('Down'), onPressed: () => _controller.scrollDown()),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: _controller,
            children: List.generate(
              30,
              (num) => ListTile(
                title: Text(
                  num == 5
                      ? 'show'
                      : num == 6
                          ? 'hide'
                          : 'Item $num',
                ),
                onTap: () {
                  if (num == 5) {
                    _show = true;
                    _fabController.show();
                    if (mounted) setState(() {});
                  } else if (num == 6) {
                    _show = false;
                    _fabController.hide();
                    if (mounted) setState(() {});
                  } else {
                    print('Item $num');
                  }
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: AnimatedFab(
              show: _show,
              fab: FloatingActionButton(
                child: Icon(Icons.vertical_align_top),
                onPressed: () => _controller.scrollToTop(),
                heroTag: '2',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ScrollAnimatedFab(
        scrollController: _controller,
        controller: _fabController,
        fab: FloatingActionButton(
          child: Icon(Icons.vertical_align_top),
          onPressed: () => _controller.scrollToTop(),
          heroTag: '1',
        ),
      ),
    );
  }
}
