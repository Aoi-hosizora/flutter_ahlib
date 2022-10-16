import 'package:flutter/material.dart';

/// The alignment of [Icon] and [Text], used in [IconText].
enum IconTextAlignment {
  /// Represents horizontal row: Icon -> Text.
  l2r,

  /// Represents Horizontal Row: Text -> Icon.
  r2l,

  /// Represents vertical column: Icon -> Text.
  t2b,

  /// Represents vertical column: Text -> Icon.
  b2t,
}

/// The default space of [IconText].
const _kDefaultSpace = 15.0;

/// A wrapped [Icon] and [Text] with [Row] and [Column].
class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.icon,
    required Widget this.text,
    this.iconPadding = EdgeInsets.zero,
    this.textPadding = EdgeInsets.zero,
    this.alignment = IconTextAlignment.l2r,
    this.space = _kDefaultSpace,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : texts = null,
        assert(space == null || space >= 0),
        super(key: key);

  const IconText.texts({
    Key? key,
    required this.icon,
    required List<Widget> this.texts, // TODO without test in example
    this.iconPadding = EdgeInsets.zero,
    this.alignment = IconTextAlignment.l2r,
    this.space = _kDefaultSpace,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : text = null,
        textPadding = EdgeInsets.zero,
        assert(space == null || space >= 0),
        super(key: key);

  /// Creates a [IconText] in a simple way, note that this is a non-const constructor.
  IconText.simple(IconData icon, String text, {Key? key}) : this(key: key, icon: Icon(icon), text: Text(text));

  /// The icon of this widget, and its padding can be set by [iconPadding].
  final Widget icon;

  /// The text of this widget, and its padding can be set by [textPadding]
  final Widget? text;

  /// The text list of this widget, note that [textPadding] will be ignored if this value is used.
  final List<Widget>? texts;

  /// The padding of this widget's icon, default to [EdgeInsets.zero].
  final EdgeInsets? iconPadding;

  /// The padding of this widget's text, default to [EdgeInsets.zero]. Note that if you want to
  /// wrap [text] with [Flexible], you should set [textPadding] to zero.
  final EdgeInsets? textPadding;

  /// The alignment of the icon and the text, defaults to [IconTextAlignment.l2r].
  final IconTextAlignment? alignment;

  /// The space between the icon and the text, defaults to 15.0.
  final double? space;

  /// The mainAxisAlignment of the row or column, defaults to [MainAxisAlignment.start].
  final MainAxisAlignment? mainAxisAlignment;

  /// The mainAxisSize of the row or column, defaults to [MainAxisSize.max].
  final MainAxisSize? mainAxisSize;

  /// The crossAxisAlignment of the row or column, defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    var pIcon = (iconPadding == null || iconPadding == EdgeInsets.zero) ? icon : Padding(padding: iconPadding!, child: icon);
    var pText = (textPadding == null || textPadding == EdgeInsets.zero) ? text : (text == null ? null : Padding(padding: textPadding!, child: text!));
    var mainAxisAlignment = this.mainAxisAlignment ?? MainAxisAlignment.start;
    var mainAxisSize = this.mainAxisSize ?? MainAxisSize.max;
    var crossAxisAlignment = this.crossAxisAlignment ?? CrossAxisAlignment.center;

    switch (alignment ?? IconTextAlignment.l2r) {
      case IconTextAlignment.l2r:
        // Horizontal: Icon -> Text
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            pIcon,
            SizedBox(height: 0, width: space ?? _kDefaultSpace),
            if (pText != null) pText,
            if (texts != null) ...texts!,
          ],
        );
      case IconTextAlignment.r2l:
        // Horizontal: Text -> Icon
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (pText != null) pText,
            if (texts != null) ...texts!,
            SizedBox(height: 0, width: space ?? _kDefaultSpace),
            pIcon,
          ],
        );
      case IconTextAlignment.t2b:
        // Vertical: Icon -> Text
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            pIcon,
            SizedBox(height: space ?? _kDefaultSpace, width: 0),
            if (pText != null) pText,
            if (texts != null) ...texts!,
          ],
        );
      case IconTextAlignment.b2t:
        // Vertical: Text -> Icon
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (pText != null) pText,
            if (texts != null) ...texts!,
            SizedBox(height: space ?? _kDefaultSpace, width: 0),
            pIcon,
          ],
        );
      default:
        // Unreachable
        return const SizedBox(height: 0); // dummy
    }
  }
}
