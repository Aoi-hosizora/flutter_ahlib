import 'package:flutter/material.dart';

class CustomScrollPhysicsPage extends StatefulWidget {
  const CustomScrollPhysicsPage({Key? key}) : super(key: key);

  @override
  State<CustomScrollPhysicsPage> createState() => _CustomScrollPhysicsPageState();
}

class _CustomScrollPhysicsPageState extends State<CustomScrollPhysicsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomScrollPhysics Example'),
      ),
      body: const Center(
        child: Text('TODO'),
      ),
    );
  }
}
