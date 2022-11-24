// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/custom_scroll_physics.dart';

// Note: Some content of this file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - Scaffold: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/scaffold.dart
// - AppBar: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/app_bar.dart
// - DrawerController: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/drawer.dart

///
class ExtendedDrawerScaffold extends StatefulWidget {
  const ExtendedDrawerScaffold({
    Key? key,
    this.appBar,
    required this.bodyBuilder,
    required this.drawer,
    this.physicsController,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.onDrawerChanged,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.restorationId,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget Function(bool overscrolling) bodyBuilder;
  final Widget drawer;
  final CustomScrollPhysicsController? physicsController;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final DrawerCallback? onDrawerChanged;
  final DragStartBehavior drawerDragStartBehavior;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final String? restorationId;

  ///
  static ExtendedDrawerScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<ExtendedDrawerScaffoldState>();
  }

  @override
  ExtendedDrawerScaffoldState createState() => ExtendedDrawerScaffoldState();
}

///
class ExtendedDrawerScaffoldState extends State<ExtendedDrawerScaffold> with RestorationMixin {
  final _drawerKey = GlobalKey<CustomDrawerControllerState>();
  final _drawerOpened = RestorableBool(false);

  ///
  bool get isDrawerOpen => _drawerOpened.value;

  ///
  void openDrawer() {
    _drawerKey.currentState?.open();
  }

  ///
  void closeDrawer() {
    _drawerKey.currentState?.close();
  }

  void _drawerOpenedCallback(bool isOpened) {
    if (_drawerOpened.value != isOpened) {
      _drawerOpened.value = isOpened;
      if (mounted) setState(() {});
      widget.onDrawerChanged?.call(isOpened);
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_drawerOpened, 'drawer_open');
  }

  var _overscrolling = false;

  bool _onNotification(Notification n) {
    if (n is OverscrollNotification && n.dragDetails != null) {
      if (n.dragDetails!.delta.dx > 0) {
        _overscrolling = true;
        widget.physicsController?.disableScrollLeft = true;
        widget.physicsController?.disableScrollRight = true;
        if (mounted) setState(() {}); // TODO test if length ...
        _drawerKey.currentState?.move(n.dragDetails!);
      } else if (_overscrolling && n.dragDetails!.delta.dx < 0) {
        _drawerKey.currentState?.move(n.dragDetails!);
      }
    }
    if (n is OverscrollIndicatorNotification && _overscrolling) {
      n.disallowIndicator();
    }
    if (n is ScrollEndNotification && _overscrolling) {
      _overscrolling = false;
      widget.physicsController?.disableScrollLeft = false;
      widget.physicsController?.disableScrollRight = false;
      if (mounted) setState(() {}); // TODO test if length ...
      _drawerKey.currentState?.settle(n.dragDetails ?? DragEndDetails());
    }

    return false;
  }

  PreferredSizeWidget? _buildNewAppBar() {
    if (widget.appBar == null || widget.appBar! is! AppBar) {
      return widget.appBar;
    }

    final AppBar givenAppBar = widget.appBar! as AppBar;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final bool backwardsCompatibility = givenAppBar.backwardsCompatibility ?? appBarTheme.backwardsCompatibility ?? false; // ignore: deprecated_member_use
    final Color foregroundColor = givenAppBar.foregroundColor ?? //
        appBarTheme.foregroundColor ??
        (colorScheme.brightness == Brightness.dark ? colorScheme.onSurface : colorScheme.onPrimary);
    IconThemeData overallIconTheme = backwardsCompatibility //
        ? givenAppBar.iconTheme ?? appBarTheme.iconTheme ?? theme.primaryIconTheme
        : givenAppBar.iconTheme ?? appBarTheme.iconTheme ?? theme.iconTheme.copyWith(color: foregroundColor);

    Widget? leading = givenAppBar.leading;
    if (leading == null && givenAppBar.automaticallyImplyLeading) {
      leading = IconButton(
        icon: const Icon(Icons.menu),
        iconSize: overallIconTheme.size ?? 24,
        onPressed: openDrawer, // <<<
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    }
    if (leading != null) {
      leading = ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: givenAppBar.leadingWidth ?? kToolbarHeight),
        child: leading,
      );
    }

    return AppBar(
      leading: leading,
      automaticallyImplyLeading: givenAppBar.automaticallyImplyLeading,
      title: givenAppBar.title,
      actions: givenAppBar.actions,
      flexibleSpace: givenAppBar.flexibleSpace,
      bottom: givenAppBar.bottom,
      elevation: givenAppBar.elevation,
      shadowColor: givenAppBar.shadowColor,
      shape: givenAppBar.shape,
      backgroundColor: givenAppBar.backgroundColor,
      foregroundColor: givenAppBar.foregroundColor,
      iconTheme: givenAppBar.iconTheme,
      actionsIconTheme: givenAppBar.actionsIconTheme,
      primary: givenAppBar.primary,
      centerTitle: givenAppBar.centerTitle,
      excludeHeaderSemantics: givenAppBar.excludeHeaderSemantics,
      titleSpacing: givenAppBar.titleSpacing,
      toolbarOpacity: givenAppBar.toolbarOpacity,
      bottomOpacity: givenAppBar.bottomOpacity,
      toolbarHeight: givenAppBar.toolbarHeight,
      leadingWidth: givenAppBar.leadingWidth,
      toolbarTextStyle: givenAppBar.toolbarTextStyle,
      titleTextStyle: givenAppBar.titleTextStyle,
      systemOverlayStyle: givenAppBar.systemOverlayStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener(
          onNotification: _onNotification,
          child: Scaffold(
            appBar: _buildNewAppBar() /* <<< */,
            body: widget.bodyBuilder.call(_overscrolling) /* <<< */,
            drawer: widget.drawer /* <<< */,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
            persistentFooterButtons: widget.persistentFooterButtons,
            onDrawerChanged: widget.onDrawerChanged,
            drawerDragStartBehavior: widget.drawerDragStartBehavior,
            drawerScrimColor: widget.drawerScrimColor,
            drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
            bottomNavigationBar: widget.bottomNavigationBar,
            bottomSheet: widget.bottomSheet,
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            primary: widget.primary,
            extendBody: widget.extendBody,
            extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
            // restorationId: widget.restorationId,
          ),
        ),
        CustomDrawerController(
          key: _drawerKey,
          alignment: DrawerAlignment.start,
          drawerCallback: _drawerOpenedCallback,
          dragStartBehavior: widget.drawerDragStartBehavior,
          scrimColor: widget.drawerScrimColor,
          edgeDragWidth: widget.drawerEdgeDragWidth,
          enableOpenDragGesture: true /* <<< */,
          isDrawerOpen: _drawerOpened.value,
          child: widget.drawer,
        ),
      ],
    );
  }
}

const double _kWidth = 304.0;
const double _kEdgeDragWidth = 20.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

/// A custom [DrawerController], which provides interactive behavior for [Drawer] widgets, and
/// is allowed to methods such as [CustomDrawerControllerState.move] to control its offset.
class CustomDrawerController extends StatefulWidget {
  const CustomDrawerController({
    GlobalKey? key,
    required this.child,
    required this.alignment,
    this.isDrawerOpen = false,
    this.drawerCallback,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrimColor,
    this.edgeDragWidth,
    this.enableOpenDragGesture = true,
  }) : super(key: key);

  final Widget child;
  final DrawerAlignment alignment;
  final DrawerCallback? drawerCallback;
  final DragStartBehavior dragStartBehavior;
  final Color? scrimColor;
  final bool enableOpenDragGesture;
  final double? edgeDragWidth;
  final bool isDrawerOpen;

  @override
  CustomDrawerControllerState createState() => CustomDrawerControllerState();
}

/// State for a [CustomDrawerController]. Note that here [open], [close], [move], [settle] and
/// [controller] is exposed to public.
class CustomDrawerControllerState extends State<CustomDrawerController> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // This public property is added by AoiHosizora.
  AnimationController get controller => _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.isDrawerOpen ? 1.0 : 0.0,
      duration: _kBaseSettleDuration,
      vsync: this,
    );
    _controller
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
  }

  @override
  void dispose() {
    _historyEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrimColorTween = _buildScrimColorTween();
  }

  @override
  void didUpdateWidget(CustomDrawerController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrimColor != oldWidget.scrimColor) _scrimColorTween = _buildScrimColorTween();
    if (widget.isDrawerOpen != oldWidget.isDrawerOpen) {
      switch (_controller.status) {
        case AnimationStatus.completed:
        case AnimationStatus.dismissed:
          _controller.value = widget.isDrawerOpen ? 1.0 : 0.0;
          break;
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    }
  }

  void _animationChanged() {
    setState(() {
      // The animation controller's state is our build state, and it changed already.
    });
  }

  LocalHistoryEntry? _historyEntry;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
        FocusScope.of(context).setFirstFocus(_focusScopeNode);
      }
    }
  }

  void _animationStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        _ensureHistoryEntry();
        break;
      case AnimationStatus.reverse:
        _historyEntry?.remove();
        _historyEntry = null;
        break;
      case AnimationStatus.dismissed:
        break;
      case AnimationStatus.completed:
        break;
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    close();
  }

  void _handleDragDown(DragDownDetails details) {
    _controller.stop();
    _ensureHistoryEntry();
  }

  void _handleDragCancel() {
    if (_controller.isDismissed || _controller.isAnimating) return;
    if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  final GlobalKey _drawerKey = GlobalKey();

  double get _width {
    final RenderBox? box = _drawerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) return box.size.width;
    return _kWidth; // drawer not being shown currently
  }

  bool _previouslyOpened = false;

  // The accessibility of this method is modified by AoiHosizora.
  void move(DragUpdateDetails details) {
    double delta = details.primaryDelta! / _width;
    switch (widget.alignment) {
      case DrawerAlignment.start:
        break;
      case DrawerAlignment.end:
        delta = -delta;
        break;
    }
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        _controller.value -= delta;
        break;
      case TextDirection.ltr:
        _controller.value += delta;
        break;
    }

    final bool opened = _controller.value > 0.5;
    if (opened != _previouslyOpened && widget.drawerCallback != null) widget.drawerCallback!(opened);
    _previouslyOpened = opened;
  }

  // The accessibility of this method is modified by AoiHosizora.
  void settle(DragEndDetails details) {
    if (_controller.isDismissed) return;
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / _width;
      switch (widget.alignment) {
        case DrawerAlignment.start:
          break;
        case DrawerAlignment.end:
          visualVelocity = -visualVelocity;
          break;
      }
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _controller.fling(velocity: -visualVelocity);
          widget.drawerCallback?.call(visualVelocity < 0.0);
          break;
        case TextDirection.ltr:
          _controller.fling(velocity: visualVelocity);
          widget.drawerCallback?.call(visualVelocity > 0.0);
          break;
      }
    } else if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  /// Starts an animation to open the drawer.
  void open() {
    _controller.fling();
    widget.drawerCallback?.call(true);
  }

  /// Starts an animation to close the drawer.
  void close() {
    _controller.fling(velocity: -1.0);
    widget.drawerCallback?.call(false);
  }

  late ColorTween _scrimColorTween;
  final GlobalKey _gestureDetectorKey = GlobalKey();

  ColorTween _buildScrimColorTween() {
    return ColorTween(
      begin: Colors.transparent,
      end: widget.scrimColor ?? DrawerTheme.of(context).scrimColor ?? Colors.black54,
    );
  }

  AlignmentDirectional get _drawerOuterAlignment {
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return AlignmentDirectional.centerStart;
      case DrawerAlignment.end:
        return AlignmentDirectional.centerEnd;
    }
  }

  AlignmentDirectional get _drawerInnerAlignment {
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return AlignmentDirectional.centerEnd;
      case DrawerAlignment.end:
        return AlignmentDirectional.centerStart;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final bool drawerIsStart = widget.alignment == DrawerAlignment.start;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    final TextDirection textDirection = Directionality.of(context);

    double? dragAreaWidth = widget.edgeDragWidth;
    if (widget.edgeDragWidth == null) {
      switch (textDirection) {
        case TextDirection.ltr:
          dragAreaWidth = _kEdgeDragWidth + (drawerIsStart ? padding.left : padding.right);
          break;
        case TextDirection.rtl:
          dragAreaWidth = _kEdgeDragWidth + (drawerIsStart ? padding.right : padding.left);
          break;
      }
    }

    if (_controller.status == AnimationStatus.dismissed) {
      if (widget.enableOpenDragGesture) {
        return Align(
          alignment: _drawerOuterAlignment,
          child: GestureDetector(
            key: _gestureDetectorKey,
            onHorizontalDragUpdate: move,
            onHorizontalDragEnd: settle,
            behavior: HitTestBehavior.translucent,
            excludeFromSemantics: true,
            dragStartBehavior: widget.dragStartBehavior,
            child: Container(width: dragAreaWidth),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      final bool platformHasBackButton;
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
          platformHasBackButton = true;
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          platformHasBackButton = false;
          break;
      }
      return GestureDetector(
        key: _gestureDetectorKey,
        onHorizontalDragDown: _handleDragDown,
        onHorizontalDragUpdate: move,
        onHorizontalDragEnd: settle,
        onHorizontalDragCancel: _handleDragCancel,
        excludeFromSemantics: true,
        dragStartBehavior: widget.dragStartBehavior,
        child: RepaintBoundary(
          child: Stack(
            children: <Widget>[
              BlockSemantics(
                child: ExcludeSemantics(
                  // On Android, the back button is used to dismiss a modal.
                  excluding: platformHasBackButton,
                  child: GestureDetector(
                    onTap: close,
                    child: Semantics(
                      label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                      child: MouseRegion(
                        child: Container(
                          // The drawer's "scrim"
                          color: _scrimColorTween.evaluate(_controller),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: _drawerOuterAlignment,
                child: Align(
                  alignment: _drawerInnerAlignment,
                  widthFactor: _controller.value,
                  child: RepaintBoundary(
                    child: FocusScope(
                      key: _drawerKey,
                      node: _focusScopeNode,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: _buildDrawer(context),
    );
  }
}
