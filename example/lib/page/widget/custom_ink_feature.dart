import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class CustomInkFeaturePage extends StatefulWidget {
  const CustomInkFeaturePage({Key? key}) : super(key: key);

  @override
  State<CustomInkFeaturePage> createState() => _CustomInkFeaturePageState();
}

class _CustomInkFeaturePageState extends State<CustomInkFeaturePage> {
  static const rDef = CustomInkRippleSetting.defaultSetting;
  static const rPre = CustomInkRippleSetting.preferredSetting;
  static const sDef = CustomInkSplashSetting.defaultSetting;
  static const sPre = CustomInkSplashSetting.preferredSetting;
  var useRipple = true;

  // parameters for CustomInkRippleSetting
  Duration unconfirmedRippleDuration = rDef.unconfirmedRippleDuration;
  Duration unconfirmedFadeInDuration = rDef.unconfirmedFadeInDuration;
  Duration confirmedRippleDuration = rDef.confirmedRippleDuration;
  Duration confirmedFadeoutDuration = rDef.confirmedFadeoutDuration;
  Duration confirmedFadeoutInterval = rDef.confirmedFadeoutInterval;
  Duration canceledFadeOutDuration = rDef.canceledFadeOutDuration;

  // parameters for CustomInkSplashSetting
  Duration unconfirmedSplashDuration = sDef.unconfirmedSplashDuration;
  Duration splashFadeDuration = sDef.splashFadeDuration;
  double splashConfirmedVelocity = sDef.splashConfirmedVelocity;

  Widget _row(Widget w1, Widget w2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [w1, const SizedBox(width: 12), w2],
    );
  }

  Widget _sliderDuration(Duration defaultValue, Duration Function() getter, void Function(Duration) setter, String name) {
    return Row(
      children: [
        Text(name),
        Expanded(
          child: Slider(
            min: 0,
            max: defaultValue.inMilliseconds * 5, // 500%
            value: getter().inMilliseconds.toDouble(),
            onChanged: (v) {
              setter(Duration(milliseconds: v.toInt()));
              if (mounted) setState(() {});
            },
          ),
        ),
        Text('${getter().inMilliseconds.toInt()}ms'),
      ],
    );
  }

  Widget _sliderDouble(double defaultValue, double Function() getter, void Function(double) setter, String name) {
    return Row(
      children: [
        Text(name),
        Expanded(
          child: Slider(
            min: 0,
            max: defaultValue == 0 ? 1 : defaultValue * 5, // 500%
            value: getter(),
            onChanged: (v) {
              setter(v);
              if (mounted) setState(() {});
            },
          ),
        ),
        Text(getter().toStringAsPrecision(2)),
      ],
    );
  }

  InteractiveInkFeatureFactory get factory => useRipple
      ? CustomInkRippleFactory(
          setting: CustomInkRippleSetting.copyWith(
            unconfirmedRippleDuration: unconfirmedRippleDuration,
            unconfirmedFadeInDuration: unconfirmedFadeInDuration,
            confirmedRippleDuration: confirmedRippleDuration,
            confirmedFadeoutDuration: confirmedFadeoutDuration,
            confirmedFadeoutInterval: confirmedFadeoutInterval,
            canceledFadeOutDuration: canceledFadeOutDuration,
          ),
        )
      : CustomInkSplashFactory(
          setting: CustomInkSplashSetting.copyWith(
            unconfirmedSplashDuration: unconfirmedSplashDuration,
            splashFadeDuration: splashFadeDuration,
            splashConfirmedVelocity: splashConfirmedVelocity,
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomInkFeature Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Theme(
            data: ThemeData(
              splashFactory: factory,
              outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(splashFactory: factory)),
              elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(splashFactory: factory)),
              textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(splashFactory: factory)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _row(
                  OutlinedButton(child: const Text('OutlinedButton'), onPressed: () {}),
                  OutlinedButton(child: const Text('Short'), onPressed: () {}),
                ),
                _row(
                  OutlineButton(child: const Text('OutlineButton'), onPressed: () {}), // ignore: deprecated_member_use
                  OutlineButton(child: const Text('Short'), onPressed: () {}), // ignore: deprecated_member_use
                ),
                _row(
                  ElevatedButton(child: const Text('ElevatedButton'), onPressed: () {}),
                  ElevatedButton(child: const Text('Short'), onPressed: () {}),
                ),
                _row(
                  RaisedButton(child: const Text('RaisedButton'), onPressed: () {}), // ignore: deprecated_member_use
                  RaisedButton(child: const Text('Short'), onPressed: () {}), // ignore: deprecated_member_use
                ),
                _row(
                  TextButton(child: const Text('TextButton'), onPressed: () {}),
                  TextButton(child: const Text('Short'), onPressed: () {}),
                ),
                _row(
                  FlatButton(child: const Text('FlatButton'), onPressed: () {}), // ignore: deprecated_member_use
                  FlatButton(child: const Text('Short'), onPressed: () {}), // ignore: deprecated_member_use
                ),
                _row(
                  IconButton(icon: const Text('IconButton'), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.check), onPressed: () {}),
                ),
                _row(
                  MaterialButton(child: const Text('MaterialButton'), onPressed: () {}),
                  MaterialButton(child: const Text('Short'), onPressed: () {}),
                ),
                _row(
                  InkWell(child: const Padding(padding: EdgeInsets.all(10), child: Text('InkWell')), onTap: () {}),
                  InkWell(child: const Padding(padding: EdgeInsets.all(10), child: Text('Short')), onTap: () {}),
                ),
                _row(
                  InkResponse(child: Container(margin: const EdgeInsets.all(10), child: const Text('InkResponse')), onTap: () {}),
                  InkResponse(child: Container(margin: const EdgeInsets.all(10), child: const Text('Short')), onTap: () {}),
                ),
                ListTile(title: const Text('ListTile', textAlign: TextAlign.center), onTap: () {}),
                ListTile(
                  title: const Text('AlertDialog', textAlign: TextAlign.center),
                  onTap: () => showDialog(
                    context: context,
                    builder: (c) => Theme(
                      data: ThemeData(
                        splashFactory: factory,
                        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(splashFactory: factory)),
                      ),
                      child: AlertDialog(
                        title: const Text('Title'),
                        content: const Text('content content content ...'),
                        actions: [
                          TextButton(child: const Text('Yes'), onPressed: () {}),
                          TextButton(child: const Text('No'), onPressed: () {}),
                          TextButton(child: const Text('Cancel'), onPressed: () {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          CheckboxListTile(
            title: const Text('Use Ripple?'),
            controlAffinity: ListTileControlAffinity.leading,
            value: useRipple,
            onChanged: (v) {
              useRipple = v ?? true;
              if (mounted) setState(() {});
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Default'),
                onPressed: () {
                  if (useRipple) {
                    unconfirmedRippleDuration = rDef.unconfirmedRippleDuration;
                    unconfirmedFadeInDuration = rDef.unconfirmedFadeInDuration;
                    confirmedRippleDuration = rDef.confirmedRippleDuration;
                    confirmedFadeoutDuration = rDef.confirmedFadeoutDuration;
                    confirmedFadeoutInterval = rDef.confirmedFadeoutInterval;
                    canceledFadeOutDuration = rDef.canceledFadeOutDuration;
                  } else {
                    unconfirmedSplashDuration = sDef.unconfirmedSplashDuration;
                    splashFadeDuration = sDef.splashFadeDuration;
                    splashConfirmedVelocity = sDef.splashConfirmedVelocity;
                  }
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                child: const Text('Preferred'),
                onPressed: () {
                  if (useRipple) {
                    unconfirmedRippleDuration = rPre.unconfirmedRippleDuration;
                    unconfirmedFadeInDuration = rPre.unconfirmedFadeInDuration;
                    confirmedRippleDuration = rPre.confirmedRippleDuration;
                    confirmedFadeoutDuration = rPre.confirmedFadeoutDuration;
                    confirmedFadeoutInterval = rPre.confirmedFadeoutInterval;
                    canceledFadeOutDuration = rPre.canceledFadeOutDuration;
                  } else {
                    unconfirmedSplashDuration = sPre.unconfirmedSplashDuration;
                    splashFadeDuration = sPre.splashFadeDuration;
                    splashConfirmedVelocity = sPre.splashConfirmedVelocity;
                  }
                  if (mounted) setState(() {});
                },
              )
            ],
          ),
          const Divider(),
          if (useRipple)
            Column(
              children: [
                _sliderDuration(rDef.unconfirmedRippleDuration, () => unconfirmedRippleDuration, (v) => unconfirmedRippleDuration = v, 'unconfirmedRippleDuration'),
                _sliderDuration(rDef.unconfirmedFadeInDuration, () => unconfirmedFadeInDuration, (v) => unconfirmedFadeInDuration = v, 'unconfirmedFadeInDuration'),
                _sliderDuration(rDef.confirmedRippleDuration, () => confirmedRippleDuration, (v) => confirmedRippleDuration = v, 'confirmedRippleDuration'),
                _sliderDuration(rDef.confirmedFadeoutDuration, () => confirmedFadeoutDuration, (v) => confirmedFadeoutDuration = v, 'confirmedFadeoutDuration'),
                _sliderDuration(rDef.confirmedFadeoutInterval, () => confirmedFadeoutInterval, (v) => confirmedFadeoutInterval = v, 'confirmedFadeoutInterval'),
                _sliderDuration(rDef.canceledFadeOutDuration, () => canceledFadeOutDuration, (v) => canceledFadeOutDuration = v, 'canceledFadeOutDuration'),
              ],
            ),
          if (!useRipple)
            Column(
              children: [
                _sliderDuration(sDef.unconfirmedSplashDuration, () => unconfirmedSplashDuration, (v) => unconfirmedSplashDuration = v, 'unconfirmedSplashDuration'),
                _sliderDuration(sDef.splashFadeDuration, () => splashFadeDuration, (v) => splashFadeDuration = v, 'splashFadeDuration'),
                _sliderDouble(sDef.splashConfirmedVelocity, () => splashConfirmedVelocity, (v) => splashConfirmedVelocity = v, 'splashConfirmedVelocity'),
              ],
            ),
        ],
      ),
    );
  }
}
