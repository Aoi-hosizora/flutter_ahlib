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
const kIconTextDefaultSpace = 15.0;

/// A wrapped [Icon] and [Text] with [Row] and [Column].
class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.icon,
    required Widget this.text,
    this.padding = EdgeInsets.zero,
    this.iconPadding = EdgeInsets.zero,
    this.textPadding = EdgeInsets.zero,
    this.alignment = IconTextAlignment.l2r,
    this.space = kIconTextDefaultSpace,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : texts = null,
        assert(space == null || space >= 0),
        super(key: key);

  const IconText.texts({
    Key? key,
    required this.icon,
    required List<Widget> this.texts,
    this.padding = EdgeInsets.zero,
    this.iconPadding = EdgeInsets.zero,
    this.alignment = IconTextAlignment.l2r,
    this.space = kIconTextDefaultSpace,
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

  /// The text list of this widget, note that [textPadding] will be ignored if this value is
  /// used.
  final List<Widget>? texts;

  /// The padding of this widget, default to [EdgeInsets.zero], and the widget will not be
  /// wrapped [Padding].
  final EdgeInsets? padding;

  /// The padding of this widget's icon, default to [EdgeInsets.zero], and the widget will not
  /// be wrapped [Padding].
  final EdgeInsets? iconPadding;

  /// The padding of this widget's text, default to [EdgeInsets.zero], and the widget will not
  /// be wrapped [Padding].
  ///
  /// Note that if you want to wrap [text] with [Flexible], [textPadding] should be set to [EdgeInsets.zero].
  /// And note that [textPadding] will be ignored for widgets which are constructed by [IconText.texts].
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
    final mainAxisAlignment = this.mainAxisAlignment ?? MainAxisAlignment.start;
    final mainAxisSize = this.mainAxisSize ?? MainAxisSize.max;
    final crossAxisAlignment = this.crossAxisAlignment ?? CrossAxisAlignment.center;
    final widgetSpace = space ?? kIconTextDefaultSpace;

    Widget iconWidget;
    Widget? textWidget;
    if (iconPadding == null || iconPadding == EdgeInsets.zero) {
      iconWidget = icon;
    } else {
      iconWidget = Padding(padding: iconPadding!, child: icon);
    }
    if (textPadding == null || textPadding == EdgeInsets.zero) {
      textWidget = text;
    } else if (text != null) {
      textWidget = Padding(padding: textPadding!, child: text!);
    } else {
      textWidget = null; // use texts
    }

    Widget widget;
    switch (alignment ?? IconTextAlignment.l2r) {
      case IconTextAlignment.l2r:
        // Horizontal: Icon -> Text
        widget = Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            iconWidget,
            SizedBox(height: 0, width: widgetSpace),
            if (textWidget != null) textWidget,
            if (texts != null) ...texts!,
          ],
        );
        break;
      case IconTextAlignment.r2l:
        // Horizontal: Text -> Icon
        widget = Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (textWidget != null) textWidget,
            if (texts != null) ...texts!,
            SizedBox(height: 0, width: widgetSpace),
            iconWidget,
          ],
        );
        break;
      case IconTextAlignment.t2b:
        // Vertical: Icon -> Text
        widget = Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            iconWidget,
            SizedBox(height: widgetSpace, width: 0),
            if (textWidget != null) textWidget,
            if (texts != null) ...texts!,
          ],
        );
        break;
      case IconTextAlignment.b2t:
        // Vertical: Text -> Icon
        widget = Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (textWidget != null) textWidget,
            if (texts != null) ...texts!,
            SizedBox(height: widgetSpace, width: 0),
            iconWidget,
          ],
        );
        break;
      default:
        // Unreachable
        widget = const SizedBox.shrink(); // dummy
        break;
    }

    if (padding == null || padding == EdgeInsets.zero) {
      return widget;
    }
    return Padding(padding: padding!, child: widget);
  }
}
