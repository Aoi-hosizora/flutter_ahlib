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
                    TextDialogOption(text: const Text('test3 (also pop)'), onPressed: () => printLog('test3'), popWhenPress: c),
                    const Divider(thickness: 1),
                    TextDialogOption(text: const Text('cancel'), onPressed: () => Navigator.of(c).pop()),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - TextDialogOption 2'),
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
                    TextDialogOption(text: const Text('test3 (also pop)'), onPressed: () => printLog('test3'), popWhenPress: c),
                    const Divider(height: 0, thickness: 1),
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
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test3 (also pop)'), onPressed: () => printLog('test3'), popWhenPress: c),
                    const Divider(thickness: 1),
                    IconTextDialogOption(icon: const Icon(Icons.arrow_back), text: const Text('cancel'), onPressed: () => Navigator.of(c).pop()),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - IconTextDialogOption 2'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => (kIconTextDialogOptionPadding.copyWith(left: 15, right: 15)).let(
                  (padding) => SimpleDialog(
                    insetPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    children: [
                      IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test1'), padding: padding, onPressed: () => printLog('test1')),
                      const Divider(height: 0, thickness: 1),
                      IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test2'), padding: padding, onPressed: () => printLog('test2')),
                      const Divider(height: 0, thickness: 1),
                      IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test3 (also pop)'), padding: padding, onPressed: () => printLog('test3'), popWhenPress: c),
                      const Divider(height: 0, thickness: 1),
                      IconTextDialogOption(icon: const Icon(Icons.arrow_back), text: const Text('cancel'), padding: padding, onPressed: () => Navigator.of(c).pop()),
                    ],
                  ),
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
                    TextDialogOption(text: const Text('test3 (also pop)'), onPressed: () => printLog('test3'), popWhenPress: c),
                    IconTextDialogOption(icon: const Icon(Icons.refresh), text: const Text('test1'), onPressed: () => printLog('test1')),
                    IconTextDialogOption(icon: const Icon(Icons.download), text: const Text('test2'), onPressed: () => printLog('test2')),
                    IconTextDialogOption(icon: const Icon(Icons.share), text: const Text('test3 (also pop)'), onPressed: () => printLog('test3'), popWhenPress: c),
                    const Divider(thickness: 1),
                    IconTextDialogOption(icon: const Icon(Icons.arrow_back), text: const Text('cancel'), onPressed: () {}, rtl: true, popWhenPress: c),
                  ],
                ),
              ),
            ),
            const Divider(),
            OutlinedButton(
              child: const Text('showDialog - CircularProgressDialogOption (has title)'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => const AlertDialog(
                  title: Text('CircularProgressDialogOption'),
                  contentPadding: EdgeInsets.zero,
                  content: CircularProgressDialogOption(
                    progress: CircularProgressIndicator(),
                    child: Text('Loading...'),
                  ),
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - CircularProgressDialogOption (no title)'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: CircularProgressDialogOption(
                    progress: const CircularProgressIndicator(),
                    child: Text(
                      'long_text_' * 50,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('showDialog - LinearProgressIndicator (using builtin)'),
              onPressed: () => showDialog(
                context: context,
                builder: (c) {
                  int? value;
                  var canceled = false;
                  return StatefulWidgetWithCallback.builder(
                    postFrameCallbackForInitState: (c, _setState) async {
                      await Future.delayed(const Duration(milliseconds: 3000));
                      for (var i = 0; i <= 100 && !canceled; i++) {
                        value = i;
                        if (value! % 10 == 0) {
                          printLog('showDialog - LinearProgressIndicator: $value');
                        }
                        _setState(() {}); // <<<
                        await Future.delayed(const Duration(milliseconds: 100));
                      }
                    },
                    builder: (c, _setState) => WillPopScope(
                      onWillPop: () async {
                        canceled = true;
                        return true;
                      },
                      child: AlertDialog(
                        title: const Text('LinearProgressIndicator (using builtin)'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'long_text_' * 50,
                              style: Theme.of(context).textTheme.subtitle1,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 24),
                            LinearProgressIndicator(value: value == null ? null : value! / 100),
                            const SizedBox(height: 6),
                            DefaultTextStyle(
                              style: Theme.of(context).textTheme.bodyText2!,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${value ?? 0}%'),
                                  Text('${value ?? 0}/100'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            OutlinedButton(
              child: const Text('showYesNoAlertDialog 1'),
              onPressed: () async {
                var result = await showYesNoAlertDialog(
                  context: context,
                  title: const Text('showYesNoAlertDialog'),
                  content: const Text('showYesNoAlertDialog("Yes", "No", reverse)'),
                  yesText: const Text('Yes'),
                  noText: const Text('No'),
                  reverseYesNoOrder: true,
                  yesOnPressed: null,
                  yesOnLongPress: null,
                  noOnPressed: (c) => printLog('showYesNoAlertDialog 1: noOnPressed, no pop'),
                  noOnLongPress: (c) {
                    Navigator.of(c).pop();
                    printLog('showYesNoAlertDialog 1: noOnLongPress, pop');
                  },
                );
                printLog('showYesNoAlertDialog 1: $result');
              },
            ),
            OutlinedButton(
              child: const Text('showYesNoAlertDialog 2'),
              onPressed: () async {
                var result = await showYesNoAlertDialog(
                  context: context,
                  title: const Text('showYesNoAlertDialog'),
                  content: const Text('showYesNoAlertDialog("OK")'),
                  yesText: const Text('OK'),
                  noText: null,
                  yesOnPressed: null,
                  yesOnLongPress: (c) => printLog('showYesNoAlertDialog 2: yesOnLongPress'),
                );
                printLog('showYesNoAlertDialog 2: $result');
              },
            ),
          ],
        ),
      ),
    );
  }
}
