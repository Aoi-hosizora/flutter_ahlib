import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/image/preloadable_page_view.dart';
import 'package:photo_view/photo_view.dart';

// Note: The file is based on bluefireteam/photo_view, and is modified by Aoi-hosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - PhotoViewGallery: https://github.com/bluefireteam/photo_view/blob/0.14.0/lib/photo_view_gallery.dart

/// A [StatefulWidget] that shows multiple [PhotoView] widgets in a [PageView], which is modified from [PhotoViewGallery], and is used to make a reloadable
/// [PhotoViewGallery] through [ReloadablePhotoViewGalleryState.reload].
///
/// Some of [PhotoView] constructor options are passed direct to [ReloadablePhotoViewGallery] constructor. Those options will affect the gallery in a whole.
///
/// Some of the options may be defined to each image individually, such as `initialScale` or `heroAttributes`. Those must be passed via each [ReloadablePhotoViewGalleryPageOptions].
class ReloadablePhotoViewGallery extends StatefulWidget {
  /// Construct a gallery with static items through a list of [ReloadablePhotoViewGalleryPageOptions].
  const ReloadablePhotoViewGallery({
    Key? key,
    required this.pageOptions,
    this.backgroundDecoration,
    this.wantKeepAlive = false,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.pageController,
    this.onPageChanged,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.preloadPagesCount = 0,
  })  : itemCount = null,
        builder = null,
        super(key: key);

  /// Construct a gallery with dynamic items. The builder must return a [ReloadablePhotoViewGalleryPageOptions].
  const ReloadablePhotoViewGallery.builder({
    Key? key,
    required this.itemCount,
    required this.builder,
    this.backgroundDecoration,
    this.wantKeepAlive = false,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.pageController,
    this.onPageChanged,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.preloadPagesCount = 0,
  })  : pageOptions = null,
        assert(itemCount != null),
        assert(builder != null),
        super(key: key);

  /// A list of options to describe the items in the gallery.
  final List<ReloadablePhotoViewGalleryPageOptions>? pageOptions;

  /// The count of items in the gallery, only used when constructed via [ReloadablePhotoViewGallery.builder].
  final int? itemCount;

  /// Called to build items for the gallery when using [ReloadablePhotoViewGallery.builder].
  final ReloadablePhotoViewGalleryPageOptions Function(BuildContext context, int index)? builder;

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

  /// An object that controls the [PageView] inside [ReloadablePhotoViewGallery].
  final PageController? pageController;

  /// An callback to be called on a page change.
  final void Function(int index)? onPageChanged;

  /// Mirror to [PhotoView.scaleStateChangedCallback].
  final ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback;

  /// Mirror to [PhotoView.enableRotation].
  final bool enableRotation;

  /// Mirror to [PhotoView.customSize].
  final Size? customSize;

  /// The axis along which the [PageView] scrolls. Mirror to [PageView.scrollDirection].
  final Axis scrollDirection;

  /// Mirror to [PreloadablePageView.preloadPagesCount].
  final int preloadPagesCount;

  bool get _isBuilder => builder != null;

  int get _itemCount => _isBuilder ? itemCount! : pageOptions!.length;

  @override
  State<StatefulWidget> createState() => ReloadablePhotoViewGalleryState();
}

/// The state of [ReloadablePhotoViewGallery], can be used to [reload] the specific image from [ImageProvider].
class ReloadablePhotoViewGalleryState extends State<ReloadablePhotoViewGallery> {
  late final PageController _controller = widget.pageController ?? PageController();
  late List<ValueNotifier<String>> _notifiers = List.generate(widget._itemCount, (index) => ValueNotifier(''));

  /// Returns the current page of the widget.
  int get currentPage => _controller.hasClients ? _controller.page!.floor() : 0;

  /// Returns the total page count of the widget.
  int get itemCount => widget._itemCount;

  /// Reloads the image of given index from [ImageProvider].
  void reload(int index) {
    _notifiers[index].value = DateTime.now().microsecondsSinceEpoch.toString();
    // no need to setState
  }

  @override
  void didUpdateWidget(covariant ReloadablePhotoViewGallery oldWidget) {
    if (widget._itemCount != oldWidget._itemCount) {
      _notifiers = List.generate(widget._itemCount, (index) => ValueNotifier(''));
    }
    super.didUpdateWidget(oldWidget);
  }

  void _scaleStateChangedCallback(PhotoViewScaleState scaleState) {
    if (widget.scaleStateChangedCallback != null) {
      widget.scaleStateChangedCallback!(scaleState);
    }
  }

  ReloadablePhotoViewGalleryPageOptions _buildPageOption(BuildContext context, int index) {
    if (widget._isBuilder) {
      return widget.builder!(context, index);
    }
    return widget.pageOptions![index];
  }

  Widget _buildItem(BuildContext context, int index) {
    final pageOption = _buildPageOption(context, index);
    return ClipRect(
      child: ValueListenableBuilder<String>(
        valueListenable: _notifiers[index], // <<<
        builder: (_, v, __) => PhotoView(
          key: ValueKey('$index-$v') /* ObjectKey(index) */,
          imageProvider: pageOption.imageProviderBuilder(ValueKey('$index-$v')),
          backgroundDecoration: widget.backgroundDecoration,
          wantKeepAlive: widget.wantKeepAlive,
          controller: pageOption.controller,
          scaleStateController: pageOption.scaleStateController,
          customSize: widget.customSize,
          gaplessPlayback: widget.gaplessPlayback,
          heroAttributes: pageOption.heroAttributes,
          scaleStateChangedCallback: _scaleStateChangedCallback,
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
          loadingBuilder: pageOption.loadingBuilder,
          errorBuilder: pageOption.errorBuilder,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Enable corner hit test
    return PhotoViewGestureDetectorScope(
      axis: widget.scrollDirection,
      child: PreloadablePageView.builder(
        reverse: widget.reverse,
        controller: _controller,
        onPageChanged: widget.onPageChanged,
        itemCount: widget._itemCount,
        // itemBuilder: _buildItem,
        itemBuilder: (context, index) => FractionallySizedBox(
          widthFactor: 1 / (widget.pageController?.viewportFraction ?? 1), // <<<
          child: _buildItem(context, index),
        ),
        scrollDirection: widget.scrollDirection,
        physics: widget.scrollPhysics,
        preloadPagesCount: widget.preloadPagesCount,
      ),
    );
  }
}

/// A helper class that wraps individual options of a page in [ReloadablePhotoViewGallery].
class ReloadablePhotoViewGalleryPageOptions {
  const ReloadablePhotoViewGalleryPageOptions({
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
    this.filterQuality,
    this.disableGestures,
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

  /// Quality levels for image filters.
  final FilterQuality? filterQuality;

  /// Mirror to [PhotoView.loadingBuilder].
  final LoadingBuilder? loadingBuilder;

  /// Mirror to [PhotoView.errorBuilder].
  final ImageErrorWidgetBuilder? errorBuilder;
}
