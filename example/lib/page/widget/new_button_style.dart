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

  Widget _row(Widget w1, Widget w2, Widget w3, Widget w4) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        w1,
        const SizedBox(width: 12),
        w2,
        const SizedBox(width: 12),
        w3,
        const SizedBox(width: 12),
        w4,
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
                    OutlinedButton(child: const Text('Styled 1'), onPressed: () {}, style: outlineButtonStyle(c)),
                    OutlinedButton(
                      child: const Text('Styled 2'),
                      onPressed: () {},
                      style: outlineButtonStyle(
                        c,
                        primary: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  _row(
                    ElevatedButton(child: const Text('Elevated'), onPressed: () {}),
                    RaisedButton(child: const Text('Raised'), onPressed: () {}), // ignore: deprecated_member_use
                    ElevatedButton(child: const Text('Styled 1'), onPressed: () {}, style: raisedButtonStyle()),
                    ElevatedButton(
                      child: const Text('Styled 2'),
                      onPressed: () {},
                      style: raisedButtonStyle(
                        onPrimary: Theme.of(context).colorScheme.onPrimary,
                        primary: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  _row(
                    TextButton(child: const Text('Text'), onPressed: () {}),
                    FlatButton(child: const Text('Flat'), onPressed: () {}), // ignore: deprecated_member_use
                    TextButton(child: const Text('Styled 1'), onPressed: () {}, style: flatButtonStyle()),
                    TextButton(
                      child: const Text('Styled 2'),
                      onPressed: () {},
                      style: flatButtonStyle(
                        primary: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
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
