import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class PlaceholderTextPage extends StatefulWidget {
  const PlaceholderTextPage({Key? key}) : super(key: key);

  @override
  _PlaceholderTextPageState createState() => _PlaceholderTextPageState();
}

class _PlaceholderTextPageState extends State<PlaceholderTextPage> {
  var _state = PlaceholderState.loading;
  var _rule = PlaceholderDisplayRule.dataFirst;

  var _empty = false;
  var _loading = false;
  var _error = false;
  var _custom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlaceholderText Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => mountedSetState(() => _state = PlaceholderState.loading),
          ),
          IconButton(
            icon: const Icon(Icons.error),
            onPressed: () => mountedSetState(() => _state = PlaceholderState.error),
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => mountedSetState(() => _state = PlaceholderState.nothing),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => mountedSetState(() => _state = PlaceholderState.normal),
          ),
        ],
      ),
      body: PlaceholderText(
        state: _state,
        onRefresh: () => printLog('onRefresh'),
        onChanged: (_, __) => printLog('onChanged'),
        childBuilder: (_) => Column(
          children: [
            Expanded(
              child: PlaceholderText.from(
                setting: const PlaceholderSetting().copyWithJapanese().copyWith(
                      customLoadingProgressBuilder: !_custom ? null : (c) => const Text('customLoadingProgress'),
                      customLoadingTextBuilder: !_custom ? null : (c) => const Text('customLoadingText'),
                      customNothingIconBuilder: !_custom ? null : (c) => const Text('customNothingIcon'),
                      customNothingTextBuilder: !_custom ? null : (c) => const Text('customNothingText'),
                      customNothingRetryBuilder: !_custom ? null : (c, callback) => ElevatedButton(child: const Text('customNothingRetry'), onPressed: callback),
                      customErrorIconBuilder: !_custom ? null : (c) => const Text('customErrorIcon'),
                      customErrorTextBuilder: !_custom ? null : (c) => const Text('customErrorText'),
                      customErrorRetryBuilder: !_custom ? null : (c, callback) => ElevatedButton(child: const Text('customErrorRetryBuilder'), onPressed: callback),
                    ),
                isEmpty: _empty,
                isLoading: _loading,
                errorText: _error ? 'エラー' : '',
                displayRule: _rule,
                childBuilder: (_) => const Center(
                  child: SizedBox(
                    width: 300,
                    height: 200,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                  ),
                ),
                onRefresh: () => printLog('onRefresh2'),
                onRetryForError: () => printLog('onRetryForError2'),
                onRetryForNothing: () => printLog('onRetryForNothing2'),
                onChanged: (_, __) => printLog('onChanged2'),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<PlaceholderDisplayRule>(
                    value: _rule,
                    items: PlaceholderDisplayRule.values
                        .map(
                          (s) => DropdownMenuItem<PlaceholderDisplayRule>(
                            child: Text(s.toString(), style: Theme.of(context).textTheme.bodyText2),
                            value: s,
                          ),
                        )
                        .toList(),
                    underline: Container(color: Colors.transparent),
                    onChanged: (v) {
                      if (v != null) {
                        _rule = v;
                        if (mounted) setState(() {});
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('empty'),
                      Switch(value: _empty, onChanged: (b) => mountedSetState(() => _empty = b)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('loading'),
                      Switch(value: _loading, onChanged: (b) => mountedSetState(() => _loading = b)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('error'),
                      Switch(value: _error, onChanged: (b) => mountedSetState(() => _error = b)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('custom'),
                      Switch(value: _custom, onChanged: (b) => mountedSetState(() => _custom = b)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
