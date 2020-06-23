import 'package:flutter/material.dart';

enum RippleSizedViewPosition {
  left,
  right,
  top,
  bottom,
}

/// A replace widget of `ListTile` for padding
class RippleSizedView extends StatefulWidget {
  const RippleSizedView({
    Key key,
    @required this.leading,
    @required this.body,
    @required this.position,
    @required this.size,
    this.onTap,
    this.onLongPress,
  })  : assert(leading != null),
        assert(body != null),
        assert(position != null),
        assert(size != null),
        super(key: key);

  final Widget leading;
  final Widget body;
  final RippleSizedViewPosition position;
  final Size size;
  final void Function() onTap;
  final void Function() onLongPress;

  @override
  _RippleSizedViewState createState() => _RippleSizedViewState();
}

class _RippleSizedViewState extends State<RippleSizedView> {
  @override
  Widget build(BuildContext context) {
    Widget fill;
    Widget sizedBox = SizedBox(height: widget.size.height, width: widget.size.width);
    AlignmentDirectional alignment;
    switch (widget.position) {
      case RippleSizedViewPosition.top:
        fill = Column(children: [sizedBox, widget.body]);
        alignment = AlignmentDirectional.topCenter;
        break;
      case RippleSizedViewPosition.bottom:
        fill = Column(children: [widget.body, sizedBox]);
        alignment = AlignmentDirectional.bottomCenter;
        break;
      case RippleSizedViewPosition.left:
        fill = Row(children: [sizedBox, widget.body]);
        alignment = AlignmentDirectional.centerStart;
        break;
      case RippleSizedViewPosition.right:
        fill = Row(children: [widget.body, sizedBox]);
        alignment = AlignmentDirectional.centerEnd;
        break;
    }
    return Stack(
      alignment: alignment,
      children: [
        widget.leading,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              child: fill,
            ),
          ),
        ),
      ],
    );
  }
}
