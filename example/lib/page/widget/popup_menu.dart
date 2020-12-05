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
              onPressed: () => showIconPopupMenu(
                context: context,
                title: Text('showIconPopupMenu'),
                popWhenPressed: true,
                barrierDismissible: true,
                items: [
                  IconPopupActionItem(
                    text: Text('test1'),
                    icon: Icon(Icons.check),
                    action: () => print('test1'),
                  ),
                  IconPopupActionItem(
                    text: Text('test2'),
                    icon: Icon(Icons.check),
                    action: () => print('test2'),
                  ),
                ],
              ),
            ),
            OutlineButton(
              child: Text('showTextPopupMenu'),
              onPressed: () => showTextPopupMenu(
                context: context,
                title: Text('showTextPopupMenu'),
                popWhenPressed: true,
                barrierDismissible: true,
                items: [
                  TextPopupActionItem(
                    text: Text('test3'),
                    action: () => print('test3'),
                  ),
                  TextPopupActionItem(
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
