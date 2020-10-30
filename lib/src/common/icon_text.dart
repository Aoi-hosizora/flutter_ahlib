import 'package:flutter/material.dart';

/// Wrap [Icon] and [Text] with a [Row] as a menu item.
class IconText extends StatelessWidget {
  const IconText({
    Key key,
    @required this.icon,
    @required this.text,
    this.space = 15.0,
  })  : assert(icon != null),
        assert(text != null),
        assert(space != null && space >= 0),
        super(key: key);

  /// The icon of the item.
  final Icon icon;

  /// The text of the item.
  final Text text;

  /// Space between [icon] and [text].
  final double space;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        this.icon,
        SizedBox(
          height: 0,
          width: this.space,
        ),
        this.text,
      ],
    );
  }
}
