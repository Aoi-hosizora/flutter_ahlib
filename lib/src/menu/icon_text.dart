import 'package:flutter/material.dart';

/// Wrapped `Row` shown for `Icon` and `Text`, mainly used in `showPopupMenu`
class IconText extends StatefulWidget {
  const IconText({
    Key key,
    this.padding = 15,
    @required this.icon,
    @required this.text,
  })  : assert(icon != null),
        assert(text != null), 
        assert(padding == null || padding >= 0),
        super(key: key);

  final int padding;
  final Icon icon;
  final Text text;

  @override
  _IconTextState createState() => _IconTextState();
}

class _IconTextState extends State<IconText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.icon,
        Padding(
          padding: EdgeInsets.only(left: widget.padding ?? 15),
          child: widget.text,
        ),
      ],
    );
  }
}
