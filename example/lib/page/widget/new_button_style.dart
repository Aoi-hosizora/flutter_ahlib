import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class NewButtonThemePage extends StatefulWidget {
  const NewButtonThemePage({Key? key}) : super(key: key);

  @override
  State<NewButtonThemePage> createState() => _NewButtonThemePageState();
}

enum InkFeature {
  defaultInkRipple,
  preferredInkRipple,
  defaultInkSplash,
  preferredInkSplash,
}

// ignore_for_file: deprecated_member_use

class _NewButtonThemePageState extends State<NewButtonThemePage> {
  InkFeature? _inkFeature = InkFeature.defaultInkRipple;

  Widget _radio(InkFeature value, String title) {
    return ListTile(
      title: Text(title),
      leading: Radio<InkFeature>(
        value: value,
        groupValue: _inkFeature,
        onChanged: (v) {
          _inkFeature = v;
          if (mounted) setState(() {});
        },
      ),
      onTap: () {
        _inkFeature = value;
        if (mounted) setState(() {});
      },
    );
  }

  Widget _row(Widget w1, Widget w2, [Widget? w3, Widget? w4]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        w1,
        const SizedBox(width: 8),
        w2,
        if (w3 != null) const SizedBox(width: 8),
        if (w3 != null) w3,
        if (w4 != null) const SizedBox(width: 8),
        if (w4 != null) w4,
      ],
    );
  }

  ThemeData get themeData {
    InteractiveInkFeatureFactory factory;
    switch (_inkFeature) {
      case InkFeature.defaultInkRipple:
      case null:
        factory = InkRipple.splashFactory;
        break;
      case InkFeature.preferredInkRipple:
        factory = CustomInkRipple.preferredSplashFactory;
        break;
      case InkFeature.defaultInkSplash:
        factory = InkSplash.splashFactory;
        break;
      case InkFeature.preferredInkSplash:
        factory = CustomInkSplash.preferredSplashFactory;
    }
    return Theme.of(context).withSplashFactory(factory);
  }

  Widget _testPreferred(Color primaryColor, bool light) {
    return Theme(
      data: Theme.of(context)
          .copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: primaryColor,
                  onPrimary: light ? Colors.black : Colors.white,
                ),
          )
          .withPreferredButtonStyles(),
      child: _row(
        OutlinedButton(child: Text('Preferred (${light ? 'light' : 'dark'})'), onPressed: () {}),
        ElevatedButton(child: Text('Preferred (${light ? 'light' : 'dark'})'), onPressed: () {}),
        TextButton(child: Text('Preferred (${light ? 'light' : 'dark'})'), onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewButtonStyle Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _radio(InkFeature.defaultInkRipple, 'defaultInkRipple'),
          _radio(InkFeature.preferredInkRipple, 'preferredInkRipple'),
          _radio(InkFeature.defaultInkSplash, 'defaultInkSplash'),
          _radio(InkFeature.preferredInkSplash, 'preferredInkSplash'),
          const Divider(),
          Theme(
            data: themeData,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _row(
                  OutlineButton(child: const Text('Outline'), onPressed: () {}),
                  OutlineButton(child: const Text('Outline NoHl'), onPressed: () {}, highlightColor: Colors.transparent),
                  OutlinedButton(child: const Text('Outlined'), onPressed: () {}),
                ),
                _row(
                  OutlinedButton(child: const Text('Styled 1 Default'), onPressed: () {}, style: outlineButtonStyle(themeData.colorScheme)), // 0.12
                  OutlinedButton(child: const Text('Styled 1 Old'), onPressed: () {}, style: outlineButtonStyle(themeData.colorScheme, splashColor: Colors.black.withOpacity(0.26))), // 0.26
                  OutlinedButton(child: const Text('Styled 1 Preferred'), onPressed: () {}, style: outlineButtonStyle(themeData.colorScheme, splashColor: Colors.black.withOpacity(0.20))), // 0.20
                ),
                _row(
                  OutlinedButton(child: const Text('Styled 2 Default'), onPressed: () {}, style: outlineButtonStyle(themeData.colorScheme, primary: primary)), // 0.12
                  OutlinedButton(child: const Text('Styled 2 Old'), onPressed: () {}, style: outlineButtonStyle(themeData.colorScheme, primary: primary, splashColor: primary.withOpacity(0.26))), // 0.26
                  OutlinedButton(child: const Text('Styled 2 Preferred'), onPressed: () {}, style: outlineButtonStyle(themeData.colorScheme, primary: primary, splashColor: primary.withOpacity(0.20))), // 0.20
                ),
                const Divider(),
                _row(
                  RaisedButton(child: const Text('Raised'), onPressed: () {}),
                  RaisedButton(child: const Text('Raised NoHl'), onPressed: () {}, highlightColor: Colors.transparent),
                  ElevatedButton(child: const Text('Elevated'), onPressed: () {}),
                ),
                _row(
                  ElevatedButton(child: const Text('Styled 1 Default'), onPressed: () {}, style: raisedButtonStyle()), // 0.24
                  ElevatedButton(child: const Text('Styled 2 Old/For Light'), onPressed: () {}, style: raisedButtonStyle(splashColor: Colors.black.withOpacity(0.26))), // 0.26
                  ElevatedButton(child: const Text('Styled 2 For Dark'), onPressed: () {}, style: raisedButtonStyle(splashColor: Colors.black.withOpacity(0.40))), // 0.40
                ),
                _row(
                  ElevatedButton(child: const Text('Styled 2 Default'), onPressed: () {}, style: raisedButtonStyle(onPrimary: onPrimary, primary: primary)), // 0.24
                  ElevatedButton(child: const Text('Styled 2 For Light'), onPressed: () {}, style: raisedButtonStyle(onPrimary: onPrimary, primary: primary, splashColor: onPrimary.withOpacity(0.26))), // 0.26
                  ElevatedButton(child: const Text('Styled 2 For Dark'), onPressed: () {}, style: raisedButtonStyle(onPrimary: onPrimary, primary: primary, splashColor: onPrimary.withOpacity(0.40))), // 0.40
                ),
                const Divider(),
                _row(
                  FlatButton(child: const Text('Flat'), onPressed: () {}),
                  FlatButton(child: const Text('Flat NoHl'), onPressed: () {}, highlightColor: Colors.transparent),
                  TextButton(child: const Text('Text'), onPressed: () {}),
                ),
                _row(
                  TextButton(child: const Text('Styled 1 Default'), onPressed: () {}, style: flatButtonStyle()), // 0.12
                  TextButton(child: const Text('Styled 1 Old'), onPressed: () {}, style: flatButtonStyle(splashColor: Colors.black.withOpacity(0.26))), // 0.26
                  TextButton(child: const Text('Styled 1 Preferred'), onPressed: () {}, style: flatButtonStyle(splashColor: Colors.black.withOpacity(0.20))), // 0.20
                ),
                _row(
                  TextButton(child: const Text('Styled 2 Default'), onPressed: () {}, style: flatButtonStyle(primary: primary)), // 0.12
                  TextButton(child: const Text('Styled 2 Old'), onPressed: () {}, style: flatButtonStyle(primary: primary, splashColor: primary.withOpacity(0.26))), // 0.26
                  TextButton(child: const Text('Styled 2 Preferred'), onPressed: () {}, style: flatButtonStyle(primary: primary, splashColor: primary.withOpacity(0.20))), // 0.20
                ),
                const Divider(),
                _testPreferred(Colors.blue, false), // -> 0.20 / 0.26 / 0.20
                _testPreferred(Colors.purple, false),
                _testPreferred(Colors.deepOrange, false),
                _testPreferred(Colors.teal, false),
                _testPreferred(Colors.indigo, false),
                const Divider(),
                _testPreferred(Colors.grey[300]!, true),  // -> 0.20 / 0.40 / 0.20
                _testPreferred(Colors.cyanAccent, true),
                _testPreferred(Colors.amber, true),
                _testPreferred(Colors.lightGreen, true),
                _testPreferred(Colors.deepPurple[200]!, true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
