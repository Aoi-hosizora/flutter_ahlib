import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/preloadable_page_view.dart';
import 'package:photo_view/photo_view.dart';

// Note: The file is based on bluefireteam/photo_view, and is modified by Aoi-hosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - PhotoViewGallery: https://github.com/bluefireteam/photo_view/blob/0.14.0/lib/photo_view_gallery.dart

/// This is an extended [PhotoViewGallery], is used to show multiple [PhotoView] widgets in a [PageView]. Extended
/// features include: reload behavior (through [ExtendedPhotoGalleryState.reload]), custom viewport factor, advance
/// page builder (through [ExtendedPhotoGallery.advanced]).
class ExtendedPhotoGallery extends StatefulWidget {
  /// Constructs a gallery with static photo items through a list of [ExtendedPhotoGalleryPageOptions].
  const ExtendedPhotoGallery({
    Key? key,
    required List<ExtendedPhotoGalleryPageOptions> this.pageOptions,
    this.backgroundDecoration,
    this.wantKeepAlive = false,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.pageController,
    this.onPageChanged,
    this.changePageWhenFinished = false,
    this.keepViewportMainAxisSize = true,
    this.fractionWidthFactor,
    this.fractionHeightFactor,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.loadingBuilder,
    this.errorBuilder,
    this.pageMainAxisHintSize,
    this.preloadPagesCount = 0,
  })  : pageCount = null,
        builder = null,
        advancedBuilder = null,
        super(key: key);

  /// Constructs a gallery with dynamic photo items. The builder must return a [ExtendedPhotoGalleryPageOptions].
  const ExtendedPhotoGallery.builder({
    Key? key,
    required int this.pageCount,
    required ExtendedPhotoGalleryPageOptions Function(BuildContext context, int index) this.builder,
    this.backgroundDecoration,
    this.wantKeepAlive = false,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.pageController,
    this.onPageChanged,
    this.changePageWhenFinished = false,
    this.keepViewportMainAxisSize = true,
    this.fractionWidthFactor,
    this.fractionHeightFactor,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.loadingBuilder,
    this.errorBuilder,
    this.pageMainAxisHintSize,
    this.preloadPagesCount = 0,
  })  : pageOptions = null,
        advancedBuilder = null,
        super(key: key);

// TODO test advanced in example

  /// Constructs a gallery with advanced page builder, by [builder] and [advancedBuilder].
  const ExtendedPhotoGallery.advanced({
    Key? key,
    required int this.pageCount,
    required ExtendedPhotoGalleryPageOptions Function(BuildContext context, int index) this.builder,
    required Widget Function(BuildContext context, int index, Widget Function(BuildContext context, int index) photoPageBuilder) this.advancedBuilder,
    this.backgroundDecoration,
    this.wantKeepAlive = false,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.pageController,
    this.onPageChanged,
    this.changePageWhenFinished = false,
    this.keepViewportMainAxisSize = true,
    this.fractionWidthFactor,
    this.fractionHeightFactor,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.loadingBuilder,
    this.errorBuilder,
    this.pageMainAxisHintSize,
    this.preloadPagesCount = 0,
  })  : pageOptions = null,
        super(key: key);

  /// A list of options to describe the photo items in the gallery.
  final List<ExtendedPhotoGalleryPageOptions>? pageOptions;

  /// The count of pages in the gallery, only used when constructed via [ExtendedPhotoGallery.builder] and [ExtendedPhotoGallery.advancedBuilder].
  final int? pageCount;

  /// Called to build photo pages for the gallery, here index need exclude non-[PhotoView] pages.
  final ExtendedPhotoGalleryPageOptions Function(BuildContext context, int index)? builder;

  /// Called to build not-only-[PhotoView] pages for the gallery, note that index passed to photoPageBuilder should exclude non-[PhotoView] pages.
  final Widget Function(BuildContext context, int index, Widget Function(BuildContext context, int index) photoPageBuilder)? advancedBuilder;

  /// [ScrollPhysics] for the internal [PageView].
  final ScrollPhysics? scrollPhysics;

  /// Mirror to [PhotoView.backgroundDecoration].
  final BoxDecoration? backgroundDecoration;

  /// Mirror to [PhotoView.wantKeepAlive].
  final bool wantKeepAlive;

  /// Mirror to [PhotoView.gaplessPlayback].
  final bool gaplessPlayback;

  /// Mirror to [PageView.reverse].
  final bool reverse;

  /// An object that controls the [PageView] inside [ExtendedPhotoGallery].
  final PageController? pageController;

  /// An callback to be called on a page change.
  final void Function(int index)? onPageChanged;

  /// Mirror to [PreloadablePageView.changePageWhenFinished].
  final bool changePageWhenFinished;

  /// The flag for keeping main axis size of each photo page to origin size (which is the same as default identical viewport fraction), defaults
  /// to false. Note that if [fractionWidthFactor] or [fractionHeightFactor] set to null or non positive number, the fractional page factor
  /// will be depended by [keepViewportMainAxisSize] and [PageController.viewportFraction].
  final bool keepViewportMainAxisSize;

  /// The width factor for each fractional photo page. Note that this value may disable [keepViewportMainAxisSize] when scroll horizontally.
  final double? fractionWidthFactor;

  /// The height factor for each fractional photo page. Note that this value may disable [keepViewportMainAxisSize] when scroll vertically.
  final double? fractionHeightFactor;

  /// Mirror to [PhotoView.scaleStateChangedCallback].
  final ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback;

  /// Mirror to [PhotoView.enableRotation].
  final bool enableRotation;

  /// Mirror to [PhotoView.customSize].
  final Size? customSize;

  /// The axis along which the [PageView] scrolls. Mirror to [PageView.scrollDirection].
  final Axis scrollDirection;

  /// Mirror to [PhotoView.loadingBuilder], is the default builder for photo items.
  final LoadingPlaceholderBuilder? loadingBuilder;

  /// Mirror to [PhotoView.errorBuilder], is the default builder for photo items.
  final ErrorPlaceholderBuilder? errorBuilder;

  /// Mirror to [PreloadablePageView.pageMainAxisHintSize].
  final double? pageMainAxisHintSize;

  /// Mirror to [PreloadablePageView.preloadPagesCount].
  final int preloadPagesCount;

// The readonly property for page count, determined by `pageOptions` or `pageCount`.
  int get _pageCount => builder != null ? pageCount! : pageOptions!.length;

  @override
  State<StatefulWidget> createState() => ExtendedPhotoGalleryState();
}

/// The state of [ExtendedPhotoGallery], can be used to [reload] the specific image from [ImageProvider].
class ExtendedPhotoGalleryState extends State<ExtendedPhotoGallery> {
  late var _controller = widget.pageController ?? PageController();
  late List<ValueNotifier<String>> _notifiers = List.generate(widget._pageCount, (index) => ValueNotifier(''));

  /// Returns the current page of the widget.
  int get currentPage => _controller.hasClients ? _controller.page!.floor() : 0;

  /// Returns the total page count of the widget.
  int get pageCount => widget._pageCount;

  /// Reloads the image of given index from [ImageProvider]. Note that here index should exclude non-[PhotoView] pages, when constructed via
  /// [ExtendedPhotoGallery.advancedBuilder].
  ///
  /// Example:
  /// ```
  /// final CacheManager _cache = DefaultCacheManager();
  /// // imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
  /// //   key: key,
  /// //   url: urls[idx],
  /// //   cacheManager: _cache,
  /// // )
  ///
  /// await _cache.removeFile(urls[_index]);
  /// _galleryKey.currentState?.reload(_index);
  /// ```
  void reload(int index) {
    _notifiers[index].value = DateTime.now().microsecondsSinceEpoch.toString();
    // no need to setState
  }

  @override
  void dispose() {
    if (widget.pageController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExtendedPhotoGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = oldWidget.pageController;
    final newController = widget.pageController;
    if (oldController != newController || //
        oldController?.initialPage != newController?.initialPage ||
        oldController?.keepPage != newController?.keepPage ||
        oldController?.viewportFraction != newController?.viewportFraction) {
      _controller = newController ?? PageController();
    }
    if (widget._pageCount != oldWidget._pageCount) {
      _notifiers = List.generate(widget._pageCount, (index) => ValueNotifier(''));
    }
  }

  ExtendedPhotoGalleryPageOptions _buildPageOption(BuildContext context, int index) {
    if (widget.builder != null) {
      return widget.builder!(context, index);
    }
    return widget.pageOptions![index];
  }

  Widget _buildPhotoItem(BuildContext context, int index) {
    final pageOption = _buildPageOption(context, index); // index excludes non-PhotoView pages
    return ClipRect(
      child: ValueListenableBuilder<String>(
        valueListenable: _notifiers[index], // <<<
        builder: (_, v, __) => PhotoView(
          key: ValueKey('$index-$v'),
          imageProvider: pageOption.imageProviderBuilder(ValueKey('$index-$v')),
          backgroundDecoration: widget.backgroundDecoration,
          wantKeepAlive: widget.wantKeepAlive,
          controller: pageOption.controller,
          scaleStateController: pageOption.scaleStateController,
          customSize: widget.customSize,
          gaplessPlayback: widget.gaplessPlayback,
          heroAttributes: pageOption.heroAttributes,
          scaleStateChangedCallback: (state) => widget.scaleStateChangedCallback?.call(state),
          enableRotation: widget.enableRotation,
          initialScale: pageOption.initialScale,
          minScale: pageOption.minScale,
          maxScale: pageOption.maxScale,
          scaleStateCycle: pageOption.scaleStateCycle,
          onTapUp: pageOption.onTapUp,
          onTapDown: pageOption.onTapDown,
          onScaleEnd: pageOption.onScaleEnd,
          gestureDetectorBehavior: pageOption.gestureDetectorBehavior,
          tightMode: pageOption.tightMode,
          filterQuality: pageOption.filterQuality,
          basePosition: pageOption.basePosition,
          disableGestures: pageOption.disableGestures,
          enablePanAlways: pageOption.enablePanAlways,
          loadingBuilder: pageOption.loadingBuilder ?? widget.loadingBuilder,
          errorBuilder: pageOption.errorBuilder ?? widget.errorBuilder,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double? widthFactor = widget.fractionWidthFactor;
    double? heightFactor = widget.fractionHeightFactor;
    if (widget.keepViewportMainAxisSize) {
      if (widget.scrollDirection == Axis.horizontal && (widthFactor == null || widthFactor <= 0)) {
        widthFactor = 1 / _controller.viewportFraction;
      }
      if (widget.scrollDirection == Axis.vertical && (heightFactor == null || heightFactor <= 0)) {
        heightFactor = 1 / _controller.viewportFraction;
      }
    }

    Widget _buildPage(BuildContext context, int index) {
      if (widget.advancedBuilder == null) {
        return _buildPhotoItem(context, index);
      }
      return widget.advancedBuilder!.call(context, index, _buildPhotoItem);
    }

    // Enable corner hit test
    return PhotoViewGestureDetectorScope(
      axis: widget.scrollDirection,
      child: PreloadablePageView.builder(
        controller: _controller,
        onPageChanged: widget.onPageChanged,
        changePageWhenFinished: widget.changePageWhenFinished,
        physics: widget.scrollPhysics,
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection,
        pageMainAxisHintSize: widget.pageMainAxisHintSize,
        preloadPagesCount: widget.preloadPagesCount,
        itemCount: widget._pageCount,
        itemBuilder: (context, index) => FractionallySizedBox(
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          child: _buildPage(context, index),
        ),
      ),
    );
  }
}

/// Signature for creating a replacement widget to render while the image is loading.
typedef LoadingPlaceholderBuilder = Widget Function(
  BuildContext context,
  ImageChunkEvent? event,
);

/// Signature for creating a replacement widget to render while it is failed to load the image.
typedef ErrorPlaceholderBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

/// A helper class that wraps individual options of a page in [ExtendedPhotoGallery].
class ExtendedPhotoGalleryPageOptions {
  const ExtendedPhotoGalleryPageOptions({
    required this.imageProviderBuilder,
    this.heroAttributes,
    this.minScale,
    this.maxScale,
    this.initialScale,
    this.controller,
    this.scaleStateController,
    this.basePosition,
    this.scaleStateCycle,
    this.onTapUp,
    this.onTapDown,
    this.onScaleEnd,
    this.gestureDetectorBehavior,
    this.tightMode,
    this.disableGestures,
    this.enablePanAlways,
    this.filterQuality,
    this.loadingBuilder,
    this.errorBuilder,
  });

  /// Mirror to [PhotoView.imageProvider].
  final ImageProvider Function(ValueKey key) imageProviderBuilder;

  /// Mirror to [PhotoView.heroAttributes].
  final PhotoViewHeroAttributes? heroAttributes;

  /// Mirror to [PhotoView.minScale].
  final dynamic minScale;

  /// Mirror to [PhotoView.maxScale].
  final dynamic maxScale;

  /// Mirror to [PhotoView.initialScale].
  final dynamic initialScale;

  /// Mirror to [PhotoView.controller].
  final PhotoViewController? controller;

  /// Mirror to [PhotoView.scaleStateController].
  final PhotoViewScaleStateController? scaleStateController;

  /// Mirror to [PhotoView.basePosition].
  final Alignment? basePosition;

  /// Mirror to [PhotoView.scaleStateCycle].
  final ScaleStateCycle? scaleStateCycle;

  /// Mirror to [PhotoView.onTapUp].
  final PhotoViewImageTapUpCallback? onTapUp;

  /// Mirror to [PhotoView.onTapDown].
  final PhotoViewImageTapDownCallback? onTapDown;

  /// Mirror to [PhotoView.onScaleEnd].
  final PhotoViewImageScaleEndCallback? onScaleEnd;

  /// Mirror to [PhotoView.gestureDetectorBehavior].
  final HitTestBehavior? gestureDetectorBehavior;

  /// Mirror to [PhotoView.tightMode].
  final bool? tightMode;

  /// Mirror to [PhotoView.disableGestures].
  final bool? disableGestures;

  /// Mirror to [PhotoView.enablePanAlways].
  final bool? enablePanAlways;

  /// Quality levels for image filters.
  final FilterQuality? filterQuality;

  /// Mirror to [PhotoView.loadingBuilder].
  final LoadingPlaceholderBuilder? loadingBuilder;

  /// Mirror to [PhotoView.errorBuilder].
  final ErrorPlaceholderBuilder? errorBuilder;
}
