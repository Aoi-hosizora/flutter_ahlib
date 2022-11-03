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
                    SimpleDialogOption(child: const Text('test1'), onPressed: () {}),
                    SimpleDialogOption(child: const Text('test2'), onPressed: () {}),
                    SimpleDialogOption(child: const Text('test3'), onPressed: () {}),
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
                    TextDialogOption(text: const Text('test1'), onPressed: () {}),
                    TextDialogOption(text: const Text('test2'), onPressed: () {}),
                    TextDialogOption(text: const Text('test3'), onPressed: () {}),
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
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test1'), onPressed: () {}),
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test2'), onPressed: () {}),
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test3'), onPressed: () {}),
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
                    TextDialogOption(text: const Text('test1'), onPressed: () {}),
                    const Divider(height: 0, thickness: 1),
                    TextDialogOption(text: const Text('test2'), onPressed: () {}),
                    const Divider(height: 0, thickness: 1),
                    TextDialogOption(text: const Text('test3'), onPressed: () {}),
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
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test1'), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), onPressed: () {}),
                    const Divider(height: 0, thickness: 1),
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test2'), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), onPressed: () {}),
                    const Divider(height: 0, thickness: 1),
                    IconTextDialogOption(icon: const Icon(Icons.check), text: const Text('test3'), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), onPressed: () {}),
                    const Divider(height: 0, thickness: 1),
                    IconTextDialogOption(icon: const Icon(Icons.arrow_back), text: const Text('cancel'), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), onPressed: () => Navigator.of(c).pop()),
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
                    TextDialogOption(text: const Text('test1'), onPressed: () {}),
                    TextDialogOption(text: const Text('test2'), onPressed: () {}),
                    TextDialogOption(text: const Text('test3'), onPressed: () {}),
                    IconTextDialogOption(icon: const Icon(Icons.refresh), text: const Text('test1'), onPressed: () {}),
                    IconTextDialogOption(icon: const Icon(Icons.download), text: const Text('test2'), onPressed: () {}),
                    IconTextDialogOption(icon: const Icon(Icons.share), text: const Text('test3'), onPressed: () {}),
                    const Divider(thickness: 1),
                    IconTextDialogOption(icon: const Icon(Icons.arrow_back), text: const Text('cancel'), onPressed: () => Navigator.of(c).pop()),
                  ],
                ),
              ),
            ),
            const Divider(),
            OutlinedButton(
              child: const Text('showGeneralDialog - CustomSingleChildLayout'),
              onPressed: () async {
                var offset = false;
                var result = await showGeneralDialog<String>(
                  context: context,
                  barrierColor: Colors.transparent,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                  pageBuilder: (c, _, __) => StatefulBuilder(
                    builder: (_, _setState) => CustomSingleChildLayout(
                      delegate: CustomSingleChildLayoutDelegate(
                        sizeGetter: (constraints) => constraints.biggest,
                        constraintsGetter: (constraints) => BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                          maxWidth: MediaQuery.of(context).size.width - (!offset ? 0 : 50),
                          maxHeight: MediaQuery.of(context).size.height - (!offset ? MediaQuery.of(context).padding.top + kToolbarHeight : 100),
                        ),
                        positionGetter: (size, childSize) => Offset(
                          !offset ? 0 : 50,
                          !offset ? MediaQuery.of(context).padding.top + kToolbarHeight : 100,
                        ),
                        relayoutChecker: () => true,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            color: Colors.yellow,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('General Dialog'),
                                  const SizedBox(height: 5),
                                  OutlinedButton(
                                    onPressed: () => Navigator.of(context).pop('dismiss'),
                                    child: const Text('dismiss'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () => _setState(() => offset = !offset),
                                    child: Text('offset - ${offset ? 'on' : 'off'}'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                color: const Color(0x80000000),
                                margin: EdgeInsets.only(right: !offset ? 0 : 10, bottom: !offset ? 0 : 10),
                              ),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
                printLog('$result, from showGeneralDialog - CustomSingleChildLayout');
              },
            ),
            OutlinedButton(
              child: const Text('showGeneralDialog - Stack'),
              onPressed: () async {
                var result = await showGeneralDialog<String>(
                  context: context,
                  barrierColor: Colors.transparent,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                  pageBuilder: (c, _, __) => Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: MediaQuery.of(context).padding.top + kToolbarHeight,
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          child: Container(
                            color: const Color(0x80000000),
                          ),
                          onTap: () => Navigator.of(context).pop(null),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: MediaQuery.of(context).padding.top + kToolbarHeight,
                        right: 0,
                        child: Container(
                          height: 150,
                          color: Colors.yellow,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('General Dialog'),
                                const SizedBox(height: 5),
                                OutlinedButton(
                                  onPressed: () => Navigator.of(context).pop('dismiss'),
                                  child: const Text('dismiss'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                printLog('$result - from showGeneralDialog - Stack');
              },
            ),
          ],
        ),
      ),
    );
  }
}
