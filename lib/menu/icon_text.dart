import 'package:flutter/material.dart';

class IconText extends StatefulWidget {
  const IconText({
    Key key,
    @required this.icon,
    @required this.text,
  })  : assert(icon != null),
        assert(text != null),
        super(key: key);

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
          padding: EdgeInsets.only(left: 15),
          child: widget.text,
        ),
      ],
    );
  }
}
