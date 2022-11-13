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
      body: Scrollbar(
        isAlwaysShown: true,
        interactive: true,
        controller: _controller,
        child: ListView.builder(
          controller: _controller,
          itemCount: 30,
          itemBuilder: (c, idx) {
            const predefined = [
              /* 0 */ 'l1: AnimatedFab, with custom builder, use show as parameter',
              /* 1 */ 'l2: AnimatedFab, with custom builder, use !show as parameter',
              /* 2 */ 'm1: ScrollAnimatedFab, direction condition',
              /* 3 */ 'm2: ScrollAnimatedFab, reverseDirection condition',
              /* 4 */ 'r1: ScrollAnimatedFab, offset direction, use controller',
              /* 5 */ 'r2: ScrollAnimatedFab, reverseOffset direction',
              /* 6 */ 'show l1',
              /* 7 */ 'hide l1',
              /* 8 */ 'show r1',
              /* 9 */ 'hide r1',
            ];
            var text = idx < predefined.length ? predefined[idx] : 'Item $idx';
            return ListTile(
              title: Text(text),
              onTap: () {
                if (idx == 6) {
                  _show = true;
                  if (mounted) setState(() {});
                } else if (idx == 7) {
                  _show = false;
                  if (mounted) setState(() {});
                } else if (idx == 8) {
                  _fabController.show();
                } else if (idx == 9) {
                  _fabController.hide();
                } else {
                  printLog('Item $idx');
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 32), // <<<
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // l
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // l1
                AnimatedFab(
                  show: _show,
                  fab: FloatingActionButton(
                    child: const Icon(Icons.vertical_align_top),
                    heroTag: null,
                    onPressed: () => _controller.scrollToTop(),
                  ),
                  curve: Curves.ease,
                  customBuilder: (anim, fab) => FadeTransition(
                    opacity: anim,
                    child: fab,
                  ),
                ),
                const SizedBox(height: 25),
                // l2
                AnimatedFab(
                  show: !_show,
                  fab: FloatingActionButton(
                    child: const Icon(Icons.vertical_align_bottom),
                    heroTag: null,
                    onPressed: () => _controller.scrollToBottom(),
                  ),
                  curve: Curves.ease,
                  customBuilder: (anim, fab) => FadeTransition(
                    opacity: anim,
                    child: fab,
                  ),
                ),
              ],
            ),
            // m
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // m1
                ScrollAnimatedFab(
                  scrollController: _controller,
                  condition: ScrollAnimatedCondition.direction,
                  fab: FloatingActionButton(
                    child: const Icon(Icons.vertical_align_top),
                    heroTag: null,
                    onPressed: () => _controller.scrollToTop(),
                  ),
                ),
                const SizedBox(height: 25),
                // m2
                ScrollAnimatedFab(
                  scrollController: _controller,
                  condition: ScrollAnimatedCondition.reverseDirection,
                  fab: FloatingActionButton(
                    child: const Icon(Icons.vertical_align_bottom),
                    heroTag: null,
                    onPressed: () => _controller.scrollToBottom(),
                  ),
                ),
              ],
            ),
            // r
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // r1
                ScrollAnimatedFab(
                  scrollController: _controller,
                  condition: ScrollAnimatedCondition.offset,
                  controller: _fabController,
                  fab: FloatingActionButton(
                    child: const Icon(Icons.vertical_align_top),
                    heroTag: null,
                    onPressed: () => _controller.scrollToTop(),
                  ),
                ),
                const SizedBox(height: 25),
                // r2
                ScrollAnimatedFab(
                  scrollController: _controller,
                  condition: ScrollAnimatedCondition.reverseOffset,
                  fab: FloatingActionButton(
                    child: const Icon(Icons.vertical_align_bottom),
                    heroTag: null,
                    onPressed: () => _controller.scrollToBottom(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
