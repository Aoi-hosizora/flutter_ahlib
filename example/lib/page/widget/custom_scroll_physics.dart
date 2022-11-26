import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class CustomScrollPhysicsPage extends StatefulWidget {
  const CustomScrollPhysicsPage({Key? key}) : super(key: key);

  @override
  State<CustomScrollPhysicsPage> createState() => _CustomScrollPhysicsPageState();
}

class _CustomScrollPhysicsPageState extends State<CustomScrollPhysicsPage> {
  final _physicsController = CustomScrollPhysicsController();
  var _single = false;
  var _hasController = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomScrollPhysics Example'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: PageView(
                  physics: CustomScrollPhysics(
                    controller: _hasController ? _physicsController : null,
                  ),
                  children: [
                    if (_single)
                      Container(
                        color: Colors.grey,
                        child: const Center(child: Text('The only page')),
                      ),
                    if (!_single) ...[
                      Container(
                        color: Colors.yellow,
                        child: const Center(child: Text('Page 1')),
                      ),
                      Container(
                        color: Colors.green,
                        child: const Center(child: Text('Page 2')),
                      ),
                      Container(
                        color: Colors.purple,
                        child: const Center(child: Text('Page 3')),
                      ),
                      Container(
                        color: Colors.red,
                        child: const Center(child: Text('Page 4')),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: DefaultScrollPhysics(
                  physics: CustomScrollPhysics(
                    controller: _hasController ? _physicsController : null,
                  ),
                  child: Builder(
                    builder: (c) => ListView.separated(
                      physics: DefaultScrollPhysics.of(c), // <<<
                      itemCount: !_single ? 50 : 1,
                      separatorBuilder: (_, __) => const Divider(height: 0, thickness: 1),
                      itemBuilder: (_, i) => ListTile(
                        dense: true,
                        title: Text('Item ${i + 1}'),
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('only single page and single item'),
                  Switch(value: _single, onChanged: (b) => mountedSetState(() => _single = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('disableScrollLess'),
                  Switch(value: _physicsController.disableScrollLess, onChanged: (b) => mountedSetState(() => _physicsController.disableScrollLess = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('disableScrollMore'),
                  Switch(value: _physicsController.disableScrollMore, onChanged: (b) => mountedSetState(() => _physicsController.disableScrollMore = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('hasController'),
                  Switch(value: _hasController, onChanged: (b) => mountedSetState(() => _hasController = b)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
