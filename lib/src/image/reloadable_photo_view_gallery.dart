import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// Note: The file is based on bluefireteam/photo_view, and is modified by Aoi-hosizora (GitHub: @Aoi-hosizora).
//
// Refers to:
// https://github.com/bluefireteam/photo_view/blob/master/lib/photo_view_gallery.dart

/// A [StatefulWidget] that shows multiple [PhotoView] widgets in a [PageView]
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
    this.allowImplicitScrolling = false,
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
    this.allowImplicitScrolling = false,
  })  : pageOptions = null,
        assert(itemCount != null),
        assert(builder != null),
        super(key: key);

  /// A list of options to describe the items in the gallery
  final List<ReloadablePhotoViewGalleryPageOptions>? pageOptions;

  /// The count of items in the gallery, only used when constructed via [ReloadablePhotoViewGallery.builder]
  final int? itemCount;

  /// Called to build items for the gallery when using [ReloadablePhotoViewGallery.builder]
  final ReloadablePhotoViewGalleryPageOptions Function(BuildContext context, int index)? builder;

  /// [ScrollPhysics] for the internal [PageView]
  final ScrollPhysics? scrollPhysics;

  /// Mirror to [PhotoView.backgroundDecoration]
  final BoxDecoration? backgroundDecoration;

  /// Mirror to [PhotoView.wantKeepAlive]
  final bool wantKeepAlive;

  /// Mirror to [PhotoView.gaplessPlayback]
  final bool gaplessPlayback;

  /// Mirror to [PageView.reverse]
  final bool reverse;

  /// An object that controls the [PageView] inside [ReloadablePhotoViewGallery]
  final PageController? pageController;

  /// An callback to be called on a page change
  final void Function(int index)? onPageChanged;

  /// Mirror to [PhotoView.scaleStateChangedCallback]
  final ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback;

  /// Mirror to [PhotoView.enableRotation]
  final bool enableRotation;

  /// Mirror to [PhotoView.customSize]
  final Size? customSize;

  /// The axis along which the [PageView] scrolls. Mirror to [PageView.scrollDirection]
  final Axis scrollDirection;

  /// When user attempts to move it to the next element, focus will traverse to the next page in the page view.
  final bool allowImplicitScrolling;

  bool get _isBuilder => builder != null;

  int get _itemCount => _isBuilder ? itemCount! : pageOptions!.length;

  @override
  State<StatefulWidget> createState() => ReloadablePhotoViewGalleryState();
}

class ReloadablePhotoViewGalleryState extends State<ReloadablePhotoViewGallery> {
  late final PageController _controller = widget.pageController ?? PageController();
  late List<ValueNotifier<String>> _notifiers = List.generate(widget._itemCount, (index) => ValueNotifier(''));

  ///
  int get actualPage => _controller.hasClients ? _controller.page!.floor() : 0;

  ///
  int get itemCount => widget._itemCount;

  ///
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

  void scaleStateChangedCallback(PhotoViewScaleState scaleState) {
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
          imageProvider: pageOption.imageProviderBuilder(ValueKey(v)),
          backgroundDecoration: widget.backgroundDecoration,
          wantKeepAlive: widget.wantKeepAlive,
          controller: pageOption.controller,
          scaleStateController: pageOption.scaleStateController,
          customSize: widget.customSize,
          gaplessPlayback: widget.gaplessPlayback,
          heroAttributes: pageOption.heroAttributes,
          scaleStateChangedCallback: scaleStateChangedCallback,
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
      child: PageView.builder(
        reverse: widget.reverse,
        controller: _controller,
        onPageChanged: widget.onPageChanged,
        itemCount: widget._itemCount,
        itemBuilder: _buildItem,
        scrollDirection: widget.scrollDirection,
        physics: widget.scrollPhysics,
        allowImplicitScrolling: widget.allowImplicitScrolling,
      ),
    );
  }
}

/// A helper class that wraps individual options of a page in [ReloadablePhotoViewGallery]
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

  /// Mirror to [PhotoView.imageProvider]
  final ImageProvider Function(ValueKey key) imageProviderBuilder;

  /// Mirror to [PhotoView.heroAttributes]
  final PhotoViewHeroAttributes? heroAttributes;

  /// Mirror to [PhotoView.minScale]
  final dynamic minScale;

  /// Mirror to [PhotoView.maxScale]
  final dynamic maxScale;

  /// Mirror to [PhotoView.initialScale]
  final dynamic initialScale;

  /// Mirror to [PhotoView.controller]
  final PhotoViewController? controller;

  /// Mirror to [PhotoView.scaleStateController]
  final PhotoViewScaleStateController? scaleStateController;

  /// Mirror to [PhotoView.basePosition]
  final Alignment? basePosition;

  /// Mirror to [PhotoView.scaleStateCycle]
  final ScaleStateCycle? scaleStateCycle;

  /// Mirror to [PhotoView.onTapUp]
  final PhotoViewImageTapUpCallback? onTapUp;

  /// Mirror to [PhotoView.onTapDown]
  final PhotoViewImageTapDownCallback? onTapDown;

  /// Mirror to [PhotoView.onScaleEnd]
  final PhotoViewImageScaleEndCallback? onScaleEnd;

  /// Mirror to [PhotoView.gestureDetectorBehavior]
  final HitTestBehavior? gestureDetectorBehavior;

  /// Mirror to [PhotoView.tightMode]
  final bool? tightMode;

  /// Mirror to [PhotoView.disableGestures]
  final bool? disableGestures;

  /// Quality levels for image filters.
  final FilterQuality? filterQuality;

  /// Mirror to [PhotoView.loadingBuilder]
  final Widget Function(BuildContext context, ImageChunkEvent? event)? loadingBuilder;

  /// Mirror to [PhotoView.errorBuilder]
  final ImageErrorWidgetBuilder? errorBuilder;
}
