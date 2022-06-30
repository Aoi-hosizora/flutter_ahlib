import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

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
                    action: () => print('test1'),
                  ),
                  IconTextMenuItem(
                    iconText: IconText.simple(Icons.chevron_right, 'test2'),
                    action: () => print('test2'),
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
                    action: () => print('test3'),
                  ),
                  TextMenuItem(
                    text: const Text('test4'),
                    action: () => print('test4'),
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
                      print('test5');
                    },
                    dismissBehavior: DismissBehavior.before,
                  ),
                  IconTextMenuItem(
                    iconText: IconText.simple(Icons.chevron_right, 'test6'),
                    action: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      print('test6');
                    },
                    dismissBehavior: DismissBehavior.after,
                  ),
                  MenuItem(
                    child: const Text('test7'),
                    action: () => print('test7'),
                    dismissBehavior: DismissBehavior.never,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
