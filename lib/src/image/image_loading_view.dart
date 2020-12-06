import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

/// A view used for [CachedNetworkImage.loadingBuilder].
class ImageLoadingView extends StatefulWidget {
  const ImageLoadingView({
    Key key,
    this.title,
    @required this.event,
    this.backgroundColor = Colors.black,
    this.width,
    this.height,
    this.titleTextStyle = const TextStyle(fontSize: 45, color: Colors.grey),
    this.progressPadding = const EdgeInsets.all(30),
    this.progressSize = 50,
    this.showFileSize = true,
    this.fileSizeTextStyle = const TextStyle(color: Colors.grey),
  })  : assert(backgroundColor != null),
        assert(width == null || width > 0),
        assert(height == null || height > 0),
        assert(titleTextStyle != null),
        assert(progressPadding != null),
        assert(progressSize != null),
        assert(showFileSize != null),
        assert(fileSizeTextStyle != null),
        super(key: key);

  /// Title for [ImageLoadingView].
  final String title;

  /// [ImageChunkEvent] used for showing progress and file size.
  final ImageChunkEvent event;

  /// Background color for [ImageLoadingView].
  final Color backgroundColor;

  /// Width for [ImageLoadingView].
  final double width;

  /// Height for [ImageLoadingView].
  final double height;

  /// [TextStyle] for title text.
  final TextStyle titleTextStyle;

  /// Progress padding.
  final EdgeInsets progressPadding;

  /// Progress size.
  final double progressSize;

  /// Show file size text or not.
  final bool showFileSize;

  /// [TextStyle] for file size text.
  final TextStyle fileSizeTextStyle;

  @override
  _ImageLoadingViewState createState() => _ImageLoadingViewState();
}

class _ImageLoadingViewState extends State<ImageLoadingView> {
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
            padding: widget.progressPadding,
            child: Container(
              width: widget.progressSize,
              height: widget.progressSize,
              child: CircularProgressIndicator(
                value: widget.event?.expectedTotalBytes ?? 0 == 0 ? null : (widget.event?.cumulativeBytesLoaded ?? 0.0) / widget.event.expectedTotalBytes,
              ),
            ),
          ),
          if (widget.showFileSize && widget.event?.cumulativeBytesLoaded != null)
            Text(
              widget.event?.expectedTotalBytes == null ? '${filesize(widget.event.cumulativeBytesLoaded)}' : '${filesize(widget.event.cumulativeBytesLoaded)} / ${filesize(widget.event.expectedTotalBytes)}',
              style: widget.fileSizeTextStyle,
            ),
        ],
      ),
    );
  }
}
