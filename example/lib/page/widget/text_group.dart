import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class TextGroupPage extends StatefulWidget {
  const TextGroupPage({Key? key}) : super(key: key);

  @override
  _TextGroupPageState createState() => _TextGroupPageState();
}

class _TextGroupPageState extends State<TextGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextGroup Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextGroup(
              texts: [
                const NormalGroupText(text: 'test1'),
                const NormalGroupText(
                  text: '|NormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupText|',
                  style: TextStyle(color: Colors.red),
                ),
                const NormalGroupText(text: 'test2'),
                LinkGroupText(
                  text: '|LinkGroupText1|',
                  onTap: () => print('tapped 1'),
                  normalColor: Theme.of(context).primaryColor,
                  pressedColor: Colors.red,
                ),
                const NormalGroupText(text: 'test3'),
                LinkGroupText(
                  text: '|LinkGroupText2|',
                  onTap: () => print('tapped 2'),
                  pressedColor: Theme.of(context).primaryColor,
                ),
                const NormalGroupText(text: 'test4'),
                LinkGroupText(
                  text: '|LinkGroupText3|',
                  onTap: () => print('tapped 3'),
                  normalColor: Theme.of(context).primaryColor,
                  showUnderline: false,
                ),
              ],
            ),
            const Divider(),
            TextGroup(
              selectable: true,
              texts: [
                const NormalGroupText(text: 'test1'),
                const NormalGroupText(
                  text: '|NormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupTextNormalGroupText|',
                  style: TextStyle(color: Colors.red),
                ),
                const NormalGroupText(text: 'test2'),
                LinkGroupText(
                  text: '|LinkGroupText1|',
                  onTap: () => print('tapped 1'),
                  normalColor: Theme.of(context).primaryColor,
                  pressedColor: Colors.red,
                ),
                const NormalGroupText(text: 'test3'),
                LinkGroupText(
                  text: '|LinkGroupText2|',
                  onTap: () => print('tapped 2'),
                  pressedColor: Theme.of(context).primaryColor,
                ),
                const NormalGroupText(text: 'test4'),
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
