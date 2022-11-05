import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class AnimatedFabPage extends StatefulWidget {
  const AnimatedFabPage({Key? key}) : super(key: key);

  @override
  _AnimatedFabPageState createState() => _AnimatedFabPageState();
}

class _AnimatedFabPageState extends State<AnimatedFabPage> {
  final _controller = ScrollController();
  final _fabController = AnimatedFabController();
  var _show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedFab Example'),
        actions: [
          IconButton(icon: const Icon(Icons.vertical_align_top), onPressed: () => _controller.scrollToTop()),
          IconButton(icon: const Icon(Icons.vertical_align_bottom), onPressed: () => _controller.scrollToBottom()),
          IconButton(icon: const Text('Up'), onPressed: () => _controller.scrollUp()),
          IconButton(icon: const Text('Down'), onPressed: () => _controller.scrollDown()),
        ],
      ),
      body: Stack(
        children: [
          Scrollbar(
            isAlwaysShown: true,
            interactive: true,
            controller: _controller,
            child: ListView(
              controller: _controller,
              children: List.generate(
                30,
                (idx) => ListTile(
                  title: Text(
                    idx == 5
                        ? 'show l'
                        : idx == 6
                            ? 'hide l'
                            : idx == 7
                                ? 'show r'
                                : idx == 8
                                    ? 'hide r'
                                    : 'Item $idx',
                  ),
                  onTap: () {
                    if (idx == 5) {
                      _show = true;
                      if (mounted) setState(() {});
                    } else if (idx == 6) {
                      _show = false;
                      if (mounted) setState(() {});
                    }
                    if (idx == 7) {
                      _fabController.show();
                    } else if (idx == 8) {
                      _fabController.hide();
                    } else {
                      printLog('Item $idx');
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
                child: const Icon(Icons.vertical_align_top),
                onPressed: () => _controller.scrollToTop(),
                heroTag: null,
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
                child: const Icon(Icons.vertical_align_top),
                onPressed: () => _controller.scrollToTop(),
                heroTag: null,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ScrollAnimatedFab(
        scrollController: _controller,
        controller: _fabController,
        fab: FloatingActionButton(
          child: const Icon(Icons.vertical_align_top),
          onPressed: () => _controller.scrollToTop(),
          heroTag: null,
        ),
      ),
    );
  }
}
