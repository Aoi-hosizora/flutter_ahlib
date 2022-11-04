import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/image/reloadable_photo_view.dart';
import 'package:flutter_ahlib/src/widget/preloadable_page_view.dart';
import 'package:photo_view/photo_view.dart';

// Note: The file is based on bluefireteam/photo_view, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - PhotoViewGallery: https://github.com/bluefireteam/photo_view/blob/0.14.0/lib/photo_view_gallery.dart

/// Signature for building a [ExtendedPhotoGalleryPageOptions] with given page index.
typedef ExtendedPhotoGalleryPageOptionsBuilder = ExtendedPhotoGalleryPageOptions Function(BuildContext context, int index);

/// Signature for building a photo page in [ExtendedPhotoGallery] with given page index.
typedef ExtendedPhotoGalleryPageBuilder = Widget Function(BuildContext context, int index);

/// Signature for building a page in [ExtendedPhotoGallery], with given page index and photo page builder.
typedef AdvancedPhotoGalleryPageBuilder = Widget Function(BuildContext context, int index, ExtendedPhotoGalleryPageBuilder photoPageBuilder);

/// An extended [PhotoViewGallery], which is used to show multiple [PhotoView] widgets in a [PageView]. Extended
/// features include: reload behavior (through [ExtendedPhotoGalleryState.reloadPhoto]), custom viewport factor,
/// advance page builder (through [ExtendedPhotoGallery.advanced]).
class ExtendedPhotoGallery extends StatefulWidget {
  /// Constructs a gallery with static photo pages through a list of [ExtendedPhotoGalleryPageOptions].
  const ExtendedPhotoGallery({
    Key? key,
    required List<ExtendedPhotoGalleryPageOptions> this.pageOptions,
    // for PhotoView fallback
    this.fallbackOptions,
    // for PageView settings
    this.onPageChanged,
    this.pageController,
    this.reverse = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    // for extended settings
    this.changePageWhenFinished = false,
    this.keepViewportMainAxisSize = true,
    this.fractionWidthFactor,
    this.fractionHeightFactor,
    this.pageMainAxisHintSize,
    this.preloadPagesCount = 0,
  })  : pageCount = null,
        builder = null,
        advancedBuilder = null,
        super(key: key);

  /// Constructs a gallery with dynamic photo pages. The builder must return a [ExtendedPhotoGalleryPageOptions].
  const ExtendedPhotoGallery.builder({
    Key? key,
    required int this.pageCount,
    required ExtendedPhotoGalleryPageOptionsBuilder this.builder,
    // for PhotoView fallback
    this.fallbackOptions,
    // for PageView settings
    this.onPageChanged,
    this.pageController,
    this.reverse = false,
    this.scrollDirection = Axis.horizontal,
    this.scrollPhysics,
    // for extended settings
    this.changePageWhenFinished = false,
    this.keepViewportMainAxisSize = true,
    this.fractionWidthFactor,
    this.fractionHeightFactor,
    this.pageMainAxisHintSize,
    this.preloadPagesCount = 0,
  })  : pageOptions = null,
        advancedBuilder = null,
        super(key: key);

  /// Constructs a gallery with advanced page builder, by [builder] and [advancedBuilder].
  const ExtendedPhotoGallery.advanced({
    Key? key,
    required int this.pageCount,
    required ExtendedPhotoGalleryPageOptionsBuilder this.builder,
    required AdvancedPhotoGalleryPageBuilder this.advancedBuilder,
    // for PhotoView fallback
    this.fallbackOptions,
    // for PageView settings
    this.onPageChanged,
    this.pageController,
    this.reverse = false,
    this.scrollDirection = Axis.horizontal,
    this.scrollPhysics,
    // for extended settings
    this.changePageWhenFinished = false,
    this.keepViewportMainAxisSize = true,
    this.fractionWidthFactor,
    this.fractionHeightFactor,
    this.pageMainAxisHintSize,
    this.preloadPagesCount = 0,
  })  : pageOptions = null,
        super(key: key);

  /// The list of options to describe the photo pages in the gallery.
  final List<ExtendedPhotoGalleryPageOptions>? pageOptions;

  /// The count of pages (not only photo pages) in the gallery, only used when constructed via
  /// [ExtendedPhotoGallery.builder] and [ExtendedPhotoGallery.advancedBuilder].
  final int? pageCount;

  /// Called to build photo pages for the gallery, here index should exclude non-photo pages.
  final ExtendedPhotoGalleryPageOptionsBuilder? builder;

  /// Called to build all pages (not only photo pages) for the gallery, note that [builder] will be called
  /// through [photoPageBuilder], so index passed to [photoPageBuilder] should exclude non-photo pages.
  final AdvancedPhotoGalleryPageBuilder? advancedBuilder;

  // for PhotoView fallback

  /// The fallback options for photo pages, which has almost the same fields as [ExtendedPhotoGalleryPageOptions].
  final PhotoViewOptions? fallbackOptions;

  // for PageView settings

  /// A callback to be called on a page change.
  final void Function(int index)? onPageChanged;

  /// An object that controls the [PageView] inside [ExtendedPhotoGallery].
  final PageController? pageController;

  /// The flag for whether the page view scrolls in the reading direction.
  final bool reverse;

  /// The [ScrollPhysics] for the internal [PageView].
  final ScrollPhysics? scrollPhysics;

  /// The axis along which the [PageView] scrolls. Mirrors to [PageView.scrollDirection].
  final Axis scrollDirection;

  // for extended settings

  /// The flag to call [onPageChanged] when page changing is finished. Note that listeners in
  /// [PageController] will still be called when round value of page offset changed.
  final bool changePageWhenFinished;

  /// The flag for keeping main axis size of each photo page to origin size (which is the same as default identical
  /// viewport fraction), defaults to false.
  ///
  /// Note that if [fractionWidthFactor] or [fractionHeightFactor] set to null or non-positive number, the actial
  /// fractional page factor will be depended by [keepViewportMainAxisSize] and [PageController.viewportFraction].
  final bool keepViewportMainAxisSize;

  /// The width factor for each fractional photo page. Note that valid [fractionWidthFactor] (positive value) will
  /// disable [keepViewportMainAxisSize] when scroll horizontally.
  final double? fractionWidthFactor;

  /// The height factor for each fractional photo page. Note that valid [fractionHeightFactor] (positive value) will
  /// disable [keepViewportMainAxisSize] when scroll vertically.
  final double? fractionHeightFactor;

  /// Mirrors to [PreloadablePageView.pageMainAxisHintSize].
  final double? pageMainAxisHintSize;

  /// Mirrors to [PreloadablePageView.preloadPagesCount].
  final int preloadPagesCount;

  // The readonly property for page count, determined by `pageOptions` or `pageCount`.
  int get _pageCount => builder != null ? pageCount! : pageOptions!.length;

  @override
  State<StatefulWidget> createState() => ExtendedPhotoGalleryState();
}

/// The state of [ExtendedPhotoGallery], can be used to [reloadPhoto] the specific [ImageProvider].
class ExtendedPhotoGalleryState extends State<ExtendedPhotoGallery> {
  late var _controller = widget.pageController ?? PageController();
  late var _photoViewKeys = List.generate(widget._pageCount, (index) => GlobalKey<ReloadablePhotoViewState>());

  /// Returns the total page count (not only photo pages) of the gallery.
  int get pageCount => widget._pageCount;

  /// Returns the current page index (not only photo pages) of the gallery.
  int get currentPage => _controller.hasClients ? _controller.page!.floor() : 0;

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
      _photoViewKeys = List.generate(widget._pageCount, (index) => GlobalKey<ReloadablePhotoViewState>());
    }
  }

  /// Reloads the [ImageProvider] of given index from [ExtendedPhotoGallery]. Note that here index should exclude
  /// non-photo pages, just the same as indies passed to [photoPageBuilder] for [ExtendedPhotoGallery.advanced].
  void reloadPhoto(int index) {
    if (index >= 0 && index < widget._pageCount) {
      _photoViewKeys[index].currentState?.reload();
    }
  }

  Widget _buildPhotoPage(BuildContext context, int index) {
    final pageOptions = (widget.builder?.call(context, index) ?? widget.pageOptions?[index])!; // index excludes non-PhotoView pages
    final options = PhotoViewOptions.merge(pageOptions, widget.fallbackOptions);
    return ClipRect(
      child: ReloadablePhotoView(
        key: _photoViewKeys[index],
        imageProviderBuilder: pageOptions.imageProviderBuilder,
        initialScale: options.initialScale,
        minScale: options.minScale,
        maxScale: options.maxScale,
        backgroundDecoration: options.backgroundDecoration,
        filterQuality: options.filterQuality,
        onTapDown: options.onTapDown,
        onTapUp: options.onTapUp,
        loadingBuilder: options.loadingBuilder,
        errorBuilder: options.errorBuilder,
        basePosition: options.basePosition,
        controller: options.controller,
        customSize: options.customSize,
        disableGestures: options.disableGestures,
        enablePanAlways: options.enablePanAlways,
        enableRotation: options.enableRotation,
        gaplessPlayback: options.gaplessPlayback,
        gestureDetectorBehavior: options.gestureDetectorBehavior,
        heroAttributes: options.heroAttributes,
        onScaleEnd: options.onScaleEnd,
        scaleStateController: options.scaleStateController,
        scaleStateChangedCallback: options.scaleStateChangedCallback,
        scaleStateCycle: options.scaleStateCycle,
        tightMode: options.tightMode,
        wantKeepAlive: options.wantKeepAlive,
      ),
    );
  }

  Widget _buildPage(BuildContext context, int index) {
    if (widget.advancedBuilder == null) {
      return _buildPhotoPage(context, index);
    }
    return widget.advancedBuilder!.call(context, index, _buildPhotoPage);
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
    if (widthFactor != null && widthFactor <= 0) {
      widthFactor = null;
    }
    if (heightFactor != null && heightFactor <= 0) {
      heightFactor = null;
    }

    // Enable corner hit test
    return PhotoViewGestureDetectorScope(
      axis: widget.scrollDirection,
      child: PreloadablePageView.builder(
        controller: _controller,
        onPageChanged: widget.onPageChanged,
        physics: widget.scrollPhysics,
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection,
        itemCount: widget._pageCount,
        itemBuilder: (context, index) => FractionallySizedBox(
          widthFactor: widthFactor, // <<<
          heightFactor: heightFactor, // <<<
          child: _buildPage(context, index),
        ),
        changePageWhenFinished: widget.changePageWhenFinished,
        pageMainAxisHintSize: widget.pageMainAxisHintSize,
        preloadPagesCount: widget.preloadPagesCount,
      ),
    );
  }
}

/// A helper class that contains options of a photo page, used in [ExtendedPhotoGallery].
class ExtendedPhotoGalleryPageOptions extends PhotoViewOptions {
  const ExtendedPhotoGalleryPageOptions({
    required this.imageProviderBuilder,
    dynamic initialScale,
    dynamic minScale,
    dynamic maxScale,
    BoxDecoration? backgroundDecoration,
    FilterQuality? filterQuality,
    PhotoViewImageTapDownCallback? onTapDown,
    PhotoViewImageTapUpCallback? onTapUp,
    LoadingPlaceholderBuilder? loadingBuilder,
    ErrorPlaceholderBuilder? errorBuilder,
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
  }) : super(
          initialScale: initialScale,
          minScale: minScale,
          maxScale: maxScale,
          backgroundDecoration: backgroundDecoration,
          filterQuality: filterQuality,
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          basePosition: basePosition,
          controller: controller,
          customSize: customSize,
          disableGestures: disableGestures,
          enablePanAlways: enablePanAlways,
          enableRotation: enableRotation,
          gaplessPlayback: gaplessPlayback,
          gestureDetectorBehavior: gestureDetectorBehavior,
          heroAttributes: heroAttributes,
          onScaleEnd: onScaleEnd,
          scaleStateController: scaleStateController,
          scaleStateChangedCallback: scaleStateChangedCallback,
          scaleStateCycle: scaleStateCycle,
          tightMode: tightMode,
          wantKeepAlive: wantKeepAlive,
        );

  /// The [ImageProvider] builder with [ValueKey], which can be used to reload image.
  final ImageProvider Function(ValueKey key) imageProviderBuilder;
}
