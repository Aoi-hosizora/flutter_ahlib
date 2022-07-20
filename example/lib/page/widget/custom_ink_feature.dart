import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class CustomInkFeaturePage extends StatefulWidget {
  const CustomInkFeaturePage({Key? key}) : super(key: key);

  @override
  State<CustomInkFeaturePage> createState() => _CustomInkFeaturePageState();
}

CustomInkRippleSetting get rDef => CustomInkRippleSetting.defaultSetting;

CustomInkRippleSetting get rPre => CustomInkRippleSetting.preferredSetting;

CustomInkSplashSetting get sDef => CustomInkSplashSetting.defaultSetting;

CustomInkSplashSetting get sPre => CustomInkSplashSetting.preferredSetting;

// ignore_for_file: deprecated_member_use

class _CustomInkFeaturePageState extends State<CustomInkFeaturePage> {
  var useRipple = true;
  late CustomInkRippleSetting _r = rDef;
  late CustomInkSplashSetting _s = sDef;

  Widget _row(Widget w1, Widget w2, [Widget? w3]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        w1,
        const SizedBox(width: 12),
        w2,
        if (w3 != null) const SizedBox(width: 12),
        if (w3 != null) w3,
      ],
    );
  }

  Widget _sliderDuration(Duration defaultValue, Duration Function() getter, void Function(Duration) setter, String name, {double? min, double? max}) {
    return Row(
      children: [
        Text(name),
        Expanded(
          child: Slider(
            min: min ?? 0,
            max: max ?? defaultValue.inMilliseconds * 5,
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

  Widget _sliderBool(bool defaultValue, bool Function() getter, void Function(bool) setter, String name) {
    return Row(
      children: [
        Text(name),
        Expanded(
          child: Slider(
            min: 0,
            max: 1,
            value: getter() ? 1 : 0,
            onChanged: (v) {
              setter(v != 0);
              if (mounted) setState(() {});
            },
          ),
        ),
        Text(getter() ? 'true' : 'false'),
      ],
    );
  }

  Widget _sliderDouble(double defaultValue, double Function() getter, void Function(double) setter, String name, {double? min, double? max}) {
    return Row(
      children: [
        Text(name),
        Expanded(
          child: Slider(
            min: min ?? 0,
            max: max ?? defaultValue * 5,
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

  ThemeData get themeData {
    var factory = useRipple ? CustomInkRippleFactory(setting: _r) : CustomInkSplashFactory(setting: _s);
    return ThemeData(
      splashFactory: factory,
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(splashFactory: factory)),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(splashFactory: factory)),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(splashFactory: factory)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomInkFeature Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
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
                child: const Text('To default'),
                onPressed: () {
                  if (useRipple) {
                    _r = rDef;
                  } else {
                    _s = sDef;
                  }
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                child: const Text('To preferred'),
                onPressed: () {
                  if (useRipple) {
                    _r = rPre;
                  } else {
                    _s = sPre;
                  }
                  if (mounted) setState(() {});
                },
              ),
            ],
          ),
          const Divider(),
          if (useRipple)
            Column(
              children: [
                _sliderDuration(rDef.unconfirmedRippleDuration, () => _r.unconfirmedRippleDuration, (v) => _r = _r.copyWith(unconfirmedRippleDuration: v), 'unconfirmedRippleDuration', max: 2500), // 1000 -> 300
                _sliderDuration(rDef.unconfirmedFadeInDuration, () => _r.unconfirmedFadeInDuration, (v) => _r = _r.copyWith(unconfirmedFadeInDuration: v), 'unconfirmedFadeInDuration'), // 75 -> 75
                _sliderDuration(rDef.confirmedRippleDuration, () => _r.confirmedRippleDuration, (v) => _r = _r.copyWith(confirmedRippleDuration: v), 'confirmedRippleDuration'), // 225 -> 200
                _sliderDuration(rDef.confirmedFadeOutDuration, () => _r.confirmedFadeOutDuration, (v) => _r = _r.copyWith(confirmedFadeOutDuration: v), 'confirmedFadeOutDuration'), // 150 -> 150
                _sliderDuration(rDef.confirmedFadeOutInterval, () => _r.confirmedFadeOutInterval, (v) => _r = _r.copyWith(confirmedFadeOutInterval: v), 'confirmedFadeOutInterval'), // 225 -> 20
                _sliderBool(rDef.confirmedFadeOutWaitForForwarding, () => _r.confirmedFadeOutWaitForForwarding, (v) => _r = _r.copyWith(confirmedFadeOutWaitForForwarding: v), 'confirmedFadeOutWaitForForwarding'), // false -> true
                _sliderDuration(rDef.canceledFadeOutDuration, () => _r.canceledFadeOutDuration, (v) => _r = _r.copyWith(canceledFadeOutDuration: v), 'canceledFadeOutDuration'), // 75 -> 125
                _sliderDouble(0.3, () => (_r.radiusAnimationBeginFn ?? (r) => r * 0.3)(1), (v) => _r = _r.copyWith(radiusAnimationBeginFn: (r) => r * v), 'radiusAnimationBegin (*)', max: 0.5), // r * 0.3 -> r * 0.15
                _sliderDouble(5.0, () => (_r.radiusAnimationEndFn ?? (r) => r + 5.0)(0), (v) => _r = _r.copyWith(radiusAnimationEndFn: (r) => r + v), 'radiusAnimationEnd (+)', min: -10, max: 10), // r + 5.0 -> r
              ],
            ),
          if (!useRipple)
            Column(
              children: [
                _sliderDuration(sDef.unconfirmedSplashDuration, () => _s.unconfirmedSplashDuration, (v) => _s = _s.copyWith(unconfirmedSplashDuration: v), 'unconfirmedSplashDuration', max: 2500), // 1000 -> 300
                _sliderDouble(sDef.confirmedSplashVelocity, () => _s.confirmedSplashVelocity, (v) => _s = _s.copyWith(confirmedSplashVelocity: v), 'confirmedSplashVelocity'), // 1.0 -> 0.5
                _sliderDuration(sDef.confirmedFadeOutDuration, () => _s.confirmedFadeOutDuration, (v) => _s = _s.copyWith(confirmedFadeOutDuration: v), 'confirmedFadeOutDuration'), // 200 -> 200
                _sliderDuration(sDef.confirmedFadeOutInterval, () => _s.confirmedFadeOutInterval, (v) => _s = _s.copyWith(confirmedFadeOutInterval: v), 'confirmedFadeOutInterval', max: 500), // 0 -> 125
              ],
            ),
          const Divider(),
          Theme(
            data: themeData,
            child: Builder(
              builder: (c) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _row(
                    OutlinedButton(child: const Text('OutlinedButton'), onPressed: () {}),
                    OutlinedButton(child: const Text('Short'), onPressed: () {}),
                  ),
                  _row(
                    OutlineButton(child: const Text('OutlineButton'), onPressed: () {}),
                    OutlineButton(child: const Text('Short'), onPressed: () {}),
                    OutlineButton(child: const Text('No HlColor'), onPressed: () {}, highlightColor: Colors.transparent),
                  ),
                  _row(
                    ElevatedButton(child: const Text('ElevatedButton'), onPressed: () {}),
                    ElevatedButton(child: const Text('Short'), onPressed: () {}),
                  ),
                  _row(
                    RaisedButton(child: const Text('RaisedButton'), onPressed: () {}),
                    RaisedButton(child: const Text('Short'), onPressed: () {}),
                    RaisedButton(child: const Text('No HlColor'), onPressed: () {}, highlightColor: Colors.transparent),
                  ),
                  _row(
                    TextButton(child: const Text('TextButton'), onPressed: () {}),
                    TextButton(child: const Text('Short'), onPressed: () {}),
                  ),
                  _row(
                    FlatButton(child: const Text('FlatButton'), onPressed: () {}),
                    FlatButton(child: const Text('Short'), onPressed: () {}),
                    FlatButton(child: const Text('No HlColor'), onPressed: () {}, highlightColor: Colors.transparent),
                  ),
                  _row(
                    IconButton(icon: const Text('IconButton'), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.check), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.done_all), onPressed: () {}, highlightColor: Colors.transparent),
                  ),
                  _row(
                    MaterialButton(child: const Text('MaterialButton'), onPressed: () {}),
                    MaterialButton(child: const Text('Short'), onPressed: () {}),
                    MaterialButton(child: const Text('No HlColor'), onPressed: () {}, highlightColor: Colors.transparent),
                  ),
                  _row(
                    InkWell(child: const Padding(padding: EdgeInsets.all(15), child: Text('InkWell')), onTap: () {}),
                    InkWell(child: const Padding(padding: EdgeInsets.all(15), child: Text('Short')), onTap: () {}),
                    InkWell(child: const Padding(padding: EdgeInsets.all(15), child: Text('No HlColor')), onTap: () {}, highlightColor: Colors.transparent),
                  ),
                  const Divider(height: 1, thickness: 1),
                  SizedBox(width: double.infinity, child: InkWell(child: const Padding(padding: EdgeInsets.all(3), child: Text('Thin InkWell', textAlign: TextAlign.center)), onTap: () {})),
                  const Divider(height: 0, thickness: 1),
                  _row(
                    InkResponse(child: Container(margin: const EdgeInsets.all(15), child: const Text('InkResponse')), onTap: () {}),
                    InkResponse(child: Container(margin: const EdgeInsets.all(15), child: const Text('Short')), onTap: () {}),
                    InkResponse(child: Container(margin: const EdgeInsets.all(15), child: const Text('No HlColor')), onTap: () {}, highlightColor: Colors.transparent),
                  ),
                  const Divider(height: 1, thickness: 1),
                  SizedBox(width: double.infinity, child: InkResponse(child: const Padding(padding: EdgeInsets.all(3), child: Text('Thin InkResponse', textAlign: TextAlign.center)), onTap: () {})),
                  const Divider(height: 0, thickness: 1),
                  _row(
                    Expanded(flex: 3, child: ListTile(title: const Text('ListTile', textAlign: TextAlign.center), onTap: () {})),
                    Expanded(flex: 1, child: Card(child: ListTile(title: const Text('Card', textAlign: TextAlign.center), onTap: () {}))),
                  ),
                  ListTile(
                    title: const Text('AlertDialog', textAlign: TextAlign.center),
                    onTap: () => showDialog(
                      context: c,
                      builder: (c) => AlertDialog(
                        title: const Text('Title'),
                        content: const Text('content content content ...'),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(child: const Text('Yes'), onPressed: () {}),
                              TextButton(child: const Text('No'), onPressed: () {}),
                              TextButton(child: const Text('Cancel'), onPressed: () {}),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(child: const Text('Yes'), onPressed: () {}, highlightColor: Colors.transparent),
                              FlatButton(child: const Text('No'), onPressed: () {}, highlightColor: Colors.transparent),
                              FlatButton(child: const Text('Cancel'), onPressed: () {}, highlightColor: Colors.transparent),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
