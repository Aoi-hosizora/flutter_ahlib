import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';

/// The default padding for [TextDialogOption].
const _kTextDialogOptionPadding = EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0);

/// The default space for [IconTextDialogOption].
const _kIconTextDialogOptionSpace = 15.0;

/// The default padding for [IconTextDialogOption].
const _kIconTextDialogOptionPadding = EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0);

/// An option used in a [SimpleDialog], which wraps [text] with default padding and style.
class TextDialogOption extends StatelessWidget {
  const TextDialogOption({
    Key? key,
    required this.text,
    required this.onPressed,
    this.padding = _kTextDialogOptionPadding,
  }) : super(key: key);

  /// The text widget below this widget in the tree, typically a [Text] widget.
  final Widget text;

  /// The padding to surround the [text], defaults to `EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0)`.
  final EdgeInsets padding;

  /// The callback that is called when this option is selected.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: padding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: text,
        ),
      ),
    );
  }
}

/// An option used in a [SimpleDialog], which wraps [icon] and [text] with default padding and style.
class IconTextDialogOption extends StatelessWidget {
  const IconTextDialogOption({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.space = _kIconTextDialogOptionSpace,
    this.padding = _kIconTextDialogOptionPadding,
  }) : super(key: key);

  /// The icon widget below this widget in the tree, typically a [Icon] widget.
  final Widget icon;

  /// The text widget below this widget in the tree, typically a [Text] widget.
  final Widget text;

  /// The padding to surround the [icon] and [text], defaults to `EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0)`.
  final EdgeInsets padding;

  /// The space between [icon] and [text], defaults to 15.0.
  final double space;

  /// The callback that is called when this option is selected.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: padding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: IconText(
            icon: icon,
            text: text,
            space: space,
          ),
        ),
      ),
    );
  }
}
