import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ExtendedTabBarViewPage extends StatefulWidget {
  const ExtendedTabBarViewPage({Key? key}) : super(key: key);

  @override
  State<ExtendedTabBarViewPage> createState() => _ExtendedTabBarViewPageState();
}

class _ExtendedTabBarViewPageState extends State<ExtendedTabBarViewPage> with SingleTickerProviderStateMixin {
  final _key = GlobalKey<ExtendedTabBarViewState>();
  late final _controller = TabController(length: 5, vsync: this);

  var _viewportFraction = false;
  var _padEnds = true;
  var _warpTabIndex = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExtendedTabBarView Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _key.currentState?.pageController.animateToPage(
                2, // page 3
                duration: const Duration(seconds: 2),
                curve: Curves.linear,
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: [
            for (var i = 1; i <= 5; i++) Tab(text: 'Tab$i'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ExtendedTabBarView(
              key: _key,
              controller: _controller,
              viewportFraction: _viewportFraction ? 0.8 : 1.0,
              padEnds: _padEnds,
              warpTabIndex: _warpTabIndex,
              children: [
                for (var i = 1; i <= 5; i++)
                  Container(
                    color: [Colors.yellow, Colors.pink, Colors.cyan, Colors.green, Colors.purple][i - 1],
                    child: Center(
                      child: Text(
                        'Page$i',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('viewportFraction'),
                  Switch(value: _viewportFraction, onChanged: (b) => mountedSetState(() => _viewportFraction = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('padEnds'),
                  Switch(value: _padEnds, onChanged: (b) => mountedSetState(() => _padEnds = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('warpTabIndex'),
                  Switch(value: _warpTabIndex, onChanged: (b) => mountedSetState(() => _warpTabIndex = b)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
