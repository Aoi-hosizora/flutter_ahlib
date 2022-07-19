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
                    buildCallback: () => printLog('A: buildCallback'),
                    postFrameCallback: () => printLog('A: postFrameCallback'),
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
                    buildCallback: () => printLog('B: buildCallback'),
                    postFrameCallback: () => printLog('B: postFrameCallback'),
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
                    initStateCallback: () => printLog('C: initStateCallback'),
                    didChangeDependenciesCallback: () => printLog('C: didChangeDependenciesCallback'),
                    didUpdateWidgetCallback: () => printLog('C: didUpdateWidgetCallback'),
                    reassembleCallback: () => printLog('C: reassembleCallback'),
                    buildCallback: () => printLog('C: buildCallback'),
                    activateCallback: () => printLog('C: activateCallback'),
                    deactivateCallback: () => printLog('C: deactivateCallback'),
                    disposeCallback: () => printLog('C: disposeCallback'),
                    permanentFrameCallback: null,
                    postFrameCallbackForInitState: () => printLog('C: postFrameCallbackForInitState'),
                    postFrameCallbackForDidChangeDependencies: () => printLog('C: postFrameCallbackForDidChangeDependencies'),
                    postFrameCallbackForDidUpdateWidget: () => printLog('C: postFrameCallbackForDidUpdateWidget'),
                    postFrameCallbackForBuild: () => printLog('C: postFrameCallbackForBuild'),
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
                    initStateCallback: () => printLog('D: initStateCallback'),
                    didChangeDependenciesCallback: () => printLog('D: didChangeDependenciesCallback'),
                    didUpdateWidgetCallback: () => printLog('D: didUpdateWidgetCallback'),
                    reassembleCallback: () => printLog('D: reassembleCallback'),
                    buildCallback: () => printLog('D: buildCallback'),
                    activateCallback: () => printLog('D: activateCallback'),
                    deactivateCallback: () => printLog('D: deactivateCallback'),
                    disposeCallback: () => printLog('D: disposeCallback'),
                    permanentFrameCallback: null,
                    postFrameCallbackForInitState: () => printLog('D: postFrameCallbackForInitState'),
                    postFrameCallbackForDidChangeDependencies: () => printLog('D: postFrameCallbackForDidChangeDependencies'),
                    postFrameCallbackForDidUpdateWidget: () => printLog('D: postFrameCallbackForDidUpdateWidget'),
                    postFrameCallbackForBuild: () => printLog('D: postFrameCallbackForBuild'),
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
            initStateCallback: () => printLog('StatefulPage: initStateCallback'),
            didChangeDependenciesCallback: () => printLog('StatefulPage: didChangeDependenciesCallback'),
            didUpdateWidgetCallback: () => printLog('StatefulPage: didUpdateWidgetCallback'),
            buildCallback: () => printLog('StatefulPage: buildCallback'),
            activateCallback: () => printLog('StatefulPage: activateCallback'),
            deactivateCallback: () => printLog('StatefulPage: deactivateCallback'),
            disposeCallback: () => printLog('StatefulPage: disposeCallback'),
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
            buildCallback: () => printLog('StatelessPage: buildCallback'),
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
