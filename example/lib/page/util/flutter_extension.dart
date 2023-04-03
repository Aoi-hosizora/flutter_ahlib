import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class FlutterExtensionPage extends StatefulWidget {
  const FlutterExtensionPage({Key? key}) : super(key: key);

  @override
  State<FlutterExtensionPage> createState() => _FlutterExtensionPageState();
}

class _FlutterExtensionPageState extends State<FlutterExtensionPage> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(vsync: this, length: 4);
  final _tabs = const [
    Tab(text: 'Scrollable related'),
    Tab(text: 'PageView related'),
    Tab(text: 'RenderObject related'),
    Tab(text: 'BuildContext related'),
  ];
  final _pages = const [
    _Page1(),
    _Page2(),
    _Page3(),
    _Page4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterExtension Example'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages,
      ),
    );
  }
}

Widget _fab({required IconData icon, required VoidCallback onPressed}) {
  return FloatingActionButton(
    child: Icon(icon),
    heroTag: null,
    mini: true,
    onPressed: onPressed,
  );
}

class _Page1 extends StatefulWidget {
  const _Page1({Key? key}) : super(key: key);

  @override
  State<_Page1> createState() => _Page1State();
}

class _Page1State extends State<_Page1> {
  final _scrollController = ScrollController();
  var _lessItems = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        interactive: true,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _lessItems ? 5 : 50,
          itemBuilder: (_, i) => ListTile(
            title: Text('$i'),
            onTap: () {},
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _fab(
            icon: _lessItems ? Icons.add : Icons.remove,
            onPressed: () => mountedSetState(() => _lessItems = !_lessItems),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.vertical_align_top,
            onPressed: () => _scrollController.scrollToTop(),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.vertical_align_bottom,
            onPressed: () => _scrollController.scrollToBottom(),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.keyboard_arrow_up,
            onPressed: () => _scrollController.scrollLess(),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.keyboard_arrow_down,
            onPressed: () => _scrollController.scrollMore(),
          ),
          const SizedBox(height: 6),
          _fab(
            icon: Icons.check,
            onPressed: () {
              var msg = 'check:';
              if (_scrollController.position.isShortScrollArea()) {
                msg += ' isShortScrollArea';
              }
              if (_scrollController.position.atTopEdge()) {
                msg += ' atTopEdge';
              }
              if (_scrollController.position.atBottomEdge()) {
                msg += ' atBottomEdge';
              }
              if (_scrollController.isScrollOver(0)) {
                msg += ' isScrollOver_0';
              }
              if (_scrollController.isScrollOver(1000)) {
                msg += ' isScrollOver_1000';
              }
              if (_scrollController.isScrollOver(double.infinity, maxScrollExtentError: 0.998)) {
                msg += ' isScrollOver_0.998_inf';
              }
              printLog(msg);
            },
          ),
        ],
      ),
    );
  }
}

class _Page2 extends StatefulWidget {
  const _Page2({Key? key}) : super(key: key);

  @override
  State<_Page2> createState() => _Page2State();
}

class _Page2State extends State<_Page2> {
  final _pageController = PageController();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const itemCount = 30;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (_) => mountedSetState(() {}),
              itemCount: itemCount,
              itemBuilder: (_, i) => Center(
                child: Text('$i'),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Text(
              '${!_pageController.hasClients ? 0 : _pageController.page?.round() ?? 0}/${itemCount - 1}',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      floatingActionButton: _fab(
        icon: Icons.arrow_right_alt,
        onPressed: () {
          showDialog(
            context: context,
            builder: (c) => SimpleDialog(
              title: const Text('Jump to / Animate to'),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(isDense: true),
                  ),
                ),
                TextDialogOption(
                  text: const Text('jumpTo'),
                  onPressed: () async {
                    Navigator.of(c).pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    _pageController.jumpTo(double.tryParse(_textController.text) ?? 0);
                  },
                ),
                TextDialogOption(
                  text: const Text('jumpToPage'),
                  onPressed: () async {
                    Navigator.of(c).pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    _pageController.jumpToPage(int.tryParse(_textController.text) ?? 0);
                  },
                ),
                TextDialogOption(
                  text: const Text('animateTo (easeOutQuad)'),
                  onPressed: () async {
                    Navigator.of(c).pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    _pageController.animateTo(double.tryParse(_textController.text) ?? 0, curve: Curves.easeOutQuad, duration: kTabScrollDuration);
                  },
                ),
                TextDialogOption(
                  text: const Text('animateToPage (easeOutQuad)'),
                  onPressed: () async {
                    Navigator.of(c).pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    _pageController.animateToPage(int.tryParse(_textController.text) ?? 0, curve: Curves.easeOutQuad, duration: kTabScrollDuration);
                  },
                ),
                TextDialogOption(
                  text: const Text('defaultAnimateTo'),
                  onPressed: () async {
                    Navigator.of(c).pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    _pageController.defaultAnimateTo(double.tryParse(_textController.text) ?? 0);
                  },
                ),
                TextDialogOption(
                  text: const Text('defaultAnimateToPage'),
                  onPressed: () async {
                    Navigator.of(c).pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    _pageController.defaultAnimateToPage(int.tryParse(_textController.text) ?? 0);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Page3 extends StatefulWidget {
  const _Page3({Key? key}) : super(key: key);

  @override
  State<_Page3> createState() => _Page3State();
}

class _Page3State extends State<_Page3> {
  final _ctnrKeys = List.generate(5, (_) => GlobalKey<State<StatefulWidget>>());
  var _showInList = false;

  Widget _block(double? l, double? t, double? r, double? b, int number) {
    return Positioned(
      left: l,
      top: t,
      right: r,
      bottom: b,
      child: Container(
        key: _ctnrKeys[number],
        width: 50,
        height: 50,
        alignment: Alignment.center,
        color: Colors.red,
        child: Text('$number'),
      ),
    );
  }

  Widget _line(int number) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 200),
        key: _ctnrKeys[number],
        width: 100,
        height: 100,
        alignment: Alignment.center,
        color: Colors.red,
        child: Text('$number'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_showInList
          ? Stack(
              children: [
                _block(50, 50, null, null, 0),
                _block(null, 50, 50, null, 1),
                _block(50, null, null, 50, 2),
                _block(null, null, 50, 50, 3),
                Center(
                  child: Container(
                    key: _ctnrKeys[4],
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    color: Colors.red,
                    child: const Text('4'),
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTapDown: (d) => printLog('global ${d.globalPosition} local ${d.localPosition}'),
                  ),
                ),
              ],
            )
          : Listener(
              onPointerDown: (d) => printLog('global ${d.position} local ${d.localPosition}'),
              child: ListView(
                children: [
                  _line(0),
                  _line(1),
                  _line(2),
                  _line(3),
                  _line(4),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _fab(
            icon: Icons.check,
            onPressed: () {
              var renderObjects = _ctnrKeys.map((k) => k.currentContext?.findRenderObject()).toList();
              printLog('MediaQuery top padding: ${MediaQuery.of(context).padding.top}, kToolbarHeight: $kToolbarHeight, kTextTabBarHeight: $kTextTabBarHeight');
              printLog('Rect0: root => ${renderObjects[0]?.getBoundInAncestorCoordinate()}, page => ${renderObjects[0]?.getBoundInAncestorCoordinate(context.findRenderObject())}');
              printLog('Rect1: root => ${renderObjects[1]?.getBoundInAncestorCoordinate()}, page => ${renderObjects[1]?.getBoundInAncestorCoordinate(context.findRenderObject())}');
              printLog('Rect2: root => ${renderObjects[2]?.getBoundInAncestorCoordinate()}, page => ${renderObjects[2]?.getBoundInAncestorCoordinate(context.findRenderObject())}');
              printLog('Rect3: root => ${renderObjects[3]?.getBoundInAncestorCoordinate()}, page => ${renderObjects[3]?.getBoundInAncestorCoordinate(context.findRenderObject())}');
              printLog('Rect4: root => ${renderObjects[4]?.getBoundInAncestorCoordinate()}, page => ${renderObjects[4]?.getBoundInAncestorCoordinate(context.findRenderObject())}');
            },
          ),
          _fab(
            icon: _showInList ? Icons.list : Icons.grid_view,
            onPressed: () => mountedSetState(() => _showInList = !_showInList),
          ),
        ],
      ),
    );
  }
}

class SampleText extends Text {
  const SampleText(String data, {Key? key}) : super(data, key: key);
}

class _Page4 extends StatefulWidget {
  const _Page4({Key? key}) : super(key: key);

  @override
  State<_Page4> createState() => _Page4State();
}

class _Page4State extends State<_Page4> {
  var _text = '';

  SampleText? _checker(Element el) {
    var type = el.widget.runtimeType.toString();
    if (!type.startsWith('_')) {
      _text += '$type\n';
    }
    return el.widget.asIf<SampleText>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SampleText('test 1'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SampleText('test 2'),
                const Text(' '),
                Row(
                  children: const [
                    SampleText('test 3'),
                    Text(' '),
                    SampleText('test 4'),
                  ],
                ),
              ],
            ),
            const Divider(),
            OutlinedButton(
              child: const Text('Find all texts (DFS)'),
              onPressed: () {
                _text = 'DFS all:\n';
                var found = context.findDescendantElementsDFS<SampleText>(-1, _checker);
                printLog('$_text${_text.split('\n').length}');
                printLog('found texts: ' + (found.map((w) => '"${w.data}"')).join(' | '));
              },
            ),
            const SizedBox(height: 4),
            OutlinedButton(
              child: const Text('Find all texts (BFS)'),
              onPressed: () {
                _text = 'BFS all:\n';
                var found = context.findDescendantElementsBFS<SampleText>(-1, _checker);
                printLog('$_text${_text.split('\n').length}');
                printLog('found texts: ' + (found.map((w) => '"${w.data}"')).join(' | '));
              },
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              child: const Text('Find first 5 texts (DFS)'),
              onPressed: () {
                _text = 'DFS 5:\n';
                var found = context.findDescendantElementsDFS<SampleText>(5, _checker);
                printLog('$_text${_text.split('\n').length}');
                printLog('found texts: ' + (found.map((w) => '"${w.data}"')).join(' | '));
              },
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              child: const Text('Find first 5 texts (BFS)'),
              onPressed: () {
                _text = 'BFS 5:\n';
                var found = context.findDescendantElementsBFS<SampleText>(5, _checker);
                printLog('$_text${_text.split('\n').length}');
                printLog('found texts: ' + (found.map((w) => '"${w.data}"')).join(' | '));
              },
            ),
            const SizedBox(height: 4),
            TextButton(
              child: const Text('find the first text (DFS)'),
              onPressed: () {
                _text = 'DFS 1:\n';
                var textWidget = context.findDescendantElementDFS<SampleText>(_checker);
                printLog('$_text${_text.split('\n').length}');
                printLog('found text: "${textWidget?.data}"');
              },
            ),
            const SizedBox(height: 4),
            TextButton(
              child: const Text('find the first text (BFS)'),
              onPressed: () {
                _text = 'BFS 1:\n';
                var textWidget = context.findDescendantElementBFS<SampleText>(_checker);
                printLog('$_text${_text.split('\n').length}');
                printLog('found text: "${textWidget?.data}"');
              },
            ),
            const Divider(),
            const SampleText('test 5'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SampleText('test 6'),
                const Text(' '),
                Row(
                  children: const [
                    SampleText('test 7'),
                    Text(' '),
                    SampleText('test 8'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
