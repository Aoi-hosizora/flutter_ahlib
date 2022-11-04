import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// Note: The file is based on bluefireteam/photo_view, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - PhotoView: https://github.com/bluefireteam/photo_view/blob/0.14.0/lib/photo_view.dart
// - ImageWrapper: https://github.com/bluefireteam/photo_view/blob/0.14.0/lib/src/photo_view_wrappers.dart

/// Signature for building an [ImageProvider] with given [ValueKey], which can be used to reload image.
typedef ImageProviderBuilder = ImageProvider Function(ValueKey<String> key);

/// Signature for creating a replacement widget to render while the image is loading.
typedef LoadingPlaceholderBuilder = Widget Function(BuildContext context, ImageChunkEvent? event);

/// Signature for creating a replacement widget to render while it is failed to load the image.
typedef ErrorPlaceholderBuilder = Widget Function(BuildContext context, Object error, StackTrace? stackTrace);

/// A reloadable [PhotoView], which uses given [ValueKey] for [ImageProvider] (such as [LocalOrCachedNetworkImageProvider]),
/// to reload it, through [ReloadablePhotoViewState.reload] method.
class ReloadablePhotoView extends StatefulWidget {
  /// Constructs a [ReloadablePhotoView] with non-null [imageProviderBuilder].
  const ReloadablePhotoView({
    Key? key,
    required this.imageProviderBuilder,
    // almost be used frequently
    this.initialScale,
    this.minScale,
    this.maxScale,
    this.backgroundDecoration,
    this.filterQuality,
    this.onTapDown,
    this.onTapUp,
    this.loadingBuilder,
    this.errorBuilder,
    // may be used infrequently
    this.basePosition,
    this.controller,
    this.customSize,
    this.disableGestures,
    this.enablePanAlways,
    this.enableRotation,
    this.gaplessPlayback,
    this.gestureDetectorBehavior,
    this.heroAttributes,
    this.onScaleEnd,
    this.scaleStateController,
    this.scaleStateChangedCallback,
    this.scaleStateCycle,
    this.tightMode,
    this.wantKeepAlive,
  }) : super(key: key);

  /// The [ImageProvider] builder with [ValueKey], which can be used to reload it.
  final ImageProviderBuilder imageProviderBuilder;

  // almost be used frequently

  /// Mirrors to [PhotoView.initialScale], defaults to [PhotoViewComputedScale.contained].
  final dynamic initialScale;

  /// Mirrors to [PhotoView.minScale], defaults to 0.0.
  final dynamic minScale;

  /// Mirrors to [PhotoView.maxScale], defaults to [double.infinity].
  final dynamic maxScale;

  /// Mirrors to [PhotoView.backgroundDecoration], defaults to `BoxDecoration(color: Colors.black)`.
  final BoxDecoration? backgroundDecoration;

  /// Mirrors to [PhotoView.filterQuality], defaults to [FilterQuality.none].
  final FilterQuality? filterQuality;

  /// Mirrors to [PhotoView.onTapDown].
  final PhotoViewImageTapDownCallback? onTapDown;

  /// Mirrors to [PhotoView.onTapUp].
  final PhotoViewImageTapUpCallback? onTapUp;

  /// Mirrors to [PhotoView.loadingBuilder], defaults to use [PhotoViewDefaultLoading], which only contains a [CircularProgressIndicator].
  final LoadingPlaceholderBuilder? loadingBuilder;

  /// Mirrors to [PhotoView.errorBuilder], defaults to use [PhotoViewDefaultError], which only contains an [Icons.broken_image] icon.
  final ErrorPlaceholderBuilder? errorBuilder;

  // may be used infrequently

  /// Mirrors to [PhotoView.basePosition], defaults to [Alignment.center].
  final Alignment? basePosition;

  /// Mirrors to [PhotoView.controller].
  final PhotoViewControllerBase? controller;

  /// Mirrors to [PhotoView.customSize].
  final Size? customSize;

  /// Mirrors to [PhotoView.disableGestures], defaults to false.
  final bool? disableGestures;

  /// Mirrors to [PhotoView.enablePanAlways], defaults to false.
  final bool? enablePanAlways;

  /// Mirrors to [PhotoView.enableRotation], defaults to false.
  final bool? enableRotation;

  /// Mirrors to [PhotoView.gaplessPlayback], defaults to false.
  final bool? gaplessPlayback;

  /// Mirrors to [PhotoView.gestureDetectorBehavior].
  final HitTestBehavior? gestureDetectorBehavior;

  /// Mirrors to [PhotoView.heroAttributes].
  final PhotoViewHeroAttributes? heroAttributes;

  /// Mirrors to [PhotoView.onScaleEnd].
  final PhotoViewImageScaleEndCallback? onScaleEnd;

  /// Mirrors to [PhotoView.scaleStateController].
  final PhotoViewScaleStateController? scaleStateController;

  /// Mirrors to [PhotoView.scaleStateChangedCallback].
  final ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback;

  /// Mirrors to [PhotoView.scaleStateCycle], defaults to [defaultScaleStateCycle].
  final ScaleStateCycle? scaleStateCycle;

  /// Mirrors to [PhotoView.tightMode], defaults to false.
  final bool? tightMode;

  /// Mirrors to [PhotoView.wantKeepAlive], defaults to false.
  final bool? wantKeepAlive;

  @override
  State<ReloadablePhotoView> createState() => ReloadablePhotoViewState();
}

/// The state of [ReloadablePhotoView], which can be used to reload the photo view by [reload] method.
class ReloadablePhotoViewState extends State<ReloadablePhotoView> {
  final _notifier = ValueNotifier<String>('');

  /// Reloads the [ImageProvider] from [ReloadablePhotoView].
  ///
  /// Example:
  /// ```
  /// final _photoViewKey = GlobalKey<ReloadablePhotoViewState>();
  /// final CacheManager _cache = DefaultCacheManager();
  ///
  /// ReloadablePhotoView(
  ///   key: _photoViewKey,
  ///   imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
  ///     key: key,
  ///     url: url,
  ///     cacheManager: _cache,
  ///   ),
  ///   // ...
  /// );
  ///
  /// await _cache.removeFile(url);
  /// _photoViewKey.currentState?.reload();
  /// ```
  void reload() {
    _notifier.value = DateTime.now().microsecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _notifier, // <<<
      builder: (_, v, __) => PhotoView(
        imageProvider: widget.imageProviderBuilder.call(ValueKey<String>(v)),
        // almost be used frequently
        initialScale: widget.initialScale ?? PhotoViewComputedScale.contained,
        minScale: widget.minScale ?? 0.0,
        maxScale: widget.maxScale ?? double.infinity,
        backgroundDecoration: widget.backgroundDecoration ?? const BoxDecoration(color: Colors.black),
        filterQuality: widget.filterQuality ?? FilterQuality.none,
        onTapDown: widget.onTapDown,
        onTapUp: widget.onTapUp,
        loadingBuilder: widget.loadingBuilder, // TODO bug ???
        errorBuilder: widget.errorBuilder, // TODO bug ???
        // may be used infrequently
        basePosition: widget.basePosition ?? Alignment.center,
        controller: widget.controller,
        customSize: widget.customSize,
        disableGestures: widget.disableGestures ?? false,
        enablePanAlways: widget.enablePanAlways ?? false,
        enableRotation: widget.enableRotation ?? false,
        gaplessPlayback: widget.gaplessPlayback ?? false,
        gestureDetectorBehavior: widget.gestureDetectorBehavior,
        heroAttributes: widget.heroAttributes,
        onScaleEnd: widget.onScaleEnd,
        scaleStateController: widget.scaleStateController,
        scaleStateChangedCallback: widget.scaleStateChangedCallback,
        scaleStateCycle: widget.scaleStateCycle ?? defaultScaleStateCycle,
        tightMode: widget.tightMode ?? false,
        wantKeepAlive: widget.wantKeepAlive ?? false,
      ),
    );
  }
}

/// A helper class that contains all reusable options of [ReloadablePhotoView].
class PhotoViewOptions {
  const PhotoViewOptions({
    // almost be used frequently
    this.initialScale,
    this.minScale,
    this.maxScale,
    this.backgroundDecoration,
    this.filterQuality,
    this.onTapDown,
    this.onTapUp,
    this.loadingBuilder,
    this.errorBuilder,
    // may be used infrequently
    this.basePosition,
    this.controller,
    this.customSize,
    this.disableGestures,
    this.enablePanAlways,
    this.enableRotation,
    this.gaplessPlayback,
    this.gestureDetectorBehavior,
    this.heroAttributes,
    this.onScaleEnd,
    this.scaleStateController,
    this.scaleStateChangedCallback,
    this.scaleStateCycle,
    this.tightMode,
    this.wantKeepAlive,
  });

  // almost be used frequently
  final dynamic initialScale;
  final dynamic minScale;
  final dynamic maxScale;
  final BoxDecoration? backgroundDecoration;
  final FilterQuality? filterQuality;
  final PhotoViewImageTapDownCallback? onTapDown;
  final PhotoViewImageTapUpCallback? onTapUp;
  final LoadingPlaceholderBuilder? loadingBuilder;
  final ErrorPlaceholderBuilder? errorBuilder;

  // may be used infrequently
  final Alignment? basePosition;
  final PhotoViewControllerBase? controller;
  final Size? customSize;
  final bool? disableGestures;
  final bool? enablePanAlways;
  final bool? enableRotation;
  final bool? gaplessPlayback;
  final HitTestBehavior? gestureDetectorBehavior;
  final PhotoViewHeroAttributes? heroAttributes;
  final PhotoViewImageScaleEndCallback? onScaleEnd;
  final PhotoViewScaleStateController? scaleStateController;
  final ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback;
  final ScaleStateCycle? scaleStateCycle;
  final bool? tightMode;
  final bool? wantKeepAlive;

  /// Returns a new value that is a combination of this value and the given [other] value.
  PhotoViewOptions merge(PhotoViewOptions? other) {
    return PhotoViewOptions(
      // almost be used frequently
      initialScale: other?.initialScale ?? initialScale,
      minScale: other?.minScale ?? minScale,
      maxScale: other?.maxScale ?? maxScale,
      backgroundDecoration: other?.backgroundDecoration ?? backgroundDecoration,
      filterQuality: other?.filterQuality ?? filterQuality,
      onTapDown: other?.onTapDown ?? onTapDown,
      onTapUp: other?.onTapUp ?? onTapUp,
      loadingBuilder: other?.loadingBuilder ?? loadingBuilder,
      errorBuilder: other?.errorBuilder ?? errorBuilder,
      // may be used infrequently
      basePosition: other?.basePosition ?? basePosition,
      controller: other?.controller ?? controller,
      customSize: other?.customSize ?? customSize,
      disableGestures: other?.disableGestures ?? disableGestures,
      enablePanAlways: other?.enablePanAlways ?? enablePanAlways,
      enableRotation: other?.enableRotation ?? enableRotation,
      gaplessPlayback: other?.gaplessPlayback ?? gaplessPlayback,
      gestureDetectorBehavior: other?.gestureDetectorBehavior ?? gestureDetectorBehavior,
      heroAttributes: other?.heroAttributes ?? heroAttributes,
      onScaleEnd: other?.onScaleEnd ?? onScaleEnd,
      scaleStateController: other?.scaleStateController ?? scaleStateController,
      scaleStateChangedCallback: other?.scaleStateChangedCallback ?? scaleStateChangedCallback,
      scaleStateCycle: other?.scaleStateCycle ?? scaleStateCycle,
      tightMode: other?.tightMode ?? tightMode,
      wantKeepAlive: other?.wantKeepAlive ?? wantKeepAlive,
    );
  }
}
