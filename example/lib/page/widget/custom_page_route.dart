import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class CustomPageRoutePage extends StatefulWidget {
  const CustomPageRoutePage({Key? key}) : super(key: key);

  @override
  State<CustomPageRoutePage> createState() => _CustomPageRoutePageState();
}

class _CustomPageRoutePageState extends State<CustomPageRoutePage> {
  var _fullscreenDialog = false;
  var _slowTransition = false;
  var _customBarrierColor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPageRoute Example'),
      ),
      body: CustomPageRouteTheme(
        data: CustomPageRouteThemeData(
          transitionDuration: _slowTransition ? const Duration(milliseconds: 1000) : null,
          reverseTransitionDuration: _slowTransition ? const Duration(milliseconds: 600) : null,
          barrierColor: _customBarrierColor ? Colors.black45 : null,
          barrierCurve: Curves.ease,
        ),
        child: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('fullscreenDialog'),
                    Switch(value: _fullscreenDialog, onChanged: (b) => mountedSetState(() => _fullscreenDialog = b)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('slowTransition'),
                    Switch(value: _slowTransition, onChanged: (b) => mountedSetState(() => _slowTransition = b)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('customBarrierColor'),
                    Switch(value: _customBarrierColor, onChanged: (b) => mountedSetState(() => _customBarrierColor = b)),
                  ],
                ),
                const Divider(),
                OutlinedButton(
                  child: const Text('Default MaterialPageRoute'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => Scaffold(appBar: AppBar()),
                      fullscreenDialog: _fullscreenDialog,
                    ),
                  ),
                ),
                OutlinedButton(
                  child: const Text('Default CupertinoPageRoute'),
                  onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (c) => Scaffold(appBar: AppBar()),
                      fullscreenDialog: _fullscreenDialog,
                    ),
                  ),
                ),
                const Divider(),
                OutlinedButton(
                  child: const Text('CustomPageRoute FadeUpwardsPageTransitionsBuilder'),
                  onPressed: () => Navigator.of(context).push(
                    CustomPageRoute(
                      context: context,
                      builder: (c) => Scaffold(appBar: AppBar()),
                      fullscreenDialog: _fullscreenDialog,
                      barrierColor: _customBarrierColor ? Colors.black12 : null,
                      transitionsBuilder: const FadeUpwardsPageTransitionsBuilder(),
                    ),
                  ),
                ),
                OutlinedButton(
                  child: const Text('CustomPageRoute OpenUpwardsPageTransitionsBuilder'),
                  onPressed: () => Navigator.of(context).push(
                    CustomPageRoute(
                      context: context,
                      builder: (c) => Scaffold(appBar: AppBar()),
                      fullscreenDialog: _fullscreenDialog,
                      transitionsBuilder: const OpenUpwardsPageTransitionsBuilder(),
                    ),
                  ),
                ),
                OutlinedButton(
                  child: const Text('CustomPageRoute CupertinoPageTransitionsBuilder'),
                  onPressed: () => Navigator.of(context).push(
                    CustomPageRoute(
                      context: context,
                      builder: (c) => Scaffold(appBar: AppBar()),
                      fullscreenDialog: _fullscreenDialog,
                      transitionDuration: _slowTransition ? null : const Duration(milliseconds: 400),
                      transitionsBuilder: const CupertinoPageTransitionsBuilder(),
                    ),
                  ),
                ),
                OutlinedButton(
                  child: const Text('CustomPageRoute NoPopGestureCupertinoPageTransitionsBuilder'),
                  onPressed: () => Navigator.of(context).push(
                    CustomPageRoute(
                      context: context,
                      builder: (c) => Scaffold(appBar: AppBar()),
                      fullscreenDialog: _fullscreenDialog,
                      transitionDuration: _slowTransition ? null : const Duration(milliseconds: 400),
                      transitionsBuilder: const NoPopGestureCupertinoPageTransitionsBuilder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
