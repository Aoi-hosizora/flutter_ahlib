import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/image/local_or_cached_network_image_provider.dart';
import 'package:octo_image/octo_image.dart';

// Note: This file is based on Baseflow/flutter_cached_network_image, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source code:
// - CachedNetworkImage: https://github.com/Baseflow/flutter_cached_network_image/blob/v3.1.0/cached_network_image/lib/src/cached_image_widget.dart

/// An image widget that uses [OctoImage] to show [LocalOrCachedNetworkImageProvider] image,
/// which is almost the same as [CachedNetworkImage].
class LocalOrCachedNetworkImage extends StatelessWidget {
  /// Constructs a [LocalOrCachedNetworkImage] by given [LocalOrCachedNetworkImageProvider] and
  /// other parameters.
  const LocalOrCachedNetworkImage({
    Key? key,
    required this.provider,
    this.imageBuilder,
    this.placeholderBuilder,
    this.progressIndicatorBuilder,
    this.errorBuilder,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration = Duration.zero,
    this.gaplessPlayback = false,
    this.memCacheWidth,
    this.memCacheHeight,
  }) : super(key: key);

  /// The [ImageProvider] used by [OctoImage].
  final LocalOrCachedNetworkImageProvider provider;

  /// Mirrors to [OctoImage.imageBuilder].
  final Widget Function(BuildContext context, ImageProvider imageProvider)? imageBuilder;

  /// Mirrors to [OctoImage.placeholderBuilder].
  final OctoPlaceholderBuilder? placeholderBuilder;

  /// Mirrors to [OctoImage.progressIndicatorBuilder].
  final OctoProgressIndicatorBuilder? progressIndicatorBuilder;

  /// Mirrors to [OctoImage.errorBuilder].
  final OctoErrorBuilder? errorBuilder;

  /// Mirrors to [OctoImage.fadeOutDuration].
  final Duration? fadeOutDuration;

  /// Mirrors to [OctoImage.fadeOutCurve].
  final Curve? fadeOutCurve;

  /// Mirrors to [OctoImage.fadeInDuration].
  final Duration? fadeInDuration;

  /// Mirrors to [OctoImage.fadeInCurve].
  final Curve? fadeInCurve;

  /// Mirrors to [OctoImage.width].
  final double? width;

  /// Mirrors to [OctoImage.height].
  final double? height;

  /// Mirrors to [OctoImage.fit].
  final BoxFit? fit;

  /// Mirrors to [OctoImage.alignment].
  final Alignment? alignment;

  /// Mirrors to [OctoImage.repeat].
  final ImageRepeat? repeat;

  /// Mirrors to [OctoImage.matchTextDirection].
  final bool? matchTextDirection;

  /// Mirrors to [OctoImage.color].
  final Color? color;

  /// Mirrors to [OctoImage.filterQuality].
  final FilterQuality? filterQuality;

  /// Mirrors to [OctoImage.colorBlendMode].
  final BlendMode? colorBlendMode;

  /// Mirrors to [OctoImage.placeholderFadeInDuration].
  final Duration? placeholderFadeInDuration;

  /// Mirrors to [OctoImage.gaplessPlayback].
  final bool? gaplessPlayback;

  /// Mirrors to [OctoImage.memCacheWidth].
  final int? memCacheWidth;

  /// Mirrors to [OctoImage.memCacheHeight].
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    var placeholderBuilder = this.placeholderBuilder == null && progressIndicatorBuilder == null //
        ? (_) => const SizedBox.shrink() // OctoImage does not fade if there is no placeholder, so always set an empty placeholder (by CachedNetworkImage)
        : this.placeholderBuilder;

    return OctoImage(
      image: provider,
      imageBuilder: imageBuilder == null ? null : (c, _) => imageBuilder!.call(c, provider),
      placeholderBuilder: placeholderBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorBuilder: errorBuilder,
      fadeOutDuration: fadeOutDuration,
      fadeOutCurve: fadeOutCurve,
      fadeInDuration: fadeInDuration,
      fadeInCurve: fadeInCurve,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      color: color,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      placeholderFadeInDuration: placeholderFadeInDuration,
      gaplessPlayback: gaplessPlayback,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
    );
  }
}
