import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class CustomScrollPhysicsPage extends StatefulWidget {
  const CustomScrollPhysicsPage({Key? key}) : super(key: key);

  @override
  State<CustomScrollPhysicsPage> createState() => _CustomScrollPhysicsPageState();
}

class _CustomScrollPhysicsPageState extends State<CustomScrollPhysicsPage> {
  final _physicsController = CustomScrollPhysicsController();
  var _singlePage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomScrollPhysics Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: CustomScrollPhysics(
                controller: _physicsController,
              ),
              children: [
                if (_singlePage)
                  Container(
                    color: Colors.grey,
                    child: const Center(child: Text('The only page')),
                  ),
                if (!_singlePage) ...[
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
          Column(
            children: [
              SwitchListTile(
                title: const Text('only single page'),
                value: _singlePage,
                onChanged: (v) => mountedSetState(() => _singlePage = v),
              ),
              SwitchListTile(
                title: const Text('disableScrollLeft'),
                value: _physicsController.disableScrollLeft,
                onChanged: (v) => mountedSetState(() => _physicsController.disableScrollLeft = v),
              ),
              SwitchListTile(
                title: const Text('disableScrollRight'),
                value: _physicsController.disableScrollRight,
                onChanged: (v) => mountedSetState(() => _physicsController.disableScrollRight = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
