import 'package:flutter/material.dart';
import 'package:flutter_ahlib_example/page/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_ahlib_example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: InkRipple.splashFactory,
      ),
      home: const IndexPage(),
    );
  }
}
