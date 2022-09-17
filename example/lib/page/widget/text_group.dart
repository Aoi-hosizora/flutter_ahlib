import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

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
            Center(
              child: Text(
                'Non-selectable:',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            const SizedBox(height: 5),
            TextGroup.normal(
              style: Theme.of(context).textTheme.bodyText2,
              texts: [
                const PlainTextItem(text: 'short_text'),
                const PlainTextItem(
                  text: 'long_text_long_text_long_text_long_text_long_text_long_text_long_text_long_text_long_text',
                  style: TextStyle(color: Colors.red),
                ),
                const PlainTextItem(
                  text: 'short_text\n',
                  style: TextStyle(backgroundColor: Colors.yellow),
                ),
                const PlainTextItem(text: 'test1'),
                LinkTextItem(
                  text: '|LinkTextItem1|',
                  onTap: () => printLog('tapped 1'),
                  normalColor: Theme.of(context).primaryColor,
                  pressedColor: Colors.red,
                ),
                const PlainTextItem(text: 'test2'),
                LinkTextItem(
                  text: '|LinkTextItem2|',
                  onTap: () => printLog('tapped 2'),
                  basicStyle: Theme.of(context).textTheme.bodyText1,
                  pressedColor: Theme.of(context).primaryColor,
                  showUnderline: false,
                ),
                const PlainTextItem(text: 'test3'),
                LinkTextItem(
                  text: '|LinkTextItem3|',
                  onTap: () => printLog('tapped 3'),
                  normalColor: Theme.of(context).primaryColor,
                  wrapperBuilder: (c, w, o) => WidgetSpan(
                    child: InkWell(
                      child: Container(
                        child: w,
                        color: !o ? Colors.grey : Colors.transparent,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Center(
              child: Text(
                'Selectable:',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            const SizedBox(height: 5),
            TextGroup.selectable(
              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontStyle: FontStyle.italic),
              texts: [
                const PlainTextItem(text: 'short_text'),
                const PlainTextItem(
                  text: 'long_text_long_text_long_text_long_text_long_text_long_text_long_text_long_text_long_text',
                  style: TextStyle(color: Colors.red),
                ),
                const PlainTextItem(
                  text: 'short_text\n',
                  style: TextStyle(backgroundColor: Colors.yellow),
                ),
                const PlainTextItem(text: 'test1'),
                LinkTextItem.style(
                  text: '|LinkTextItem1|',
                  onTap: () => printLog('tapped 1'),
                  normalStyle: TextStyle(color: Theme.of(context).primaryColor),
                  pressedStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.normal),
                ),
                const PlainTextItem(text: 'test2'),
                LinkTextItem.style(
                  text: '|LinkTextItem2|',
                  onTap: () => printLog('tapped 2'),
                  normalStyle: const TextStyle(fontStyle: FontStyle.normal, fontWeight: FontWeight.normal),
                  pressedStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                const PlainTextItem(text: 'test3'),
                LinkTextItem.style(
                  text: '|LinkTextItem3|',
                  onTap: () => printLog('tapped 3'),
                  normalStyle: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                  wrapperBuilder: (c, w, o) => WidgetSpan(
                    child: InkWell(
                      child: Container(
                        child: w,
                        color: !o ? Colors.grey : Colors.transparent,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
