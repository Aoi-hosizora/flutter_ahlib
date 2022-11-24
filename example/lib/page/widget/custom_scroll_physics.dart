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
        actions: [
          IconButton(
            icon: const Text('1'),
            onPressed: () {
              _singlePage = true;
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: const Text('4'),
            onPressed: () {
              _singlePage = false;
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: CustomScrollPhysics(
                controller: _physicsController,
              ),
              children: [
                Container(
                  color: Colors.yellow,
                  child: const Center(child: Text('Page 1')),
                ),
                if (!_singlePage) ...[
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
                title: const Text('disableScrollLeft'),
                value: _physicsController.disableScrollLeft,
                onChanged: (v) => mountedSetState(() => _physicsController.disableScrollLeft = v),
              ),
              SwitchListTile(
                title: const Text('disableScrollRight'),
                value: _physicsController.disableScrollRight,
                onChanged: (v) => mountedSetState(() => _physicsController.disableScrollRight = v),
              ),
              SwitchListTile(
                title: const Text('alwaysScrollable'),
                value: _physicsController.alwaysScrollable,
                onChanged: (v) => mountedSetState(() => _physicsController.alwaysScrollable = v),
              ),
              SwitchListTile(
                title: const Text('bouncingScroll'),
                value: _physicsController.bouncingScroll,
                onChanged: (v) => mountedSetState(() => _physicsController.bouncingScroll = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
