import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class PlaceholderTextPage extends StatefulWidget {
  const PlaceholderTextPage({Key key}) : super(key: key);

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
        title: Text('PlaceholderText Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => mountedSetState(() => _state = PlaceholderState.loading),
          ),
          IconButton(
            icon: Icon(Icons.error),
            onPressed: () => mountedSetState(() => _state = PlaceholderState.error),
          ),
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () => mountedSetState(() => _state = PlaceholderState.nothing),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => mountedSetState(() => _state = PlaceholderState.normal),
          ),
        ],
      ),
      body: PlaceholderText(
        state: _state,
        onRefresh: () => print('onRefresh'),
        onChanged: (_, __) => print('onChanged'),
        childBuilder: (_) => Column(
          children: [
            Expanded(
              child: PlaceholderText.from(
                setting: PlaceholderSetting().toJapanese(),
                isEmpty: _empty,
                isLoading: _loading,
                errorText: _error ? 'error' : '',
                childBuilder: (_) => Center(
                  child: Icon(Icons.check),
                ),
                onRefresh: () => print('onRefresh2'),
                onChanged: (_, __) => print('onChanged2'),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('empty'),
                  Switch(value: _empty, onChanged: (b) => mountedSetState(() => _empty = b)),
                  Text('loading'),
                  Switch(value: _loading, onChanged: (b) => mountedSetState(() => _loading = b)),
                  Text('error'),
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
