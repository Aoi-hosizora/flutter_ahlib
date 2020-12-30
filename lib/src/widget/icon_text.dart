import 'package:flutter/material.dart';

/// Alignment of [Icon] and [Text], used in [IconText].
enum IconTextAlignment {
  /// Horizontal Row: Icon -> Text.
  l2r,

  /// Horizontal Row: Text -> Icon.
  r2l,

  /// Vertical Column: Icon -> Text.
  t2b,

  /// Vertical Column: Text -> Icon.
  b2t,
}

/// Wrap [Icon] and [Text] with a [Row] and [Column].
class IconText extends StatelessWidget {
  const IconText({
    Key key,
    @required this.icon,
    @required this.text,
    this.iconPadding = EdgeInsets.zero,
    this.textPadding = EdgeInsets.zero,
    this.alignment = IconTextAlignment.l2r,
    this.space = 15.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : assert(icon != null),
        assert(text != null),
        assert(iconPadding != null),
        assert(textPadding != null),
        assert(alignment != null),
        assert(space != null && space >= 0),
        assert(mainAxisAlignment != null),
        assert(mainAxisSize != null),
        assert(crossAxisAlignment != null),
        super(key: key);

  /// A simple non-const constructor for [IconText].
  IconText.simple(IconData icon, String text) : this(icon: Icon(icon), text: Text(text));

  /// The icon of the item.
  final Icon icon;

  /// The text of the item.
  final Text text;

  /// Padding of [icon].
  final EdgeInsets iconPadding;

  /// Padding of [text].
  final EdgeInsets textPadding;

  /// Alignment of [icon] and [text].
  final IconTextAlignment alignment;

  /// Space between [icon] and [text].
  final double space;

  /// The MainAxisAlignment of row or column.
  final MainAxisAlignment mainAxisAlignment;

  /// The MainAxisSize of row or column.
  final MainAxisSize mainAxisSize;

  /// The CrossAxisAlignment of row or column.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    var pIcon = Padding(padding: iconPadding, child: icon);
    var pText = Padding(padding: textPadding, child: text);

    switch (alignment) {
      case IconTextAlignment.l2r:
        // Horizontal: Icon -> Text
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            pIcon,
            SizedBox(height: 0, width: this.space),
            pText,
          ],
        );
      case IconTextAlignment.r2l:
        // Horizontal: Text -> Icon
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            pText,
            SizedBox(height: 0, width: this.space),
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
            SizedBox(height: this.space, width: 0),
            pText,
          ],
        );
      case IconTextAlignment.b2t:
        // Vertical: Text -> Icon
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            pText,
            SizedBox(height: this.space, width: 0),
            pIcon,
          ],
        );
      default:
        return Container();
    }
  }
}
