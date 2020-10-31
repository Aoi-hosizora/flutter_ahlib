import 'package:flutter/material.dart';

/// Alignment of [Icon] and [Text], used in [IconText].
enum IconTextAlignment {
  /// Horizontal: Icon -> Text.
  l2r,

  /// Horizontal: Text -> Icon.
  r2l,

  /// Vertical: Icon -> Text.
  t2b,

  /// Vertical: Text -> Icon.
  b2t,
}

/// Wrap [Icon] and [Text] with a [Row].
class IconText extends StatelessWidget {
  const IconText({
    Key key,
    @required this.icon,
    @required this.text,
    this.alignment = IconTextAlignment.l2r,
    this.space = 15.0,
  })  : assert(icon != null),
        assert(text != null),
        assert(alignment != null),
        assert(space != null && space >= 0),
        super(key: key);

  /// The icon of the item.
  final Icon icon;

  /// The text of the item.
  final Text text;

  /// Alignment of icon and text.
  final IconTextAlignment alignment;

  /// Space between [icon] and [text].
  final double space;

  @override
  Widget build(BuildContext context) {
    switch (alignment) {
      case IconTextAlignment.l2r:
        // Horizontal: Icon -> Text
        return Row(
          children: [
            this.icon,
            SizedBox(height: 0, width: this.space),
            this.text,
          ],
        );
      case IconTextAlignment.r2l:
        // Horizontal: Text -> Icon
        return Row(
          children: [
            this.text,
            SizedBox(height: 0, width: this.space),
            this.icon,
          ],
        );
      case IconTextAlignment.t2b:
        // Vertical: Icon -> Text
        return Column(
          children: [
            this.icon,
            SizedBox(height: this.space, width: 0),
            this.text,
          ],
        );
      case IconTextAlignment.b2t:
        // Vertical: Text -> Icon
        return Column(
          children: [
            this.text,
            SizedBox(height: this.space, width: 0),
            this.icon,
          ],
        );
    }
  }
}
