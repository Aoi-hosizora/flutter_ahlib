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
  var _disableCanTransitionTo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPageRoute Example'),
      ),
      body: Center(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('disableCanTransitionTo'),
                Switch(value: _disableCanTransitionTo, onChanged: (b) => mountedSetState(() => _disableCanTransitionTo = b)),
              ],
            ),
            const Divider(),
            _TestButtons(
              fullscreenDialog: _fullscreenDialog,
              slowTransition: _slowTransition,
              customBarrierColor: _customBarrierColor,
              disableCanTransitionTo: _disableCanTransitionTo,
            ),
          ],
        ),
      ),
    );
  }
}

class _TestButtons extends StatelessWidget {
  const _TestButtons({
    Key? key,
    required this.fullscreenDialog,
    required this.slowTransition,
    required this.customBarrierColor,
    required this.disableCanTransitionTo,
  }) : super(key: key);

  final bool fullscreenDialog;
  final bool slowTransition;
  final bool customBarrierColor;
  final bool disableCanTransitionTo;

  Widget _routePageBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _TestButtons(
          fullscreenDialog: fullscreenDialog,
          slowTransition: slowTransition,
          customBarrierColor: customBarrierColor,
          disableCanTransitionTo: disableCanTransitionTo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageRouteTheme(
      data: CustomPageRouteThemeData(
        transitionDuration: slowTransition ? const Duration(milliseconds: 1000) : null,
        reverseTransitionDuration: slowTransition ? const Duration(milliseconds: 600) : null,
        barrierColor: customBarrierColor ? Colors.black45 : null,
        barrierCurve: Curves.easeIn,
        disableCanTransitionTo: disableCanTransitionTo,
      ),
      child: Builder(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('Default MaterialPageRoute'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: _routePageBuilder, fullscreenDialog: fullscreenDialog),
              ),
            ),
            OutlinedButton(
              child: const Text('Default CupertinoPageRoute'),
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: _routePageBuilder, fullscreenDialog: fullscreenDialog),
              ),
            ),
            const Divider(),
            OutlinedButton(
              child: const Text('CustomPageRoute FadeUpwardsPageTransitionsBuilder'),
              onPressed: () => Navigator.of(context).push(
                CustomPageRoute(
                  context: context,
                  builder: _routePageBuilder,
                  fullscreenDialog: fullscreenDialog,
                  barrierColor: customBarrierColor ? Colors.black12 : null,
                  transitionsBuilder: const FadeUpwardsPageTransitionsBuilder(),
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('CustomPageRoute OpenUpwardsPageTransitionsBuilder'),
              onPressed: () => Navigator.of(context).push(
                CustomPageRoute(
                  context: context,
                  builder: _routePageBuilder,
                  fullscreenDialog: fullscreenDialog,
                  transitionsBuilder: const OpenUpwardsPageTransitionsBuilder(),
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('CustomPageRoute CupertinoPageTransitionsBuilder'),
              onPressed: () => Navigator.of(context).push(
                CustomPageRoute(
                  context: context,
                  builder: _routePageBuilder,
                  fullscreenDialog: fullscreenDialog,
                  transitionDuration: slowTransition ? null : const Duration(milliseconds: 400),
                  transitionsBuilder: const CupertinoPageTransitionsBuilder(),
                ),
              ),
            ),
            OutlinedButton(
              child: const Text('CustomPageRoute NoPopGestureCupertinoPageTransitionsBuilder'),
              onPressed: () => Navigator.of(context).push(
                CustomPageRoute(
                  context: context,
                  builder: _routePageBuilder,
                  fullscreenDialog: fullscreenDialog,
                  transitionDuration: slowTransition ? null : const Duration(milliseconds: 400),
                  transitionsBuilder: const NoPopGestureCupertinoPageTransitionsBuilder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
