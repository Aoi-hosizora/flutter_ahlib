import 'package:flutter/material.dart';

/// Represent the leading widget of [RippleSizedView].
enum RippleSizedViewPosition {
  left,
  right,
  top,
  bottom,
}

/// A replacement of simplified [ListTile], using [InkWell] and [Material].
@deprecated
class RippleSizedView extends StatefulWidget {
  const RippleSizedView({
    Key key,
    @required this.leading,
    @required this.body,
    @required this.position,
    @required this.size,
    this.enabled = true,
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
        assert(enabled != null),
        super(key: key);

  /// A widget to display before the title.
  final Widget leading;

  /// The primary content of the view.
  final Widget body;

  /// The position where [leading] posit.
  final RippleSizedViewPosition position;

  /// The size of [leading], need in [Stack] and the tap events in [InkWell].
  final Size size;

  /// Whether this view is interactive.
  final bool enabled;

  /// Called when the user taps this widget. Inoperative if [enabled] is false.
  final void Function() onTap;

  /// Called when the user long-presses this widget. Inoperative if [enabled] is false.
  final void Function() onLongPressed;

  /// Called when the user taps the [body]. Inoperative if [enabled] is false.
  final void Function() onBodyTap;

  /// Called when the user long-presses this [body]. Inoperative if [enabled] is false.
  final void Function() onBodyLongPressed;

  /// Called when the user taps the [leading]. Inoperative if [enabled] is false.
  final void Function() onLeadingTap;

  /// Called when the user long-presses this [leading]. Inoperative if [enabled] is false.
  final void Function() onLeadingLongPressed;

  @override
  _RippleSizedViewState createState() => _RippleSizedViewState();
}

/// The state of [RippleSizedView].
class _RippleSizedViewState extends State<RippleSizedView> {
  /// Record where is pressed in the [Positioned.fill].
  Offset _pointerDownPosition;

  void _onPointerDown(PointerDownEvent e) {
    _pointerDownPosition = e.position;
  }

  /// Invoke [onTap], [onLeadingTap] or [onBodyTap].
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
      case RippleSizedViewPosition.left:
        (dx <= w ? lt : bt)();
        break;
      case RippleSizedViewPosition.right:
        (dx >= w ? lt : bt)();
        break;
      case RippleSizedViewPosition.top:
        (dy <= h ? lt : bt)();
        break;
      case RippleSizedViewPosition.bottom:
        (dy >= h ? lt : bt)();
        break;
    }
  }

  /// Invoke [onLongPressed], [onLeadingLongPressed] or [onBodyLongPressed].
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
      case RippleSizedViewPosition.left:
        (dx <= w ? ll : bl)();
        break;
      case RippleSizedViewPosition.right:
        (dx >= w ? ll : bl)();
        break;
      case RippleSizedViewPosition.top:
        (dy <= h ? ll : bl)();
        break;
      case RippleSizedViewPosition.bottom:
        (dy >= h ? ll : bl)();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget sizedBox = SizedBox(
      height: widget.size.height,
      width: widget.size.width,
    );
    Widget fill;
    AlignmentDirectional alignment;
    switch (widget.position) {
      case RippleSizedViewPosition.left:
        fill = Row(children: [sizedBox, widget.body]);
        alignment = AlignmentDirectional.centerStart;
        break;
      case RippleSizedViewPosition.right:
        fill = Row(children: [widget.body, sizedBox]);
        alignment = AlignmentDirectional.centerEnd;
        break;
      case RippleSizedViewPosition.top:
        fill = Column(children: [sizedBox, widget.body]);
        alignment = AlignmentDirectional.topCenter;
        break;
      case RippleSizedViewPosition.bottom:
        fill = Column(children: [widget.body, sizedBox]);
        alignment = AlignmentDirectional.bottomCenter;
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
