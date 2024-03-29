import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/flutter_constants.dart';
import 'package:flutter_ahlib/src/widget/custom_drawer_controller.dart';
import 'package:flutter_ahlib/src/widget/custom_scroll_physics.dart';
import 'package:flutter_ahlib/src/util/dart_extension.dart';

// ignore_for_file: avoid_function_literals_in_foreach_calls

/// An extended [Scaffold] with [Drawer], mainly for making [Drawer] openable when [PageView]
/// or [TabBarView] is overscrolled horizontally, and customizing more drawer drag triggers.
class DrawerScaffold extends StatefulWidget {
  const DrawerScaffold({
    Key? key,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.drawerEnableOverscrollGesture = true,
    this.endDrawerEnableOverscrollGesture = true,
    this.physicsController,
    this.onPhysicsControllerChanged,
    this.checkPhysicsControllerForOverscroll = false,
    this.implicitlyOverscrollableBody = false,
    this.implicitlyOverscrollableScaffold = false,
    this.implicitPageViewScrollPhysics,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.drawerEdgeDragWidth,
    this.endDrawerEdgeDragWidth,
    this.drawerExtraDragTriggers,
    this.endDrawerExtraDragTriggers,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerScrimColor,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.testColorForDrawerDragArea,
    this.testColorForEndDrawerDragArea,
    this.testColorForDrawerDragTriggers,
    this.testColorForEndDrawerDragTriggers,
    this.onWillPop,
    // ===
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.restorationId,
  }) : super(key: key);

  /// The body of this [Scaffold]. [PageView] or [TabBarView] in [body] will listened its
  /// scroll event, which will be used to control [Drawer]'s opening.
  final Widget body;

  /// The drawer of this [Scaffold], it will also be passed to origin [Scaffold].
  ///
  /// Note that if the drawer is opened by drag gesture, [Scaffold.of] for drawer's context
  /// will not work and will throw exception. If the drawer is opened by [AppBar]'s drawer
  /// button, both [Scaffold.of] and [DrawerScaffold.of] work.
  final Widget? drawer;

  /// The end drawer of this [Scaffold], it will also be passed to origin [Scaffold].
  ///
  /// Note that if the drawer is opened by drag gesture, [Scaffold.of] for drawer's context
  /// will not work and will throw exception. If the drawer is opened by [AppBar]'s drawer
  /// button, both [Scaffold.of] and [DrawerScaffold.of] work.
  final Widget? endDrawer;

  /// The flag to enable [PageView] or [TabBarView]'s overscroll gesture to open [drawer].
  /// Note that this behavior is never related to [drawerEnableOpenDragGesture].
  final bool drawerEnableOverscrollGesture;

  /// The flag to enable [PageView] or [TabBarView]'s overscroll gesture to open [endDrawer].
  /// Note that this behavior is never related to [endDrawerEnableOpenDragGesture].
  final bool endDrawerEnableOverscrollGesture;

  /// The [CustomScrollPhysicsController] used in [body]. This controller is used to refine
  /// [PageView] or [TabBarView]'s scroll physics when [drawer] is opening when and only when
  /// [drawerEnableOverscrollGesture] or [endDrawerEnableOverscrollGesture] is true.
  final CustomScrollPhysicsController? physicsController;

  /// The callback that will be invoked when something in [physicsController] changed.
  final void Function()? onPhysicsControllerChanged;

  /// The flag to decide whether to enable overscroll gesture for opening [drawer] and [endDrawer]
  /// or not, by checking given [physicsController]. Usually this field should be used when using
  /// nested [DrawerScaffold], which can be use to synchronize drawer open state.
  final bool checkPhysicsControllerForOverscroll;

  /// The flag to wrap implicit [PageView] to the whole body to make it be overscrollable,
  /// and make the drawer be openable when scrolling the body, defaults to false. Note that
  /// the priority of [implicitlyOverscrollableScaffold] is higher than this field.
  final bool implicitlyOverscrollableBody;

  /// The flag to wrap implicit [PageView] to the whole scaffold to make it be overscrollable,
  /// and make the drawer be openable when scrolling the scaffold, defaults to false. Note that
  /// the priority of this field is higher than [implicitlyOverscrollableBody].
  final bool implicitlyOverscrollableScaffold;

  /// The scroll physics for implicit [PageView], defaults to [AlwaysScrollableScrollPhysics].
  /// Note that it is recommended to set this to the default value, or [CustomScrollPhysics].
  final ScrollPhysics? implicitPageViewScrollPhysics;

  /// The flag to enable drag gesture to open [drawer]. This flag influences not only edge
  /// horizontal dragging (with [drawerEdgeDragWidth]), but also [drawerExtraDragTriggers].
  final bool drawerEnableOpenDragGesture;

  /// The flag to enable drag gesture to open [endDrawer]. This flag influences not only edge
  /// horizontal dragging (with [endDrawerEdgeDragWidth]), but also [endDrawerExtraDragTriggers].
  final bool endDrawerEnableOpenDragGesture;

  /// Mirrors to [Scaffold.drawerEdgeDragWidth] and for [drawer]. This field only works when
  /// [drawerEnableOpenDragGesture] is true.
  final double? drawerEdgeDragWidth;

  /// Mirrors to [Scaffold.drawerEdgeDragWidth] but for [endDrawer]. This field only works
  /// when [endDrawerEnableOpenDragGesture] is true.
  final double? endDrawerEdgeDragWidth;

  /// The extra [DrawerDragTrigger] for [drawer], which can be used to enable more spaces to
  /// respond drag gesture for opening [drawer], when [drawerEnableOpenDragGesture] is true.
  ///
  /// Note that if you want [endDrawer] also have the symmetric drag trigger, just set
  /// [DrawerDragTrigger.forBothSide] to true and not need to add to [endDrawerExtraDragTriggers].
  final List<DrawerDragTrigger>? drawerExtraDragTriggers;

  /// The extra [DrawerDragTrigger] for [endDrawer], which can be used to enable more spaces
  /// to respond drag gesture for opening [endDrawer], when [endDrawerEnableOpenDragGesture]
  /// is true.
  ///
  /// Note that if you want [drawer] also have the symmetric drag trigger, just set
  /// [DrawerDragTrigger.forBothSide] to true and not need to add to [drawerExtraDragTriggers].
  final List<DrawerDragTrigger>? endDrawerExtraDragTriggers;

  /// Mirrors to [Scaffold.drawerDragStartBehavior].
  final DragStartBehavior drawerDragStartBehavior;

  /// Mirrors to [Scaffold.drawerScrimColor].
  final Color? drawerScrimColor;

  /// Mirrors to [Scaffold.onDrawerChanged].
  final DrawerCallback? onDrawerChanged;

  /// Mirrors to [Scaffold.onEndDrawerChanged].
  final DrawerCallback? onEndDrawerChanged;

  /// The color for testing drawer's drag area in [DrawerController], default to null.
  final Color? testColorForDrawerDragArea;

  /// The color for testing end drawer's drag area in [DrawerController], default to null.
  final Color? testColorForEndDrawerDragArea;

  /// The color for testing drawer's drag triggers in [DrawerScaffold], default to null.
  final Color? testColorForDrawerDragTriggers;

  /// The color for testing end drawer's drag triggers in [DrawerScaffold], default to null.
  final Color? testColorForEndDrawerDragTriggers;

  /// The onWillPop callback, note that this scaffold will be wrapped by [WillPopScope] if
  /// [onWillPop] is not null, default to null.
  final WillPopCallback? onWillPop;

  // ===

  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final String? restorationId;

  /// Finds the [DrawerScaffoldState] from the closest instance of this class the encloses
  /// the given context.
  static DrawerScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<DrawerScaffoldState>();
  }

  @override
  DrawerScaffoldState createState() => DrawerScaffoldState();
}

/// The state of [DrawerScaffold], you can use [openDrawer] and [closeDrawer] to control the
/// drawer's offset.
class DrawerScaffoldState extends State<DrawerScaffold> with RestorationMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _drawerKey = GlobalKey<CustomDrawerControllerState>();
  final _endDrawerKey = GlobalKey<CustomDrawerControllerState>();
  final _drawerOpened = RestorableBool(false);
  final _endDrawerOpened = RestorableBool(false);

  late final _onPhysicsControllerChangedListeners = [widget.onPhysicsControllerChanged];
  late final _onDrawerChangedListeners = [widget.onDrawerChanged];
  late final _onEndDrawerChangedListeners = [widget.onEndDrawerChanged];

  @override
  void initState() {
    super.initState();
   ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  /// Returns the origin [ScaffoldState] of this widget.
  ScaffoldState? get scaffoldState => _scaffoldKey.currentState;

  /// Adds physics controller changed listener to [DrawerScaffold], which will be invoked when
  /// something in [DrawerScaffold.physicsController] changed.
  void addOnPhysicsControllerChangedListener(void Function() callback) {
    _onPhysicsControllerChangedListeners.add(callback);
  }

  /// Removes the physics controller changed listener from [DrawerScaffold].
  void removeOnPhysicsControllerChangedListener(void Function() callback) {
    _onPhysicsControllerChangedListeners.remove(callback);
  }

  /// Adds drawer changed listener to [DrawerScaffold], which will be invoked when the
  /// [DrawerScaffold.drawer] is opened or closed.
  void addOnDrawerChangedListener(void Function(bool) callback) {
    _onDrawerChangedListeners.add(callback);
  }

  /// Removes the drawer changed listener from [DrawerScaffold].
  void removeOnDrawerChangedListener(void Function(bool) callback) {
    _onDrawerChangedListeners.remove(callback);
  }

  /// Adds end drawer changed listener to [DrawerScaffold], which will be invoked when the
  /// [DrawerScaffold.endDrawer] is opened or closed.
  void addOnEndDrawerChangedListener(void Function(bool) callback) {
    _onEndDrawerChangedListeners.add(callback);
  }

  /// Removes the end drawer changed listener from [DrawerScaffold].
  void removeOnEndDrawerChangedListener(void Function(bool) callback) {
    _onEndDrawerChangedListeners.remove(callback);
  }

  /// Returns true if this scaffold has a non-null drawer.
  bool get hasDrawer => widget.drawer != null;

  /// Returns true if this scaffold has a non-null end drawer.
  bool get hasEndDrawer => widget.endDrawer != null;

  /// Returns true if the drawer exists and is opened.
  bool get isDrawerOpen => _drawerOpened.value;

  /// Returns true if the end drawer exists and is opened.
  bool get isEndDrawerOpen => _endDrawerOpened.value;

  /// Opens the drawer manually if it exists.
  void openDrawer() {
    if (_endDrawerKey.currentState != null && _endDrawerOpened.value) {
      _endDrawerKey.currentState!.close();
    }
    _drawerKey.currentState?.open();
  }

  /// Opens the end drawer manually if it exists.
  void openEndDrawer() {
    if (_drawerKey.currentState != null && _drawerOpened.value) {
      _drawerKey.currentState!.close();
    }
    _endDrawerKey.currentState?.open();
  }

  /// Closes the drawer manually if it exists.
  void closeDrawer() {
    _drawerKey.currentState?.close();
  }

  /// Closes the end drawer manually if it exists.
  void closeEndDrawer() {
    _endDrawerKey.currentState?.close();
  }

  void _drawerOpenedCallback(bool isOpened) {
    if (_drawerOpened.value != isOpened) {
      _drawerOpened.value = isOpened;
      if (mounted) setState(() {});
      _onDrawerChangedListeners.forEach((c) => c?.call(isOpened));
    }
  }

  void _endDrawerOpenedCallback(bool isOpened) {
    if (_endDrawerOpened.value != isOpened) {
      _endDrawerOpened.value = isOpened;
      if (mounted) setState(() {});
      _onEndDrawerChangedListeners.forEach((c) => c?.call(isOpened));
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_drawerOpened, 'drawer_open');
    registerForRestoration(_endDrawerOpened, 'end_drawer_open');
  }

  var _overscrolling = false;
  BuildContext? _overscrolledContext;
  var _overscrollingForEndDrawer = false;

  void _updateOverscrolling(bool newValue, [BuildContext? context, bool isEndDrawer = false]) {
    if (!_overscrolling && newValue) {
      _overscrolling = true;
      _overscrolledContext = context;
      _overscrollingForEndDrawer = isEndDrawer;
      widget.physicsController?.disableScrollLess = true;
      widget.physicsController?.disableScrollMore = true;
      _onPhysicsControllerChangedListeners.forEach((c) => c?.call());
      if (mounted) setState(() {});
    } else if (_overscrolling && !newValue) {
      _overscrolling = false;
      _overscrolledContext = null;
      _overscrollingForEndDrawer = false;
      widget.physicsController?.disableScrollLess = false;
      widget.physicsController?.disableScrollMore = false;
      _onPhysicsControllerChangedListeners.forEach((c) => c?.call());
      if (mounted) setState(() {});
    }
  }

  bool _onNotification(Notification n) {
    var drawerGesture = widget.drawer != null && widget.drawerEnableOverscrollGesture;
    var endDrawerGesture = widget.endDrawer != null && widget.endDrawerEnableOverscrollGesture;
    if (!drawerGesture && !endDrawerGesture) {
      return false;
    }

    if (n is OverscrollNotification && n.dragDetails != null) {
      if (!_overscrolling) {
        if ((!widget.checkPhysicsControllerForOverscroll || widget.physicsController?.disableScrollMore != true)) {
          if (drawerGesture && n.dragDetails!.delta.dx > 0) {
            _updateOverscrolling(true, n.context, false); // forDrawer
            closeEndDrawer();
            _drawerKey.currentState?.move(n.dragDetails!);
          } else if (endDrawerGesture && n.dragDetails!.delta.dx < 0) {
            _updateOverscrolling(true, n.context, true); // forEndDrawer
            closeDrawer();
            _endDrawerKey.currentState?.move(n.dragDetails!);
          }
        }
      } else if (_overscrolling && n.context == _overscrolledContext) {
        if (!_overscrollingForEndDrawer) {
          _drawerKey.currentState?.move(n.dragDetails!);
        } else {
          _endDrawerKey.currentState?.move(n.dragDetails!);
        }
      }
    }

    if (n is OverscrollIndicatorNotification && _overscrolling) {
      n.disallowIndicator();
    }

    if (n is ScrollEndNotification && _overscrolling && n.context == _overscrolledContext) {
      if (!_overscrollingForEndDrawer) {
        _drawerKey.currentState?.settle(n.dragDetails ?? DragEndDetails());
      } else {
        _endDrawerKey.currentState?.settle(n.dragDetails ?? DragEndDetails());
      }
      _updateOverscrolling(false);
    }

    // for multiple pages but scroll is updated
    if (n is ScrollUpdateNotification && _overscrolling && n.context == _overscrolledContext) {
      if (n.dragDetails != null) {
        if (!_overscrollingForEndDrawer) {
          _drawerKey.currentState?.move(n.dragDetails!);
        } else {
          _endDrawerKey.currentState?.move(n.dragDetails!);
        }
      } else {
        if (!_overscrollingForEndDrawer) {
          _drawerKey.currentState?.settle(DragEndDetails());
        } else {
          _endDrawerKey.currentState?.settle(DragEndDetails());
        }
        _updateOverscrolling(false);
      }
    }

    return false;
  }

  var _dragTriggering = false;
  var _dragTriggeringForEndDrawer = false;

  void _onHorizontalDrag(
    DragUpdateDetails? updateDetails,
    DragEndDetails? endDetails,
    CustomDrawerControllerState? drawerState,
    CustomDrawerControllerState? endDrawerState,
  ) {
    if (updateDetails != null) {
      if (!_dragTriggering) {
        if (updateDetails.delta.dx > 0 && drawerState != null) {
          _dragTriggering = true;
          _dragTriggeringForEndDrawer = false; // forDrawer
          drawerState.move(updateDetails);
        } else if (updateDetails.delta.dx < 0 && endDrawerState != null) {
          _dragTriggering = true;
          _dragTriggeringForEndDrawer = true; // forEndDrawer
          endDrawerState.move(updateDetails);
        }
      } else {
        if (!_dragTriggeringForEndDrawer) {
          drawerState?.move(updateDetails);
        } else {
          endDrawerState?.move(updateDetails);
        }
      }
    }

    if (endDetails != null) {
      if (_dragTriggering) {
        if (!_dragTriggeringForEndDrawer) {
          drawerState?.settle(endDetails);
        } else {
          endDrawerState?.settle(endDetails);
        }
        _dragTriggering = false;
        _dragTriggeringForEndDrawer = false;
      }
    }
  }

  List<Widget> _buildDrawerDragTriggers({required bool isEndDrawer}) {
    var drawerState = widget.drawer != null && widget.drawerEnableOpenDragGesture ? _drawerKey.currentState : null;
    var endDrawerState = widget.endDrawer != null && widget.endDrawerEnableOpenDragGesture ? _endDrawerKey.currentState : null;
    var thisDrawerState = !isEndDrawer ? drawerState : endDrawerState;
    if (thisDrawerState == null) {
      return [];
    }
    var dragTriggers = !isEndDrawer ? widget.drawerExtraDragTriggers : widget.endDrawerExtraDragTriggers;
    if (dragTriggers == null || dragTriggers.isEmpty) {
      return [];
    }

    var triggerWidgets = <Widget>[];
    for (var trigger in dragTriggers) {
      var dragAreaWidth = trigger.dragWidth;
      dragAreaWidth ??= !isEndDrawer ? widget.drawerEdgeDragWidth : widget.endDrawerEdgeDragWidth;
      dragAreaWidth ??= kDrawerEdgeDragWidth + (!isEndDrawer ? MediaQuery.of(context).padding.left : MediaQuery.of(context).padding.right);

      Widget triggerWidget = Positioned(
        left: trigger.left ?? (!isEndDrawer ? 0 : null),
        right: trigger.right ?? (isEndDrawer ? 0 : null),
        top: trigger.top,
        bottom: trigger.bottom,
        height: trigger.height,
        child: Align(
          alignment: thisDrawerState.drawerOuterAlignment,
          child: GestureDetector(
            onHorizontalDragUpdate: !trigger.forBothSide //
                ? thisDrawerState.move
                : (details) => _onHorizontalDrag(details, null, drawerState, endDrawerState),
            onHorizontalDragEnd: !trigger.forBothSide //
                ? thisDrawerState.settle
                : (details) => _onHorizontalDrag(null, details, drawerState, endDrawerState),
            behavior: HitTestBehavior.translucent,
            excludeFromSemantics: true,
            dragStartBehavior: widget.drawerDragStartBehavior,
            child: Container(
              width: dragAreaWidth,
              color: !isEndDrawer ? widget.testColorForDrawerDragTriggers : widget.testColorForEndDrawerDragTriggers,
            ),
          ),
        ),
      );
      triggerWidgets.add(triggerWidget);
    }

    return triggerWidgets;
  }

  Widget _wrapImplicitPageView(Widget child) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (n) {
        if (n.depth == 0) {
          n.disallowIndicator();
          return true;
        }
        return false;
      },
      child: PageView(
        physics: widget.implicitPageViewScrollPhysics ?? const AlwaysScrollableScrollPhysics(),
        children: [child],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant DrawerScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.drawer != widget.drawer || //
        oldWidget.endDrawer != widget.endDrawer ||
        oldWidget.drawerEnableOverscrollGesture != widget.drawerEnableOverscrollGesture ||
        oldWidget.endDrawerEnableOverscrollGesture != widget.endDrawerEnableOverscrollGesture ||
        oldWidget.implicitlyOverscrollableBody != widget.implicitlyOverscrollableBody ||
        oldWidget.implicitlyOverscrollableScaffold != widget.implicitlyOverscrollableScaffold ||
        oldWidget.drawerEnableOpenDragGesture != widget.drawerEnableOpenDragGesture ||
        oldWidget.endDrawerEnableOpenDragGesture != widget.endDrawerEnableOpenDragGesture ||
        oldWidget.drawerEdgeDragWidth != widget.drawerEdgeDragWidth ||
        oldWidget.endDrawerEdgeDragWidth != widget.endDrawerEdgeDragWidth) {
      ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // scaffold body
    Widget body = widget.body;
    if (!widget.implicitlyOverscrollableScaffold && widget.implicitlyOverscrollableBody) {
      body = _wrapImplicitPageView(body);
    }

    // origin scaffold
    Widget scaffold = Scaffold(
      key: _scaffoldKey,
      body: body,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawerEdgeDragWidth: null,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      drawerScrimColor: widget.drawerScrimColor,
      onDrawerChanged: (isOpened) => _onDrawerChangedListeners.forEach((c) => c?.call(isOpened)),
      onEndDrawerChanged: (isOpened) => _onEndDrawerChangedListeners.forEach((c) => c?.call(isOpened)),
      // ===
      appBar: widget.appBar,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      persistentFooterButtons: widget.persistentFooterButtons,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary: widget.primary,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
    );
    if (widget.implicitlyOverscrollableScaffold) {
      scaffold = _wrapImplicitPageView(scaffold);
    }

    var stack = Stack(
      fit: StackFit.expand,
      children: [
        // scaffold with notification listener
        NotificationListener(
          onNotification: _onNotification,
          child: scaffold,
        ),

        // drawer drag triggers
        if (widget.endDrawer != null) ..._buildDrawerDragTriggers(isEndDrawer: true),
        if (widget.drawer != null) ..._buildDrawerDragTriggers(isEndDrawer: false),

        // end drawer controller
        if (widget.endDrawer != null)
          CustomDrawerController(
            key: _endDrawerKey,
            child: widget.endDrawer!,
            isDrawerOpen: _endDrawerOpened.value,
            alignment: DrawerAlignment.end,
            enableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
            edgeDragWidth: widget.endDrawerEdgeDragWidth,
            dragStartBehavior: widget.drawerDragStartBehavior,
            scrimColor: widget.drawerScrimColor,
            drawerCallback: _endDrawerOpenedCallback,
            testColorForDragArea: widget.testColorForEndDrawerDragArea,
          ),

        // drawer controller
        if (widget.drawer != null)
          CustomDrawerController(
            key: _drawerKey,
            child: widget.drawer!,
            isDrawerOpen: _drawerOpened.value,
            alignment: DrawerAlignment.start,
            enableOpenDragGesture: widget.drawerEnableOpenDragGesture,
            edgeDragWidth: widget.drawerEdgeDragWidth,
            dragStartBehavior: widget.drawerDragStartBehavior,
            scrimColor: widget.drawerScrimColor,
            drawerCallback: _drawerOpenedCallback,
            testColorForDragArea: widget.testColorForDrawerDragArea,
          ),
      ],
    );

    if (widget.onWillPop != null) {
      return WillPopScope(
        onWillPop: widget.onWillPop,
        child: stack,
      );
    }
    return stack;
  }
}

/// A data class which is used to describe [DrawerScaffold]'s drawer drag trigger.
class DrawerDragTrigger {
  const DrawerDragTrigger({
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.height,
    this.dragWidth,
    this.forBothSide = false,
  });

  /// The trigger's left offset in scaffold, defaults to 0.0 if it is drawer's trigger.
  final double? left;

  /// The trigger's right offset in scaffold, defaults to 0.0 if it is end drawer's trigger.
  final double? right;

  /// The trigger's top offset in scaffold. Note that [MediaQuery]'s top padding should be
  /// taken into consideration.
  final double? top;

  /// The trigger's bottom offset in scaffold. Note that [MediaQuery]'s bottom padding should
  /// be taken into consideration.
  final double? bottom;

  /// The trigger's height.
  final double? height;

  /// The width of the area within which a horizontal swipe will open the drawer, defaults to
  /// [DrawerScaffold.drawerEdgeDragWidth] or [DrawerScaffold.endDrawerEdgeDragWidth]. If the
  /// corresponding value is null, it will fallback to 20.0 with [MediaQuery] horizontal padding.
  final double? dragWidth;

  /// The flag to enable trigger dragging to open both drawer and end drawer if exists,
  /// defaults to false, which means overlapped trigger will only respond one side drawer.
  final bool forBothSide;

  @override
  String toString() {
    return 'DrawerDragTrigger(left: $left, top: $top, right: $right, bottom: $bottom, height: $height, dragWidth: $dragWidth, forBothSide: $forBothSide)';
  }

  @override
  int get hashCode {
    return hashValues(left, top, right, bottom, height, dragWidth, forBothSide);
  }

  @override
  bool operator ==(Object other) {
    return other is DrawerDragTrigger && //
        left == other.left &&
        top == other.top &&
        right == other.right &&
        bottom == other.bottom &&
        height == other.height &&
        dragWidth == other.dragWidth &&
        forBothSide == other.forBothSide;
  }
}
