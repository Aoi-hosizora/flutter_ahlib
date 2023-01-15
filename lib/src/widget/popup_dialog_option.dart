import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';
import 'package:flutter_ahlib/src/util/flutter_constants.dart';

/// The default padding for [TextDialogOption].
const _kTextDialogOptionPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0); // same as SimpleDialog's titlePadding

/// The default padding for [IconTextDialogOption].
const _kIconTextDialogOptionPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0);

/// The default space for [IconTextDialogOption].
const _kIconTextDialogOptionSpace = 15.0;

/// The default padding for [CircularProgressDialogOption].
const _kCircularProgressDialogOptionPadding = EdgeInsets.symmetric(horizontal: 35.0, vertical: 24.0);

/// The default space for [CircularProgressDialogOption].
const _kCircularProgressDialogOptionSpace = 32.0;

/// An option used in a [SimpleDialog], which wraps [text] with default padding and style.
class TextDialogOption extends StatelessWidget {
  const TextDialogOption({
    Key? key,
    required this.text,
    required this.onPressed,
    this.onLongPressed,
    this.padding = _kTextDialogOptionPadding,
  }) : super(key: key);

  /// The text widget below this widget in the tree, typically a [Text] widget.
  final Widget text;

  /// The padding to surround the [text], defaults to `EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)`.
  final EdgeInsets padding;

  /// The callback that is called when this option is selected.
  final void Function() onPressed;

  /// The callback that is called when this option is long pressed.
  final void Function()? onLongPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      onLongPress: onLongPressed,
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
    this.onLongPressed,
    this.padding = _kIconTextDialogOptionPadding,
    this.space = _kIconTextDialogOptionSpace,
  }) : super(key: key);

  /// The icon widget below this widget in the tree, typically is a [Icon] widget.
  final Widget icon;

  /// The text widget below this widget in the tree, typically is a [Text] widget.
  final Widget text;

  /// The callback that is called when this option is selected.
  final void Function() onPressed;

  /// The callback that is called when this option is long pressed.
  final void Function()? onLongPressed;

  /// The padding to surround the [icon] and [text], defaults to `EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0)`.
  final EdgeInsets padding;

  /// The space between [icon] and [text], defaults to 15.0.
  final double space;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: Padding(
        padding: padding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: IconTheme(
            data: Theme.of(context).iconTheme.copyWith(
                  color: const Color.fromRGBO(85, 85, 85, 1.0),
                ),
            child: IconText(
              icon: icon,
              text: text,
              space: space,
            ),
          ),
        ),
      ),
    );
  }
}

/// An option used in a [AlertDialog], which wraps [progress] and [child] with default padding and style.
/// Note that you have to set [AlertDialog.contentPadding] to [EdgeInsets.zero] in order to show correctly.
class CircularProgressDialogOption extends StatelessWidget {
  const CircularProgressDialogOption({
    Key? key,
    required this.progress,
    required this.child,
    this.padding = _kCircularProgressDialogOptionPadding,
    this.space = _kCircularProgressDialogOptionSpace,
  }) : super(key: key);

  /// The icon widget below this widget in the tree, typically is a [CircularProgressIndicator] widget.
  final Widget progress;

  /// The icon widget below this widget in the tree, typically is a [Text] widget.
  final Widget child;

  /// The padding to surround the [progress] and [child], defaults to `EdgeInsets.zero`.
  final EdgeInsets padding;

  /// The space between [progress] and [child], defaults to 24.0.
  final double space;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle1!,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            progress,
            SizedBox(width: space),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// Calculates a width that can make a dialog ([AlertDialog] or [SimpleDialog]) fill with the screen width.
double getDialogMaxWidth(BuildContext context) {
  var horizontalPadding = MediaQuery.of(context).padding + kDialogDefaultInsetPadding; // ignore content padding
  return MediaQuery.of(context).size.width - horizontalPadding.horizontal;
}

/// Calculates a content width that can make [AlertDialog] fill with the screen width.
double getDialogContentMaxWidth(BuildContext context) {
  var horizontalPadding = MediaQuery.of(context).padding + kDialogDefaultInsetPadding + kAlertDialogDefaultContentPadding;
  return MediaQuery.of(context).size.width - horizontalPadding.horizontal;
}
