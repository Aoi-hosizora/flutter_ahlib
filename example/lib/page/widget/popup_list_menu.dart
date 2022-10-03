import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class PopupListMenuPage extends StatefulWidget {
  const PopupListMenuPage({Key? key}) : super(key: key);

  @override
  _PopupListMenuPageState createState() => _PopupListMenuPageState();
}

class _PopupListMenuPageState extends State<PopupListMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopupListMenu Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('showPopupListMenu - IconTextMenuItem'),
              onPressed: () => showPopupListMenu(
                context: context,
                title: const Text('showPopupListMenu'),
                barrierDismissible: true,
                items: [
                  IconTextMenuItem(
                    iconText: IconText.simple(Icons.chevron_right, 'test1'),
                    action: () => printLog('test1'),
                  ),
                  IconTextMenuItem(
                    iconText: IconText.simple(Icons.chevron_right, 'test2'),
                    action: () => printLog('test2'),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              child: const Text('showPopupListMenu - TextMenuItem'),
              onPressed: () => showPopupListMenu(
                context: context,
                title: const Text('showPopupListMenu'),
                barrierDismissible: true,
                items: [
                  TextMenuItem(
                    text: const Text('test3'),
                    action: () => printLog('test3'),
                  ),
                  TextMenuItem(
                    text: const Text('test4'),
                    action: () => printLog('test4'),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              child: const Text('showPopupListMenu - XXX'),
              onPressed: () => showPopupListMenu(
                context: context,
                title: const Text('showPopupListMenu'),
                barrierDismissible: true,
                items: [
                  TextMenuItem(
                    text: const Text('test5'),
                    action: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      printLog('test5');
                    },
                    dismissBehavior: DismissBehavior.before,
                  ),
                  IconTextMenuItem(
                    iconText: IconText.simple(Icons.chevron_right, 'test6'),
                    action: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      printLog('test6');
                    },
                    dismissBehavior: DismissBehavior.after,
                  ),
                  MenuItem(
                    child: const Text('test7'),
                    action: () => printLog('test7'),
                    dismissBehavior: DismissBehavior.never,
                  ),
                ],
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
