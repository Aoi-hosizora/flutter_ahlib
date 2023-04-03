import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class WidgetWithCallbackPage extends StatefulWidget {
  const WidgetWithCallbackPage({Key? key}) : super(key: key);

  @override
  State<WidgetWithCallbackPage> createState() => _WidgetWithCallbackPageState();
}

class _WidgetWithCallbackPageState extends State<WidgetWithCallbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WidgetWithCallback Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('all: setState'),
              onPressed: () {
                if (mounted) setState(() {});
              },
            ),
            const Divider(height: 1, thickness: 1),
            StatefulBuilder(
              builder: (_, setState) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatelessWidgetWithCallback(
                    child: const Text('A: StatelessWidgetWithCallback'),
                    buildCallback: (_) => printLog('A: buildCallback'),
                    postFrameCallback: (_) => printLog('A: postFrameCallback'),
                  ),
                  OutlinedButton(
                    child: const Text('A: setState'),
                    onPressed: () => setState(() {}),
                  ),
                ],
              ),
            ),
            StatefulBuilder(
              builder: (_, setState) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatelessWidgetWithCallback.builder(
                    builder: (_) => const Text('B: StatelessWidgetWithCallback.builder'),
                    buildCallback: (_) => printLog('B: buildCallback'),
                    postFrameCallback: (_) => printLog('B: postFrameCallback'),
                  ),
                  OutlinedButton(
                    child: const Text('B: setState'),
                    onPressed: () => setState(() {}),
                  ),
                ],
              ),
            ),
            StatefulBuilder(
              builder: (_, setState) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatefulWidgetWithCallback(
                    child: const Text('C: StatefulWidgetWithCallback'),
                    initStateCallback: (_, __) => printLog('C: initStateCallback'),
                    didChangeDependenciesCallback: (_, __) => printLog('C: didChangeDependenciesCallback'),
                    didUpdateWidgetCallback: (_, __) => printLog('C: didUpdateWidgetCallback'),
                    reassembleCallback: (_, __) => printLog('C: reassembleCallback'),
                    buildCallback: (_, __) => printLog('C: buildCallback'),
                    activateCallback: (_, __) => printLog('C: activateCallback'),
                    deactivateCallback: (_, __) => printLog('C: deactivateCallback'),
                    disposeCallback: (_, __) => printLog('C: disposeCallback'),
                    permanentFrameCallback: null,
                    postFrameCallbackForInitState: (_, __) => printLog('C: postFrameCallbackForInitState'),
                    postFrameCallbackForDidChangeDependencies: (_, __) => printLog('C: postFrameCallbackForDidChangeDependencies'),
                    postFrameCallbackForDidUpdateWidget: (_, __) => printLog('C: postFrameCallbackForDidUpdateWidget'),
                    postFrameCallbackForBuild: (_, __) => printLog('C: postFrameCallbackForBuild'),
                  ),
                  OutlinedButton(
                    child: const Text('C: setState'),
                    onPressed: () => setState(() {}),
                  ),
                ],
              ),
            ),
            StatefulBuilder(
              builder: (_, setState) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatefulWidgetWithCallback.builder(
                    builder: (_, __) => const Text('D: StatefulWidgetWithCallback.builder'),
                    initStateCallback: (_, __) => printLog('D: initStateCallback'),
                    didChangeDependenciesCallback: (_, __) => printLog('D: didChangeDependenciesCallback'),
                    didUpdateWidgetCallback: (_, __) => printLog('D: didUpdateWidgetCallback'),
                    reassembleCallback: (_, __) => printLog('D: reassembleCallback'),
                    buildCallback: (_, __) => printLog('D: buildCallback'),
                    activateCallback: (_, __) => printLog('D: activateCallback'),
                    deactivateCallback: (_, __) => printLog('D: deactivateCallback'),
                    disposeCallback: (_, __) => printLog('D: disposeCallback'),
                    permanentFrameCallback: null,
                    postFrameCallbackForInitState: (_, __) => printLog('D: postFrameCallbackForInitState'),
                    postFrameCallbackForDidChangeDependencies: (_, __) => printLog('D: postFrameCallbackForDidChangeDependencies'),
                    postFrameCallbackForDidUpdateWidget: (_, __) => printLog('D: postFrameCallbackForDidUpdateWidget'),
                    postFrameCallbackForBuild: (_, __) => printLog('D: postFrameCallbackForBuild'),
                  ),
                  OutlinedButton(
                    child: const Text('D: setState'),
                    onPressed: () => setState(() {}),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            toStatefulPageBtn(context, 'from WidgetWithCallbackPage'),
            toStatelessPageBtn(context, 'from WidgetWithCallbackPage'),
          ],
        ),
      ),
    );
  }
}

Widget toStatefulPageBtn(BuildContext context, String hint) => OutlinedButton(
      child: const Text('to StatefulPage'),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => StatefulWidgetWithCallback(
            child: StatefulPage(hint: hint),
            initStateCallback: (_, __) => printLog('StatefulPage: initStateCallback'),
            didChangeDependenciesCallback: (_, __) => printLog('StatefulPage: didChangeDependenciesCallback'),
            didUpdateWidgetCallback: (_, __) => printLog('StatefulPage: didUpdateWidgetCallback'),
            buildCallback: (_, __) => printLog('StatefulPage: buildCallback'),
            activateCallback: (_, __) => printLog('StatefulPage: activateCallback'),
            deactivateCallback: (_, __) => printLog('StatefulPage: deactivateCallback'),
            disposeCallback: (_, __) => printLog('StatefulPage: disposeCallback'),
          ),
        ),
      ),
    );

Widget toStatelessPageBtn(BuildContext context, String hint) => OutlinedButton(
      child: const Text('to StatelessPage'),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => StatelessWidgetWithCallback(
            child: StatelessPage(hint: hint),
            buildCallback: (_) => printLog('StatelessPage: buildCallback'),
          ),
        ),
      ),
    );

class StatefulPage extends StatefulWidget {
  const StatefulPage({
    Key? key,
    required this.hint,
  }) : super(key: key);

  final String hint;

  @override
  State<StatefulPage> createState() => _StatefulPageState();
}

class _StatefulPageState extends State<StatefulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatefulPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('hint: ${widget.hint}'),
            ),
            toStatefulPageBtn(context, '${widget.hint}, from StatefulPage'),
            toStatelessPageBtn(context, '${widget.hint}, from StatefulPage'),
          ],
        ),
      ),
    );
  }
}

class StatelessPage extends StatelessWidget {
  const StatelessPage({
    Key? key,
    required this.hint,
  }) : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatelessPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('hint: $hint'),
            ),
            toStatefulPageBtn(context, '$hint, from StatelessPage'),
            toStatelessPageBtn(context, '$hint, from StatelessPage'),
          ],
        ),
      ),
    );
  }
}
