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

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewButtonStylePage'),
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
            child: Builder(
              builder: (c) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _row(
                    OutlinedButton(child: const Text('Outlined'), onPressed: () {}),
                    OutlineButton(child: const Text('Outline'), onPressed: () {}), // ignore: deprecated_member_use
                    OutlineButton(child: const Text('Outline NoHl'), onPressed: () {}, highlightColor: Colors.transparent), // ignore: deprecated_member_use
                  ),
                  _row(
                    OutlinedButton(child: const Text('Styled 1'), onPressed: () {}, style: outlineButtonStyle(c)), // -> 0.12
                    OutlinedButton(child: const Text('Styled 1 Middle'), onPressed: () {}, style: outlineButtonStyle(c, splashColor: Colors.black.withOpacity(0.19))), // 0.19
                    OutlinedButton(child: const Text('Styled 1 Darker'), onPressed: () {}, style: outlineButtonStyle(c, splashColor: Colors.black26)), // 0.26
                  ),
                  _row(
                    OutlinedButton(child: const Text('Styled 2'), onPressed: () {}, style: outlineButtonStyle(c, primary: primary)), // 0.12
                    OutlinedButton(child: const Text('Styled 2 Middle'), onPressed: () {}, style: outlineButtonStyle(c, primary: primary, splashColor: primary.withOpacity(0.19))), // 0.19
                    OutlinedButton(child: const Text('Styled 2 Darker'), onPressed: () {}, style: outlineButtonStyle(c, primary: primary, splashColor: primary.withOpacity(0.26))), // 0.26
                  ),
                  const Divider(),
                  _row(
                    ElevatedButton(child: const Text('Elevated'), onPressed: () {}),
                    RaisedButton(child: const Text('Raised'), onPressed: () {}), // ignore: deprecated_member_use
                    RaisedButton(child: const Text('Raised NoHl'), onPressed: () {}, highlightColor: Colors.transparent), // ignore: deprecated_member_use
                  ),
                  _row(
                    ElevatedButton(child: const Text('Styled 1'), onPressed: () {}, style: raisedButtonStyle()),
                    ElevatedButton(child: const Text('Styled 2'), onPressed: () {}, style: raisedButtonStyle(onPrimary: onPrimary, primary: primary)), // 0.24
                    ElevatedButton(child: const Text('Styled 2 Middle'), onPressed: () {}, style: raisedButtonStyle(onPrimary: onPrimary, primary: primary, splashColor: Colors.white30)), // 0.30
                    ElevatedButton(child: const Text('Styled 2 Lighter'), onPressed: () {}, style: raisedButtonStyle(onPrimary: onPrimary, primary: primary, splashColor: Colors.white38)), // 0.38
                  ),
                  const Divider(),
                  _row(
                    TextButton(child: const Text('Text'), onPressed: () {}),
                    FlatButton(child: const Text('Flat'), onPressed: () {}), // ignore: deprecated_member_use
                    FlatButton(child: const Text('Flat NoHl'), onPressed: () {}, highlightColor: Colors.transparent), // ignore: deprecated_member_use
                  ),
                  _row(
                    TextButton(child: const Text('Styled 1'), onPressed: () {}, style: flatButtonStyle()), // 0.12
                    TextButton(child: const Text('Styled 1 Middle'), onPressed: () {}, style: flatButtonStyle(splashColor: Colors.black.withOpacity(0.19))), // 0.19
                    TextButton(child: const Text('Styled 1 Darker'), onPressed: () {}, style: flatButtonStyle(splashColor: Colors.black26)), // 0.26
                  ),
                  _row(
                    TextButton(child: const Text('Styled 2'), onPressed: () {}, style: flatButtonStyle(primary: primary)), // 0.12
                    TextButton(child: const Text('Styled 2 Middle'), onPressed: () {}, style: flatButtonStyle(primary: primary, splashColor: primary.withOpacity(0.19))), // 0.19
                    TextButton(child: const Text('Styled 2 Darker'), onPressed: () {}, style: flatButtonStyle(primary: primary, splashColor: primary.withOpacity(0.26))), // 0.26
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('ListTile', textAlign: TextAlign.center),
                    onTap: () {},
                  ),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      title: const Text('Card with ListTile', textAlign: TextAlign.center),
                      onTap: () {},
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
