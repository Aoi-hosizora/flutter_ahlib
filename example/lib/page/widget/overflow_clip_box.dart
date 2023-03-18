import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class OverflowClipBoxPage extends StatefulWidget {
  const OverflowClipBoxPage({Key? key}) : super(key: key);

  @override
  State<OverflowClipBoxPage> createState() => _OverflowClipBoxPageState();
}

class _OverflowClipBoxPageState extends State<OverflowClipBoxPage> {
  var _useOverflowBox = false;
  var _useClipRect = true;

  Widget _build({
    required String title,
    required Widget child,
    required OverflowDirection direction,
    required Alignment alignment,
  }) {
    return Column(
      children: [
        Text(title),
        OverflowClipBox(
          child: Container(
            color: Colors.yellow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [child],
                )
              ],
            ),
          ),
          useOverflowBox: _useOverflowBox,
          useClipRect: _useClipRect,
          direction: direction,
          alignment: alignment,
          width: 140,
          height: 140,
        ),
      ],
    );
  }

  String get _longText => (('test' * 8) + '\n') * 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OverflowClipBox Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _build(
                  title: 'horizontal, topLeft',
                  child: Text(_longText),
                  direction: OverflowDirection.horizontal,
                  alignment: Alignment.topLeft,
                ),
                const SizedBox(width: 20),
                _build(
                  title: 'vertical, topLeft',
                  child: Text(_longText),
                  direction: OverflowDirection.vertical,
                  alignment: Alignment.topLeft,
                ),
                const SizedBox(width: 20),
                _build(
                  title: 'all, topLeft',
                  child: Text(_longText),
                  direction: OverflowDirection.all,
                  alignment: Alignment.topLeft,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _build(
                  title: 'horizontal, center',
                  child: Text(_longText),
                  direction: OverflowDirection.horizontal,
                  alignment: Alignment.center,
                ),
                const SizedBox(width: 20),
                _build(
                  title: 'vertical, center',
                  child: Text(_longText),
                  direction: OverflowDirection.vertical,
                  alignment: Alignment.center,
                ),
                const SizedBox(width: 20),
                _build(
                  title: 'all, center',
                  child: Text(_longText),
                  direction: OverflowDirection.all,
                  alignment: Alignment.center,
                ),
              ],
            ),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('useOverflowBox'),
                Switch(value: _useOverflowBox, onChanged: (b) => mountedSetState(() => _useOverflowBox = b)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('useClipRect'),
                Switch(value: _useClipRect, onChanged: (b) => mountedSetState(() => _useClipRect = b)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
