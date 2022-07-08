import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class LazyIndexedStackPage extends StatefulWidget {
  const LazyIndexedStackPage({Key? key}) : super(key: key);

  @override
  _LazyIndexedStackPageState createState() => _LazyIndexedStackPageState();
}

class _LazyIndexedStackPageState extends State<LazyIndexedStackPage> {
  var _currentIndex = 0;
  final _pages = <Widget>[_PageA(), _PageB(), _PageC()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LazyIndexedStack Example'),
      ),
      body: LazyIndexedStack(
        index: _currentIndex,
        itemCount: _pages.length,
        itemBuilder: (_, i) => _pages[i],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: ['A', 'B', 'C']
            .map(
              (t) => BottomNavigationBarItem(
                icon: const Icon(Icons.chevron_right),
                label: t,
              ),
            )
            .toList(),
        onTap: (index) {
          _currentIndex = index;
          if (mounted) setState(() {});
        },
      ),
    );
  }
}

class _PageA extends StatefulWidget {
  @override
  __PageAState createState() => __PageAState();
}

class __PageAState extends State<_PageA> {
  @override
  void initState() {
    super.initState();
    printLog('initState: A');
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('A'));
  }
}

class _PageB extends StatefulWidget {
  @override
  __PageBState createState() => __PageBState();
}

class __PageBState extends State<_PageB> {
  @override
  void initState() {
    super.initState();
    printLog('initState: B');
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('B'));
  }
}

class _PageC extends StatefulWidget {
  @override
  __PageCState createState() => __PageCState();
}

class __PageCState extends State<_PageC> {
  @override
  void initState() {
    super.initState();
    printLog('initState: C');
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('C'),
    );
  }
}
