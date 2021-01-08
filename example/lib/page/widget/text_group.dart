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
                text: 'test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2',
                style: TextStyle(color: Colors.red),
              ),
              NormalGroupText(text: 'test3'),
            ],
          ),
          Divider(),
          TextGroup(
            texts: [
              NormalGroupText(text: 'test1'),
              LinkGroupText(
                text: 'link',
                onTap: () => print('tapped'),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              NormalGroupText(text: 'test3'),
            ],
            linkPressedColor: Colors.red,
          ),
          Divider(),
          TextGroup(
            selectable: true,
            texts: [
              NormalGroupText(text: 'test1'),
              NormalGroupText(
                text: 'test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2test2',
                style: TextStyle(color: Colors.red),
              ),
              NormalGroupText(text: 'test3'),
            ],
          ),
          Divider(),
          TextGroup(
            selectable: true,
            texts: [
              NormalGroupText(text: 'test1'),
              LinkGroupText(
                text: 'link',
                onTap: () => print('tapped'),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              NormalGroupText(text: 'test3'),
            ],
            linkPressedColor: Colors.red,
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
