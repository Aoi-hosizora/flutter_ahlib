import 'package:flutter/material.dart';

class SliverContainer extends StatefulWidget {
  const SliverContainer({
    Key key,
    @required this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.color,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final Color color;

  @override
  _SliverContainerState createState() => _SliverContainerState();
}

class _SliverContainerState extends State<SliverContainer> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: widget.child,
        padding: widget.padding,
        margin: widget.margin,
        height: widget.height,
        width: widget.width,
        color: widget.color,
      ),
    );
  }
}
