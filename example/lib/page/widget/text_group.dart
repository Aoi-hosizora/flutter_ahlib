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
      body: Column(
        children: [
          SizedBox(height: 4),
          TextGroup(
            texts: [
              NormalGroupText(text: 'test1'),
              NormalGroupText(
                text: 'NormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupText',
                style: TextStyle(color: Colors.red),
              ),
              NormalGroupText(text: 'test2'),
              LinkGroupText(
                text: 'LinkGroupText 1',
                onTap: () => print('tapped 1'),
                normalColor: Theme.of(context).primaryColor,
                pressedColor: Colors.red,
              ),
              NormalGroupText(text: 'test3'),
              LinkGroupText(
                text: 'LinkGroupText 2',
                onTap: () => print('tapped 2'),
                pressedColor: Theme.of(context).primaryColor,
                showUnderline: false,
              ),
              NormalGroupText(text: 'test4'),
              LinkGroupText(
                text: 'LinkGroupText 3',
                onTap: () => print('tapped 3'),
                normalColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
          Divider(),
          TextGroup(
            selectable: true,
            texts: [
              NormalGroupText(text: 'test1'),
              NormalGroupText(
                text: 'NormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupText',
                style: TextStyle(color: Colors.red),
              ),
              NormalGroupText(text: 'test2'),
              LinkGroupText(
                text: 'LinkGroupText 1',
                onTap: () => print('tapped 1'),
                normalColor: Theme.of(context).primaryColor,
                pressedColor: Colors.red,
              ),
              NormalGroupText(text: 'test3'),
              LinkGroupText(
                text: 'LinkGroupText 2',
                onTap: () => print('tapped 2'),
                pressedColor: Theme.of(context).primaryColor,
                showUnderline: false,
              ),
              NormalGroupText(text: 'test4'),
              LinkGroupText(
                text: 'LinkGroupText 3',
                onTap: () => print('tapped 3'),
                normalColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
