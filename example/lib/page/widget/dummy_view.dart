import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class DummyViewPage extends StatefulWidget {
  const DummyViewPage({Key key}) : super(key: key);

  @override
  _DummyViewPageState createState() => _DummyViewPageState();
}

class _DummyViewPageState extends State<DummyViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DummyView Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(height: 1, thickness: 1),
            DummyView(),
            Divider(height: 1, thickness: 1),
            DummyView(),
            Divider(height: 1, thickness: 1),
            DummyView(),
            Divider(height: 1, thickness: 1),
            DummyView(),
            Divider(height: 1, thickness: 1),
            DummyView(),
            Divider(height: 1, thickness: 1),
          ],
        ),
      ),
    );
  }
}
