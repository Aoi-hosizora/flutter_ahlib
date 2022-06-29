import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class AnimatedFabPage extends StatefulWidget {
  const AnimatedFabPage({Key? key}) : super(key: key);

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
          Scrollbar(
            child: ListView(
              controller: _controller,
              children: List.generate(
                30,
                (num) => ListTile(
                  title: Text(
                    num == 5
                        ? 'show l'
                        : num == 6
                            ? 'hide l'
                            : num == 7
                                ? 'show r'
                                : num == 8
                                    ? 'hide r'
                                    : 'Item $num',
                  ),
                  onTap: () {
                    if (num == 5) {
                      _show = true;
                      if (mounted) setState(() {});
                    } else if (num == 6) {
                      _show = false;
                      if (mounted) setState(() {});
                    }
                    if (num == 7) {
                      _fabController.show();
                    } else if (num == 8) {
                      _fabController.hide();
                    } else {
                      print('Item $num');
                    }
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: AnimatedFab(
              show: _show,
              fab: FloatingActionButton(
                child: Icon(Icons.vertical_align_top),
                onPressed: () => _controller.scrollToTop(),
                heroTag: '3',
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: ScrollAnimatedFab(
              scrollController: _controller,
              condition: ScrollAnimatedCondition.direction,
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
