import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class AppBarActionButtonPage extends StatefulWidget {
  const AppBarActionButtonPage({Key? key}) : super(key: key);

  @override
  State<AppBarActionButtonPage> createState() => _AppBarActionButtonPageState();
}

class _AppBarActionButtonPageState extends State<AppBarActionButtonPage> {
  var _hasDrawer = true;
  var _hasEndDrawer = true;
  var _useLeading = true;
  var _customSplashRadius = true;
  var _customHighlightColor = true;
  var _forceUseBuilder = true;
  var _allowDrawerButton = true;
  var _allowPopButton = true;

  @override
  Widget build(BuildContext context) {
    return AppBarActionButtonTheme(
      data: AppBarActionButtonThemeData(
        splashRadius: _customSplashRadius ? 20 : null,
        highlightColor: _customHighlightColor ? Colors.transparent : null,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AppBarActionButton example'),
          leading: !_useLeading
              ? null
              : AppBarActionButton.leading(
                  context: context,
                  forceUseBuilder: _forceUseBuilder,
                  allowDrawerButton: _allowDrawerButton,
                  allowPopButton: _allowPopButton,
                ),
          actions: [
            AppBarActionButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => printLog('onPressed 1'),
            ),
            AppBarActionButton(
              icon: const Icon(Icons.lightbulb),
              tooltip: 'tooltip 2',
              onPressed: () => printLog('onPressed 2'),
            ),
            AppBarActionButton(
              icon: const Icon(Icons.fingerprint),
              tooltip: 'no effect 3',
              onPressed: () => printLog('onPressed 3'),
              onLongPress: () => printLog('onLongPress 3'),
            ),
            if (_hasEndDrawer)
              Builder(
                builder: (c) => AppBarActionButton(
                  icon: const Icon(Icons.menu),
                  tooltip: MaterialLocalizations.of(context).showMenuTooltip,
                  onPressed: () => Scaffold.of(c).openEndDrawer(),
                ),
              ),
          ],
        ),
        drawer: !_hasDrawer
            ? null
            : const Drawer(
                child: Center(
                  child: Text('drawer'),
                ),
              ),
        endDrawer: !_hasEndDrawer
            ? null
            : const Drawer(
                child: Center(
                  child: Text('endDrawer'),
                ),
              ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('hasDrawer'),
                  Switch(value: _hasDrawer, onChanged: (b) => mountedSetState(() => _hasDrawer = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('hasEndDrawer'),
                  Switch(value: _hasEndDrawer, onChanged: (b) => mountedSetState(() => _hasEndDrawer = b)),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('useLeading'),
                  Switch(value: _useLeading, onChanged: (b) => mountedSetState(() => _useLeading = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('customSplashRadius'),
                  Switch(value: _customSplashRadius, onChanged: (b) => mountedSetState(() => _customSplashRadius = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('customHighlightColor'),
                  Switch(value: _customHighlightColor, onChanged: (b) => mountedSetState(() => _customHighlightColor = b)),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('forceUseBuilder'),
                  Switch(value: _forceUseBuilder, onChanged: (b) => mountedSetState(() => _forceUseBuilder = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('allowDrawerButton'),
                  Switch(value: _allowDrawerButton, onChanged: (b) => mountedSetState(() => _allowDrawerButton = b)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('allowPopButton'),
                  Switch(value: _allowPopButton, onChanged: (b) => mountedSetState(() => _allowPopButton = b)),
                ],
              ),
              const Divider(),
              OutlinedButton(
                child: const Text('To default'),
                onPressed: () {
                  _hasDrawer = true;
                  _hasEndDrawer = true;
                  _useLeading = true;
                  _customSplashRadius = true;
                  _customHighlightColor = true;
                  _forceUseBuilder = true;
                  _allowDrawerButton = true;
                  _allowPopButton = true;
                  if (mounted) setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
