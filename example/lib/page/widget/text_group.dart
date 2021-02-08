import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class TextGroupPage extends StatefulWidget {
  @override
  _TextGroupPageState createState() => _TextGroupPageState();
}

class _TextGroupPageState extends State<TextGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextGroup Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextGroup(
              texts: [
                NormalGroupText(text: 'test1'),
                NormalGroupText(
                  text: '|NormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupText|',
                  style: TextStyle(color: Colors.red),
                ),
                NormalGroupText(text: 'test2'),
                LinkGroupText(
                  text: '|LinkGroupText1|',
                  onTap: () => print('tapped 1'),
                  normalColor: Theme.of(context).primaryColor,
                  pressedColor: Colors.red,
                ),
                NormalGroupText(text: 'test3'),
                LinkGroupText(
                  text: '|LinkGroupText2|',
                  onTap: () => print('tapped 2'),
                  pressedColor: Theme.of(context).primaryColor,
                ),
                NormalGroupText(text: 'test4'),
                LinkGroupText(
                  text: '|LinkGroupText3|',
                  onTap: () => print('tapped 3'),
                  normalColor: Theme.of(context).primaryColor,
                  showUnderline: false,
                ),
              ],
            ),
            Divider(),
            TextGroup(
              selectable: true,
              texts: [
                NormalGroupText(text: 'test1'),
                NormalGroupText(
                  text: '|NormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupText|',
                  style: TextStyle(color: Colors.red),
                ),
                NormalGroupText(text: 'test2'),
                LinkGroupText(
                  text: '|LinkGroupText1|',
                  onTap: () => print('tapped 1'),
                  normalColor: Theme.of(context).primaryColor,
                  pressedColor: Colors.red,
                ),
                NormalGroupText(text: 'test3'),
                LinkGroupText(
                  text: '|LinkGroupText2|',
                  onTap: () => print('tapped 2'),
                  pressedColor: Theme.of(context).primaryColor,
                ),
                NormalGroupText(text: 'test4'),
                LinkGroupText(
                  text: '|LinkGroupText3|',
                  onTap: () => print('tapped 3'),
                  normalColor: Theme.of(context).primaryColor,
                  showUnderline: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
