import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The data class which represents video progress, used in [VideoProgressIndicator].
class VideoProgress {
  const VideoProgress({
    required this.duration,
    required this.position,
    this.buffered,
  });

  /// Video total duration.
  final int duration;

  /// Current played position, should have the same unit with [duration].
  final int position;

  /// Video buffered position, should have the same unit with [duration].
  final int? buffered;

  /// Creates a copy of this value but with given fields replaced with the new values.
  VideoProgress copyWith({int? duration, int? position, int? buffered}) {
    return VideoProgress(
      duration: duration ?? this.duration,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
    );
  }
}

/// A progress indicator used to display or control the playing and buffering status of video.
class VideoProgressIndicator extends StatefulWidget {
  const VideoProgressIndicator({
    Key? key,
    required this.progress,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.bufferedColor,
    this.playedColor,
    this.thumbColor,
    this.indicatorHeight = 5.0,
    this.thumbSize = 12.0,
    this.allowScrubbing = false,
    this.onScrubStart,
    this.onScrubbing,
    this.onScrubEnd,
  }) : super(key: key);

  /// The video progress.
  final VideoProgress? progress;

  /// The padding of indicator, defaults to `EdgeInsets.zero`.
  final EdgeInsets? padding;

  /// The background color of indicator, defaults to `Colors.grey.withOpacity(0.5)`.
  final Color? backgroundColor;

  /// The foreground color of buffered part, defaults to `Theme.of(context).primaryColor.withOpacity(0.3)`.
  final Color? bufferedColor;

  /// The foreground color of played part, defaults to `Theme.of(context).primaryColor.withOpacity(0.7)`.
  final Color? playedColor;

  /// The color of indicator thumb, defaults to `Theme.of(context).primaryColor.withOpacity(1.0)`.
  final Color? thumbColor;

  /// The height of indicator, which only describe the linear bar of indicator, defaults to 5.0.
  final double? indicatorHeight;

  /// The size of indicator thumb, which is suggested to be larger than [indicatorHeight], defaults to 12.0.
  final double? thumbSize;

  /// The flag to allow scrub indicator to control the progress of video player.
  final bool? allowScrubbing;

  /// The callback when scrubbing started.
  final void Function()? onScrubStart;

  /// The callback when scrubbing.
  final void Function(int position)? onScrubbing;

  /// The callback when scrubbing finished.
  final void Function()? onScrubEnd;

  @override
  State<VideoProgressIndicator> createState() => _VideoProgressIndicatorState();
}

class _VideoProgressIndicatorState extends State<VideoProgressIndicator> {
  Color get _kDefaultBackgroundColor => Colors.grey.withOpacity(0.5);

  Color get _kDefaultBufferedColor => Theme.of(context).primaryColor.withOpacity(0.3);

  Color get _kDefaultPlayedColor => Theme.of(context).primaryColor.withOpacity(0.7);

  Color get _kDefaultThumbColor => Theme.of(context).primaryColor.withOpacity(1.0);

  double get indicatorHeight => widget.indicatorHeight ?? 5.0;

  double get thumbSize => widget.thumbSize ?? 12.0;

  var _tappingDown = false;

  int _getProgress(Offset globalPosition) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    final int position = (widget.progress!.duration * relative).toInt();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (widget.progress == null) {
      progressIndicator = SizedBox(
        height: indicatorHeight,
        child: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(widget.playedColor ?? _kDefaultPlayedColor),
          backgroundColor: widget.backgroundColor ?? _kDefaultBackgroundColor,
        ),
      );
    } else {
      var playedValue = widget.progress!.position / widget.progress!.duration;
      var bufferedValue = math.max((widget.progress!.buffered ?? 0) / widget.progress!.duration, playedValue);
      var width = context.findRenderObject()?.semanticBounds.width;
      if (width == null) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          if (mounted) setState(() {});
        });
      }

      var showThumb = widget.allowScrubbing == true && width != null;
      var height = indicatorHeight;
      if (showThumb) {
        height = math.max(indicatorHeight, thumbSize);
      }

      progressIndicator = Stack(
        fit: StackFit.passthrough,
        children: [
          SizedBox(
            height: height,
            child: Center(
              child: SizedBox(
                height: indicatorHeight,
                child: LinearProgressIndicator(
                  value: bufferedValue,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.bufferedColor ?? _kDefaultBufferedColor),
                  backgroundColor: widget.backgroundColor ?? _kDefaultBackgroundColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height,
            child: Center(
              child: SizedBox(
                height: indicatorHeight,
                child: LinearProgressIndicator(
                  value: playedValue,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.playedColor ?? _kDefaultPlayedColor),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
          if (showThumb)
            Positioned(
              top: 0,
              bottom: 0,
              left: math.max(0, math.min(width * playedValue - thumbSize / 2, width - thumbSize)),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.thumbColor ?? _kDefaultThumbColor,
                  ),
                  width: thumbSize,
                  height: thumbSize,
                ),
              ),
            ),
        ],
      );
    }

    if (widget.progress == null || widget.allowScrubbing != true) {
      return Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: progressIndicator,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: progressIndicator,
      ),
      onHorizontalDragStart: (DragStartDetails details) {
        if (!_tappingDown) {
          widget.onScrubStart?.call();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        widget.onScrubbing?.call(_getProgress(details.globalPosition));
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        _tappingDown = false;
        widget.onScrubEnd?.call();
      },
      onTapDown: (TapDownDetails details) {
        _tappingDown = true;
        widget.onScrubStart?.call();
        widget.onScrubbing?.call(_getProgress(details.globalPosition));
      },
      onTapUp: (TapUpDetails details) {
        if (_tappingDown) {
          _tappingDown = false;
          widget.onScrubEnd?.call();
        }
      },
    );
  }
}
