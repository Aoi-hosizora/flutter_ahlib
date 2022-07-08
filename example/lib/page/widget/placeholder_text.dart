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

  var _empty = false;
  var _loading = false;
  var _error = false;

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
            icon: const Icon(Icons.check),
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
                setting: const PlaceholderSetting().copyWithJapanese(),
                isEmpty: _empty,
                isLoading: _loading,
                errorText: _error ? 'エラー' : '',
                childBuilder: (_) => const Center(
                  child: Icon(Icons.check),
                ),
                onRefresh: () => printLog('onRefresh2'),
                onChanged: (_, __) => printLog('onChanged2'),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('empty'),
                  Switch(value: _empty, onChanged: (b) => mountedSetState(() => _empty = b)),
                  const Text('loading'),
                  Switch(value: _loading, onChanged: (b) => mountedSetState(() => _loading = b)),
                  const Text('error'),
                  Switch(value: _error, onChanged: (b) => mountedSetState(() => _error = b)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
