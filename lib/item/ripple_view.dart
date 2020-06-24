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
    this.onLongPressed,
    this.onBodyTap,
    this.onBodyLongPressed,
    this.onLeadingTap,
    this.onLeadingLongPressed,
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
  final void Function() onLongPressed;
  final void Function() onBodyTap;
  final void Function() onBodyLongPressed;
  final void Function() onLeadingTap;
  final void Function() onLeadingLongPressed;

  @override
  _RippleSizedViewState createState() => _RippleSizedViewState();
}

class _RippleSizedViewState extends State<RippleSizedView> {
  Offset _pointerDownPosition;

  void _onPointerDown(PointerDownEvent e) {
    _pointerDownPosition = e.position;
  }

  void _onTap() {
    if (widget.onTap != null) {
      widget.onTap();
      return;
    }
    var h = widget.size.height;
    var w = widget.size.width;
    var dx = _pointerDownPosition?.dx ?? 0;
    var dy = _pointerDownPosition?.dy ?? 0;

    var lt = widget.onLeadingTap ?? () {};
    var bt = widget.onBodyTap ?? () {};
    switch (widget.position) {
      case RippleSizedViewPosition.top:
        (dy <= h ? lt : bt)();
        break;
      case RippleSizedViewPosition.bottom:
        (dy >= h ? lt : bt)();
        break;
      case RippleSizedViewPosition.left:
        (dx <= w ? lt : bt)();
        break;
      case RippleSizedViewPosition.right:
        (dx >= w ? lt : bt)();
        break;
    }
  }

  void _onLongPressed() {
    if (widget.onLongPressed != null) {
      widget.onLongPressed();
      return;
    }
    var h = widget.size.height;
    var w = widget.size.width;
    var dx = _pointerDownPosition?.dx ?? 0;
    var dy = _pointerDownPosition?.dy ?? 0;

    var ll = widget.onLeadingLongPressed ?? () {};
    var bl = widget.onBodyLongPressed ?? () {};
    switch (widget.position) {
      case RippleSizedViewPosition.top:
        (dy <= h ? ll : bl)();
        break;
      case RippleSizedViewPosition.bottom:
        (dy >= h ? ll : bl)();
        break;
      case RippleSizedViewPosition.left:
        (dx <= w ? ll : bl)();
        break;
      case RippleSizedViewPosition.right:
        (dx >= w ? ll : bl)();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget fill;
    Widget sizedBox = SizedBox(
      height: widget.size.height,
      width: widget.size.width,
    );
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
          child: Listener(
            onPointerDown: (m) => _onPointerDown(m),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: fill,
                onTap: _onTap,
                onLongPress: _onLongPressed,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
