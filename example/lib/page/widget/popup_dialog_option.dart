import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class PopupDialogOptionPage extends StatefulWidget {
  const PopupDialogOptionPage({Key? key}) : super(key: key);

  @override
  _PopupDialogOptionPageState createState() => _PopupDialogOptionPageState();
}

class _PopupDialogOptionPageState extends State<PopupDialogOptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopupDialogOption Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('showDialog - SimpleDialogOption (default)'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => SimpleDialog(
                  title: const Text('SimpleDialogOption'),
                  children: [
                    SimpleDialogOption(child: const Text('test1'), onPressed: () => printLog('test1')),
                    SimpleDialogOption(child: const Text('test2'), onPressed: () => printLog('test2')),
                    SimpleDialogOption(child: const Text('test3'), onPressed: () => printLog('test3')),
                    const Divider(thickness: 1),
                    SimpleDialogOption(child: const Text('cancel'), onPressed: () => Navigator.of(c).pop()),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - TextDialogOption'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => SimpleDialog(
                  title: const Text('TextDialogOption'),
                  children: [
                    TextDialogOption(text: const Text('test1'), onPressed: () => printLog('test1')),
                    TextDialogOption(text: const Text('test2'), onPressed: () => printLog('test2')),
                    TextDialogOption(text: const Text('test3'), onPressed: () => printLog('test3')),
                    const Divider(thickness: 1),
                    TextDialogOption(text: const Text('cancel'), onPressed: () => Navigator.of(c).pop()),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - IconTextDialogOption'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => SimpleDialog(
                  title: const Text('IconTextDialogOption'),
                  children: [
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test1'), onPressed: () => printLog('test1')),
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test2'), onPressed: () => printLog('test2')),
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test3'), onPressed: () => printLog('test3')),
                    const Divider(thickness: 1),
                    IconTextDialogOption(icon: const Icon(Icons.arrow_back), text: const Text('cancel'), onPressed: () => Navigator.of(c).pop()),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - TextDialogOption (only option)'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => SimpleDialog(
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  children: [
                    TextDialogOption(text: const Text('test1'), onPressed: () => printLog('test1')),
                    const Divider(height: 0, thickness: 1),
                    TextDialogOption(text: const Text('test2'), onPressed: () => printLog('test2')),
                    const Divider(height: 0, thickness: 1),
                    TextDialogOption(text: const Text('test3'), onPressed: () => printLog('test3')),
                    const Divider(height: 0, thickness: 1),
                    TextDialogOption(text: const Text('cancel'), onPressed: () => Navigator.of(c).pop()),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - IconTextDialogOption (only option)'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => SimpleDialog(
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  children: [
                    IconTextDialogOption(
                      icon: const Icon(Icons.check),
                      text: const Text('test1'),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      onPressed: () => printLog('test1'),
                    ),
                    const Divider(height: 0, thickness: 1),
                    IconTextDialogOption(
                      icon: const Icon(Icons.check),
                      text: const Text('test2'),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      onPressed: () => printLog('test2'),
                    ),
                    const Divider(height: 0, thickness: 1),
                    IconTextDialogOption(
                      icon: const Icon(Icons.check),
                      text: const Text('test3'),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      onPressed: () => printLog('test3'),
                    ),
                    const Divider(height: 0, thickness: 1),
                    IconTextDialogOption(
                      icon: const Icon(Icons.arrow_back),
                      text: const Text('cancel'),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      onPressed: () => Navigator.of(c).pop(),
                    ),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - TextDialogOption+IconTextDialogOption'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => SimpleDialog(
                  title: const Text('TextDialogOption+IconTextDialogOption'),
                  children: [
                    TextDialogOption(text: const Text('test1'), onPressed: () => printLog('test1')),
                    TextDialogOption(text: const Text('test2'), onPressed: () => printLog('test2')),
                    TextDialogOption(text: const Text('test3'), onPressed: () => printLog('test3')),
                    IconTextDialogOption(icon: const Icon(Icons.refresh), text: const Text('test1'), onPressed: () => printLog('test1')),
                    IconTextDialogOption(icon: const Icon(Icons.download), text: const Text('test2'), onPressed: () => printLog('test2')),
                    IconTextDialogOption(icon: const Icon(Icons.share), text: const Text('test3'), onPressed: () => printLog('test3')),
                    const Divider(thickness: 1),
                    IconTextDialogOption(icon: const Icon(Icons.arrow_back), text: const Text('cancel'), onPressed: () => Navigator.of(c).pop()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
