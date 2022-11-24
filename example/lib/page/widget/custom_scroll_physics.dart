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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('only single page'),
                  Switch(value: _singlePage, onChanged: (b) => mountedSetState(() => _singlePage = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('disableScrollLeft'),
                  Switch(value: _physicsController.disableScrollLeft, onChanged: (b) => mountedSetState(() => _physicsController.disableScrollLeft = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('disableScrollRight'),
                  Switch(value: _physicsController.disableScrollRight, onChanged: (b) => mountedSetState(() => _physicsController.disableScrollRight = b)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
