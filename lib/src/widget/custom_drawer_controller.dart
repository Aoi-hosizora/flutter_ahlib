// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Note: This file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source code:
// - DrawerController: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/drawer.dart

const double _kWidth = 304.0;
const double _kEdgeDragWidth = 20.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

/// A customizable [DrawerController] which provides interactive behavior for [Drawer] widgets.
/// This widget is allowed to use methods such as [CustomDrawerControllerState.move] to control
/// its offset, and this is the only difference from [DrawerController].
///
/// This widget is rarely used directly, and is designed depended on [DrawerScaffold].
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
    this.testColorForDragArea,
  }) : super(key: key);

  final Widget child;
  final DrawerAlignment alignment;
  final bool isDrawerOpen;
  final DrawerCallback? drawerCallback;
  final DragStartBehavior dragStartBehavior;
  final Color? scrimColor;
  final double? edgeDragWidth;
  final bool enableOpenDragGesture;
  final Color? testColorForDragArea;

  @override
  CustomDrawerControllerState createState() => CustomDrawerControllerState();
}

/// The State for [CustomDrawerController]. Note that here [controller], [move], [settle], [open]
/// and [close] methods are exposed to public.
class CustomDrawerControllerState extends State<CustomDrawerController> with TickerProviderStateMixin {
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

  late AnimationController _controller;

  // This public property is added by AoiHosizora.
  /// Returns the inner [AnimationController] of [CustomDrawerController].
  AnimationController get controller => _controller;

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

  // The property accessibility is modified by AoiHosizora.
  /// Returns the width of drawer.
  double get width {
    final RenderBox? box = _drawerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) return box.size.width;
    return _kWidth; // drawer not being shown currently
  }

  bool _previouslyOpened = false;

  // The method accessibility is modified by AoiHosizora.
  /// Updates the drawer's offset by given [DragUpdateDetails].
  void move(DragUpdateDetails details) {
    double delta = details.primaryDelta! / width;
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

  // The method accessibility is modified by AoiHosizora.
  /// Settles the drawer by given [DragEndDetails].
  void settle(DragEndDetails details) {
    if (_controller.isDismissed) return;
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / width;
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

  // The property accessibility is modified by AoiHosizora.
  AlignmentDirectional get drawerOuterAlignment {
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return AlignmentDirectional.centerStart;
      case DrawerAlignment.end:
        return AlignmentDirectional.centerEnd;
    }
  }

  // The property accessibility is modified by AoiHosizora.
  AlignmentDirectional get drawerInnerAlignment {
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
          alignment: drawerOuterAlignment,
          child: GestureDetector(
            key: _gestureDetectorKey,
            onHorizontalDragUpdate: move,
            onHorizontalDragEnd: settle,
            behavior: HitTestBehavior.translucent,
            excludeFromSemantics: true,
            dragStartBehavior: widget.dragStartBehavior,
            child: Container(width: dragAreaWidth, color: widget.testColorForDragArea),
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
                alignment: drawerOuterAlignment,
                child: Align(
                  alignment: drawerInnerAlignment,
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
