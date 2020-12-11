import 'package:flutter/material.dart';

/// A view used for [CachedNetworkImage.loadFailedChild].
@deprecated
class ImageLoadFailedView extends StatefulWidget {
  ImageLoadFailedView({
    Key key,
    this.title,
    this.backgroundColor = Colors.black,
    @required this.width,
    @required this.height,
    this.titleTextStyle = const TextStyle(fontSize: 45, color: Colors.grey),
    this.iconPadding = const EdgeInsets.all(30),
    this.iconColor = Colors.grey,
    this.iconSize = 50,
  })  : assert(backgroundColor != null),
        assert(width == null || width > 0),
        assert(height == null || height > 0),
        assert(titleTextStyle != null),
        assert(iconPadding != null),
        assert(iconColor != null),
        assert(iconSize != null),
        super(key: key);

  /// Title for [ImageLoadFailedView].
  final String title;

  /// Background color for [ImageLoadFailedView].
  final Color backgroundColor;

  /// Width for [ImageLoadFailedView].
  final double width;

  /// Height for [ImageLoadFailedView].
  final double height;

  /// [TextStyle] for title text.
  final TextStyle titleTextStyle;

  /// Padding for [Icon].
  final EdgeInsets iconPadding;

  /// Color for [Icon].
  final Color iconColor;

  /// Size for [Icon].
  final double iconSize;

  @override
  _ImageLoadFailedViewState createState() => _ImageLoadFailedViewState();
}

class _ImageLoadFailedViewState extends State<ImageLoadFailedView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.title != null)
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: widget.titleTextStyle,
            ),
          Padding(
            padding: widget.iconPadding,
            child: Container(
              width: widget.iconSize,
              height: widget.iconSize,
              child: Icon(
                Icons.broken_image,
                color: widget.iconColor,
                size: widget.iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
