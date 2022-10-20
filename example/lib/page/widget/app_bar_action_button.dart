import 'package:flutter/material.dart';

class AppBarActionButtonPage extends StatefulWidget {
  const AppBarActionButtonPage({Key? key}) : super(key: key);

  @override
  State<AppBarActionButtonPage> createState() => _AppBarActionButtonPageState();
}

class _AppBarActionButtonPageState extends State<AppBarActionButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBarActionButton example'),
      ),
      body: const Center(
        child: Text('AppBarActionButton'),
      ),
    );
  }
}
