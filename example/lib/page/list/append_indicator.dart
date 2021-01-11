import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class AppendIndicatorPage extends StatefulWidget {
  @override
  _AppendIndicatorPageState createState() => _AppendIndicatorPageState();
}

class _AppendIndicatorPageState extends State<AppendIndicatorPage> {
  final _indicatorKey = GlobalKey<AppendIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppendIndicator Example'),
      ),
      body: AppendIndicator(
        key: _indicatorKey,
        onAppend: () async => await Future.delayed(Duration(milliseconds: 3000)),
        child: Scrollbar(
          child: ListView(
            children: List.generate(
              2,
              (i) => ListTile(
                title: Text('Item ${i + 1}'),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _indicatorKey.currentState.show(),
      ),
    );
  }
}
