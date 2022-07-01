import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class CustomInkRipplePage extends StatefulWidget {
  const CustomInkRipplePage({Key? key}) : super(key: key);

  @override
  State<CustomInkRipplePage> createState() => _CustomInkRipplePageState();
}

class _CustomInkRipplePageState extends State<CustomInkRipplePage> {
  static const DEF = CustomInkRippleSetting.defaultSetting; // ignore: constant_identifier_names
  static const PRE = CustomInkRippleSetting.preferredSetting; // ignore: constant_identifier_names
  var useSplash = false;
  var useValue = true;

  // parameters for copyWith
  Duration unconfirmedRippleDuration = DEF.unconfirmedRippleDuration;
  Duration unconfirmedFadeInDuration = DEF.unconfirmedFadeInDuration;
  Duration confirmedRippleDuration = DEF.confirmedRippleDuration;
  Duration confirmedFadeoutDuration = DEF.confirmedFadeoutDuration;
  Duration confirmedFadeoutInterval = DEF.confirmedFadeoutInterval;
  Duration canceledFadeOutDuration = DEF.canceledFadeOutDuration;

  // parameters for copyWithInScale
  double unconfirmedRippleDurationScale = 1.0;
  double unconfirmedFadeInDurationScale = 1.0;
  double confirmedRippleDurationScale = 1.0;
  double confirmedFadeoutDurationScale = 1.0;
  double confirmedFadeoutIntervalScale = 1.0;
  double canceledFadeOutDurationScale = 1.0;

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

  Widget _sliderScale(double Function() getter, void Function(double) setter, String name) {
    return Row(
      children: [
        Text(name),
        Expanded(
          child: Slider(
            min: 0,
            max: 500, // 500%
            value: getter() * 100,
            onChanged: (v) {
              setter(v / 100);
              if (mounted) setState(() {});
            },
          ),
        ),
        Text(getter().toStringAsFixed(2)),
      ],
    );
  }

  InteractiveInkFeatureFactory get factory => useSplash
      ? InkSplash.splashFactory
      : CustomInkRippleFactory(
          setting: useValue
              ? CustomInkRippleSetting.copyWith(
                  unconfirmedRippleDuration: unconfirmedRippleDuration,
                  unconfirmedFadeInDuration: unconfirmedFadeInDuration,
                  confirmedRippleDuration: confirmedRippleDuration,
                  confirmedFadeoutDuration: confirmedFadeoutDuration,
                  confirmedFadeoutInterval: confirmedFadeoutInterval,
                  canceledFadeOutDuration: canceledFadeOutDuration,
                )
              : CustomInkRippleSetting.copyWithInScale(
                  unconfirmedRippleDurationScale: unconfirmedRippleDurationScale,
                  unconfirmedFadeInDurationScale: unconfirmedFadeInDurationScale,
                  confirmedRippleDurationScale: confirmedRippleDurationScale,
                  confirmedFadeoutDurationScale: confirmedFadeoutDurationScale,
                  confirmedFadeoutIntervalScale: confirmedFadeoutIntervalScale,
                  canceledFadeOutDurationScale: canceledFadeOutDurationScale,
                ),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomInkRipple Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Builder(
            builder: (c) => Theme(
              data: themeDataWithSplashFactory(ThemeData(), factory),
              // data: ThemeData(
              //   splashFactory: factory,
              //   outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(splashFactory: factory)),
              //   elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(splashFactory: factory)),
              //   textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(splashFactory: factory)),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _row(
                    OutlinedButton(child: const Text('OutlinedButton'), onPressed: () {}),
                    OutlinedButton(child: const Text('Short'), onPressed: () {}),
                  ),
                  _row(
                    ElevatedButton(child: const Text('ElevatedButton'), onPressed: () {}),
                    ElevatedButton(child: const Text('Short'), onPressed: () {}),
                  ),
                  _row(
                    TextButton(child: const Text('TextButton'), onPressed: () {}),
                    TextButton(child: const Text('Short'), onPressed: () {}),
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
                    InkResponse(child: const Text('InkResponse'), onTap: () {}),
                    InkResponse(child: const Text('Short'), onTap: () {}),
                  ),
                  ListTile(title: const Text('ListTile', textAlign: TextAlign.center), onTap: () {}),
                ],
              ),
            ),
          ),
          const Divider(),
          CheckboxListTile(
            title: const Text('Use InkSplash'),
            controlAffinity: ListTileControlAffinity.leading,
            value: useSplash,
            onChanged: (v) {
              useSplash = v ?? true;
              if (mounted) setState(() {});
            },
          ),
          if (!useSplash) ...[
            CheckboxListTile(
              title: const Text('Show in duration value'),
              controlAffinity: ListTileControlAffinity.leading,
              value: useValue,
              onChanged: (v) {
                useValue = v ?? true;
                if (useValue) {
                  unconfirmedRippleDuration = DEF.unconfirmedRippleDuration * unconfirmedRippleDurationScale;
                  unconfirmedFadeInDuration = DEF.unconfirmedFadeInDuration * unconfirmedFadeInDurationScale;
                  confirmedRippleDuration = DEF.confirmedRippleDuration * confirmedRippleDurationScale;
                  confirmedFadeoutDuration = DEF.confirmedFadeoutDuration * confirmedFadeoutDurationScale;
                  confirmedFadeoutInterval = DEF.confirmedFadeoutInterval * confirmedFadeoutIntervalScale;
                  canceledFadeOutDuration = DEF.canceledFadeOutDuration * canceledFadeOutDurationScale;
                } else {
                  unconfirmedRippleDurationScale = unconfirmedRippleDuration.inMilliseconds / DEF.unconfirmedRippleDuration.inMilliseconds;
                  unconfirmedFadeInDurationScale = unconfirmedFadeInDuration.inMilliseconds / DEF.unconfirmedFadeInDuration.inMilliseconds;
                  confirmedRippleDurationScale = confirmedRippleDuration.inMilliseconds / DEF.confirmedRippleDuration.inMilliseconds;
                  confirmedFadeoutDurationScale = confirmedFadeoutDuration.inMilliseconds / DEF.confirmedFadeoutDuration.inMilliseconds;
                  confirmedFadeoutIntervalScale = confirmedFadeoutInterval.inMilliseconds / DEF.confirmedFadeoutInterval.inMilliseconds;
                  canceledFadeOutDurationScale = canceledFadeOutDuration.inMilliseconds / DEF.canceledFadeOutDuration.inMilliseconds;
                }
                if (mounted) setState(() {});
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Reset'),
                  onPressed: () {
                    unconfirmedRippleDuration = DEF.unconfirmedRippleDuration;
                    unconfirmedFadeInDuration = DEF.unconfirmedFadeInDuration;
                    confirmedRippleDuration = DEF.confirmedRippleDuration;
                    confirmedFadeoutDuration = DEF.confirmedFadeoutDuration;
                    confirmedFadeoutInterval = DEF.confirmedFadeoutInterval;
                    canceledFadeOutDuration = DEF.canceledFadeOutDuration;
                    unconfirmedRippleDurationScale = 1.0;
                    unconfirmedFadeInDurationScale = 1.0;
                    confirmedRippleDurationScale = 1.0;
                    confirmedFadeoutDurationScale = 1.0;
                    confirmedFadeoutIntervalScale = 1.0;
                    canceledFadeOutDurationScale = 1.0;
                    if (mounted) setState(() {});
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  child: const Text('Preferred'),
                  onPressed: () {
                    unconfirmedRippleDuration = PRE.unconfirmedRippleDuration;
                    unconfirmedFadeInDuration = PRE.unconfirmedFadeInDuration;
                    confirmedRippleDuration = PRE.confirmedRippleDuration;
                    confirmedFadeoutDuration = PRE.confirmedFadeoutDuration;
                    confirmedFadeoutInterval = PRE.confirmedFadeoutInterval;
                    canceledFadeOutDuration = PRE.canceledFadeOutDuration;
                    unconfirmedRippleDurationScale = unconfirmedRippleDuration.inMilliseconds / DEF.unconfirmedRippleDuration.inMilliseconds;
                    unconfirmedFadeInDurationScale = unconfirmedFadeInDuration.inMilliseconds / DEF.unconfirmedFadeInDuration.inMilliseconds;
                    confirmedRippleDurationScale = confirmedRippleDuration.inMilliseconds / DEF.confirmedRippleDuration.inMilliseconds;
                    confirmedFadeoutDurationScale = confirmedFadeoutDuration.inMilliseconds / DEF.confirmedFadeoutDuration.inMilliseconds;
                    confirmedFadeoutIntervalScale = confirmedFadeoutInterval.inMilliseconds / DEF.confirmedFadeoutInterval.inMilliseconds;
                    canceledFadeOutDurationScale = canceledFadeOutDuration.inMilliseconds / DEF.canceledFadeOutDuration.inMilliseconds;
                    if (mounted) setState(() {});
                  },
                )
              ],
            ),
            const Divider(),
            if (useValue)
              Column(
                children: [
                  _sliderDuration(DEF.unconfirmedRippleDuration, () => unconfirmedRippleDuration, (v) => unconfirmedRippleDuration = v, 'unconfirmedRippleDuration'),
                  _sliderDuration(DEF.unconfirmedFadeInDuration, () => unconfirmedFadeInDuration, (v) => unconfirmedFadeInDuration = v, 'unconfirmedFadeInDuration'),
                  _sliderDuration(DEF.confirmedRippleDuration, () => confirmedRippleDuration, (v) => confirmedRippleDuration = v, 'confirmedRippleDuration'),
                  _sliderDuration(DEF.confirmedFadeoutDuration, () => confirmedFadeoutDuration, (v) => confirmedFadeoutDuration = v, 'confirmedFadeoutDuration'),
                  _sliderDuration(DEF.confirmedFadeoutInterval, () => confirmedFadeoutInterval, (v) => confirmedFadeoutInterval = v, 'confirmedFadeoutInterval'),
                  _sliderDuration(DEF.canceledFadeOutDuration, () => canceledFadeOutDuration, (v) => canceledFadeOutDuration = v, 'canceledFadeOutDuration'),
                ],
              ),
            if (!useValue)
              Column(
                children: [
                  _sliderScale(() => unconfirmedRippleDurationScale, (v) => unconfirmedRippleDurationScale = v, 'unconfirmedRippleDuration'),
                  _sliderScale(() => unconfirmedFadeInDurationScale, (v) => unconfirmedFadeInDurationScale = v, 'unconfirmedFadeInDuration'),
                  _sliderScale(() => confirmedRippleDurationScale, (v) => confirmedRippleDurationScale = v, 'confirmedRippleDuration'),
                  _sliderScale(() => confirmedFadeoutDurationScale, (v) => confirmedFadeoutDurationScale = v, 'confirmedFadeoutDuration'),
                  _sliderScale(() => confirmedFadeoutIntervalScale, (v) => confirmedFadeoutIntervalScale = v, 'confirmedFadeoutInterval'),
                  _sliderScale(() => canceledFadeOutDurationScale, (v) => canceledFadeOutDurationScale = v, 'canceledFadeOutDuration'),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
