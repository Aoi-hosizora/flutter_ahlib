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
        title: Text('PopupListMenu Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlineButton(
              child: Text('showPopupListMenu - IconTextMenuItem'),
              onPressed: () => showPopupListMenu(
                context: context,
                title: Text('showPopupListMenu'),
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
            OutlineButton(
              child: Text('showPopupListMenu - TextMenuItem'),
              onPressed: () => showPopupListMenu(
                context: context,
                title: Text('showPopupListMenu'),
                barrierDismissible: true,
                items: [
                  TextMenuItem(
                    text: Text('test3'),
                    action: () => print('test3'),
                  ),
                  TextMenuItem(
                    text: Text('test4'),
                    action: () => print('test4'),
                  ),
                ],
              ),
            ),
            OutlineButton(
              child: Text('showPopupListMenu - XXX'),
              onPressed: () => showPopupListMenu(
                context: context,
                title: Text('showPopupListMenu'),
                barrierDismissible: true,
                items: [
                  TextMenuItem(
                    text: Text('test5'),
                    action: () => print('test5'),
                    dismissBefore: true,
                    dismissAfter: false,
                  ),
                  IconTextMenuItem(
                    iconText: IconText.simple(Icons.chevron_right, 'test6'),
                    action: () => print('test6'),
                    dismissBefore: false,
                    dismissAfter: true,
                  ),
                  MenuItem(
                    child: Text('test7'),
                    action: () => print('test7'),
                    dismissBefore: false,
                    dismissAfter: false,
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
