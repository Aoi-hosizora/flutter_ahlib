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
                    initStateCallback: (_) => printLog('C: initStateCallback'),
                    didChangeDependenciesCallback: (_) => printLog('C: didChangeDependenciesCallback'),
                    didUpdateWidgetCallback: (_) => printLog('C: didUpdateWidgetCallback'),
                    reassembleCallback: (_) => printLog('C: reassembleCallback'),
                    buildCallback: (_) => printLog('C: buildCallback'),
                    activateCallback: (_) => printLog('C: activateCallback'),
                    deactivateCallback: (_) => printLog('C: deactivateCallback'),
                    disposeCallback: (_) => printLog('C: disposeCallback'),
                    permanentFrameCallback: null,
                    postFrameCallbackForInitState: (_) => printLog('C: postFrameCallbackForInitState'),
                    postFrameCallbackForDidChangeDependencies: (_) => printLog('C: postFrameCallbackForDidChangeDependencies'),
                    postFrameCallbackForDidUpdateWidget: (_) => printLog('C: postFrameCallbackForDidUpdateWidget'),
                    postFrameCallbackForBuild: (_) => printLog('C: postFrameCallbackForBuild'),
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
                    initStateCallback: (_) => printLog('D: initStateCallback'),
                    didChangeDependenciesCallback: (_) => printLog('D: didChangeDependenciesCallback'),
                    didUpdateWidgetCallback: (_) => printLog('D: didUpdateWidgetCallback'),
                    reassembleCallback: (_) => printLog('D: reassembleCallback'),
                    buildCallback: (_) => printLog('D: buildCallback'),
                    activateCallback: (_) => printLog('D: activateCallback'),
                    deactivateCallback: (_) => printLog('D: deactivateCallback'),
                    disposeCallback: (_) => printLog('D: disposeCallback'),
                    permanentFrameCallback: null,
                    postFrameCallbackForInitState: (_) => printLog('D: postFrameCallbackForInitState'),
                    postFrameCallbackForDidChangeDependencies: (_) => printLog('D: postFrameCallbackForDidChangeDependencies'),
                    postFrameCallbackForDidUpdateWidget: (_) => printLog('D: postFrameCallbackForDidUpdateWidget'),
                    postFrameCallbackForBuild: (_) => printLog('D: postFrameCallbackForBuild'),
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
            initStateCallback: (_) => printLog('StatefulPage: initStateCallback'),
            didChangeDependenciesCallback: (_) => printLog('StatefulPage: didChangeDependenciesCallback'),
            didUpdateWidgetCallback: (_) => printLog('StatefulPage: didUpdateWidgetCallback'),
            buildCallback: (_) => printLog('StatefulPage: buildCallback'),
            activateCallback: (_) => printLog('StatefulPage: activateCallback'),
            deactivateCallback: (_) => printLog('StatefulPage: deactivateCallback'),
            disposeCallback: (_) => printLog('StatefulPage: disposeCallback'),
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
