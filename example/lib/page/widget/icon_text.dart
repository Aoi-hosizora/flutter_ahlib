import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class IconTextPage extends StatefulWidget {
  const IconTextPage({Key? key}) : super(key: key);

  @override
  _IconTextPageState createState() => _IconTextPageState();
}

class _IconTextPageState extends State<IconTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IconText Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: IconText(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  icon: Icon(Icons.check),
                  text: Text('Check'),
                  alignment: IconTextAlignment.l2r,
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: IconText(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  icon: Icon(Icons.check),
                  text: Text('Check'),
                  alignment: IconTextAlignment.r2l,
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: IconText(
                  icon: Icon(Icons.check),
                  text: Text('Check'),
                  alignment: IconTextAlignment.t2b,
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: IconText(
                  icon: Icon(Icons.check),
                  text: Text('Check'),
                  alignment: IconTextAlignment.b2t,
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
