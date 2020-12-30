import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class PopupMenuPage extends StatefulWidget {
  const PopupMenuPage({Key key}) : super(key: key);

  @override
  _PopupMenuPageState createState() => _PopupMenuPageState();
}

class _PopupMenuPageState extends State<PopupMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PopupMenu Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlineButton(
              child: Text('showIconPopupMenu'),
              onPressed: () => showPopupListMenu(
                context: context,
                title: Text('showIconPopupMenu'),
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
              child: Text('showTextPopupMenu'),
              onPressed: () => showPopupListMenu(
                context: context,
                title: Text('showTextPopupMenu'),
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
          ],
        ),
      ),
    );
  }
}
