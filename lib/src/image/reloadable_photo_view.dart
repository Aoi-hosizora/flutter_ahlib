import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// Note: This file is based on bluefireteam/photo_view, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source code:
// - PhotoView: https://github.com/bluefireteam/photo_view/blob/0.14.0/lib/photo_view.dart
// - ImageWrapper: https://github.com/bluefireteam/photo_view/blob/0.14.0/lib/src/photo_view_wrappers.dart

/// The signature for building an [ImageProvider] with given [ValueKey], which can be used to reload image.
typedef ImageProviderBuilder = ImageProvider Function(ValueKey<String> key);

/// The signature for creating a replacement widget to render while the image is loading.
typedef LoadingPlaceholderBuilder = Widget Function(BuildContext context, ImageChunkEvent? event);

/// The signature for creating a replacement widget to render while it is failed to load the image.
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
  /// final _cache = DefaultCacheManager();
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
  /// // to reload image
  /// await _cache.removeFile(url);
  /// _photoViewKey.currentState?.reload();
  /// ```
  void reload({bool alsoEvict = true}) {
    _notifier.value = DateTime.now().microsecondsSinceEpoch.toString();

    if (alsoEvict) {
      // evict from flutter ImageCache
      var key = ValueKey<String>(_notifier.value);
      widget.imageProviderBuilder.call(key).evict();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _notifier,
      builder: (_, v, __) => PhotoView(
        key: ValueKey<String>(v) /* <<< necessary */,
        imageProvider: widget.imageProviderBuilder.call(ValueKey<String>(v)),
        //
        initialScale: widget.initialScale ?? PhotoViewComputedScale.contained,
        minScale: widget.minScale ?? 0.0,
        maxScale: widget.maxScale ?? double.infinity,
        backgroundDecoration: widget.backgroundDecoration ?? const BoxDecoration(color: Colors.black),
        filterQuality: widget.filterQuality ?? FilterQuality.none,
        onTapDown: widget.onTapDown,
        onTapUp: widget.onTapUp,
        loadingBuilder: widget.loadingBuilder,
        errorBuilder: widget.errorBuilder,
        //
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
    this.initialScale,
    this.minScale,
    this.maxScale,
    this.backgroundDecoration,
    this.filterQuality,
    this.onTapDown,
    this.onTapUp,
    this.loadingBuilder,
    this.errorBuilder,
    //
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

  final dynamic initialScale;
  final dynamic minScale;
  final dynamic maxScale;
  final BoxDecoration? backgroundDecoration;
  final FilterQuality? filterQuality;
  final PhotoViewImageTapDownCallback? onTapDown;
  final PhotoViewImageTapUpCallback? onTapUp;
  final LoadingPlaceholderBuilder? loadingBuilder;
  final ErrorPlaceholderBuilder? errorBuilder;

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

  /// Creates a copy of this value but with given fields replaced with the new values.
  PhotoViewOptions copyWith({
    dynamic initialScale,
    dynamic minScale,
    dynamic maxScale,
    BoxDecoration? backgroundDecoration,
    FilterQuality? filterQuality,
    PhotoViewImageTapDownCallback? onTapDown,
    PhotoViewImageTapUpCallback? onTapUp,
    LoadingPlaceholderBuilder? loadingBuilder,
    ErrorPlaceholderBuilder? errorBuilder,
    //
    Alignment? basePosition,
    PhotoViewControllerBase? controller,
    Size? customSize,
    bool? disableGestures,
    bool? enablePanAlways,
    bool? enableRotation,
    bool? gaplessPlayback,
    HitTestBehavior? gestureDetectorBehavior,
    PhotoViewHeroAttributes? heroAttributes,
    PhotoViewImageScaleEndCallback? onScaleEnd,
    PhotoViewScaleStateController? scaleStateController,
    ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback,
    ScaleStateCycle? scaleStateCycle,
    bool? tightMode,
    bool? wantKeepAlive,
  }) {
    return PhotoViewOptions(
      initialScale: initialScale ?? this.initialScale,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      backgroundDecoration: backgroundDecoration ?? this.backgroundDecoration,
      filterQuality: filterQuality ?? this.filterQuality,
      onTapDown: onTapDown ?? this.onTapDown,
      onTapUp: onTapUp ?? this.onTapUp,
      loadingBuilder: loadingBuilder ?? this.loadingBuilder,
      errorBuilder: errorBuilder ?? this.errorBuilder,
      //
      basePosition: basePosition ?? this.basePosition,
      controller: controller ?? this.controller,
      customSize: customSize ?? this.customSize,
      disableGestures: disableGestures ?? this.disableGestures,
      enablePanAlways: enablePanAlways ?? this.enablePanAlways,
      enableRotation: enableRotation ?? this.enableRotation,
      gaplessPlayback: gaplessPlayback ?? this.gaplessPlayback,
      gestureDetectorBehavior: gestureDetectorBehavior ?? this.gestureDetectorBehavior,
      heroAttributes: heroAttributes ?? this.heroAttributes,
      onScaleEnd: onScaleEnd ?? this.onScaleEnd,
      scaleStateController: scaleStateController ?? this.scaleStateController,
      scaleStateChangedCallback: scaleStateChangedCallback ?? this.scaleStateChangedCallback,
      scaleStateCycle: scaleStateCycle ?? this.scaleStateCycle,
      tightMode: tightMode ?? this.tightMode,
      wantKeepAlive: wantKeepAlive ?? this.wantKeepAlive,
    );
  }

  /// Creates a new value that is a combination of given value and fallback value.
  static PhotoViewOptions merge(PhotoViewOptions options, PhotoViewOptions? fallback) {
    return PhotoViewOptions(
      initialScale: options.initialScale ?? fallback?.initialScale,
      minScale: options.minScale ?? fallback?.minScale,
      maxScale: options.maxScale ?? fallback?.maxScale,
      backgroundDecoration: options.backgroundDecoration ?? fallback?.backgroundDecoration,
      filterQuality: options.filterQuality ?? fallback?.filterQuality,
      onTapDown: options.onTapDown ?? fallback?.onTapDown,
      onTapUp: options.onTapUp ?? fallback?.onTapUp,
      loadingBuilder: options.loadingBuilder ?? fallback?.loadingBuilder,
      errorBuilder: options.errorBuilder ?? fallback?.errorBuilder,
      //
      basePosition: options.basePosition ?? fallback?.basePosition,
      controller: options.controller ?? fallback?.controller,
      customSize: options.customSize ?? fallback?.customSize,
      disableGestures: options.disableGestures ?? fallback?.disableGestures,
      enablePanAlways: options.enablePanAlways ?? fallback?.enablePanAlways,
      enableRotation: options.enableRotation ?? fallback?.enableRotation,
      gaplessPlayback: options.gaplessPlayback ?? fallback?.gaplessPlayback,
      gestureDetectorBehavior: options.gestureDetectorBehavior ?? fallback?.gestureDetectorBehavior,
      heroAttributes: options.heroAttributes ?? fallback?.heroAttributes,
      onScaleEnd: options.onScaleEnd ?? fallback?.onScaleEnd,
      scaleStateController: options.scaleStateController ?? fallback?.scaleStateController,
      scaleStateChangedCallback: options.scaleStateChangedCallback ?? fallback?.scaleStateChangedCallback,
      scaleStateCycle: options.scaleStateCycle ?? fallback?.scaleStateCycle,
      tightMode: options.tightMode ?? fallback?.tightMode,
      wantKeepAlive: options.wantKeepAlive ?? fallback?.wantKeepAlive,
    );
  }
}
