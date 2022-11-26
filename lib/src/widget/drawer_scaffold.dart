import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/flutter_constants.dart';
import 'package:flutter_ahlib/src/widget/custom_drawer_controller.dart';
import 'package:flutter_ahlib/src/widget/custom_scroll_physics.dart';

/// An extended [Scaffold] with [Drawer], mainly for making [Drawer] openable when [PageView]
/// or [TabBarView] is overscrolled horizontally.
class DrawerScaffold extends StatefulWidget {
  const DrawerScaffold({
    Key? key,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.physicsController,
    this.drawerExtraDragTriggers,
    this.endDrawerExtraDragTriggers,
    // ===
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerScrimColor,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.drawerEdgeDragWidth,
    this.endDrawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
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

  /// The [CustomScrollPhysicsController] used in [body]. This controller will be used to
  /// refine [PageView] or [TabBarView]'s scroll physics when [drawer] is opening.
  final CustomScrollPhysicsController? physicsController;

  /// The extra [DrawerDragTrigger] for [drawer], which can be used to enable more spaces to
  /// respond drag gesture for opening [drawer].
  final List<DrawerDragTrigger>? drawerExtraDragTriggers;

  /// The extra [DrawerDragTrigger] for [endDrawer], which can be used to enable more spaces
  /// to respond drag gesture for opening [endDrawer].
  final List<DrawerDragTrigger>? endDrawerExtraDragTriggers;

  // ===

  final DragStartBehavior drawerDragStartBehavior;
  final Color? drawerScrimColor;
  final DrawerCallback? onDrawerChanged;
  final DrawerCallback? onEndDrawerChanged;
  final double? drawerEdgeDragWidth;
  final double? endDrawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  /// Returns the origin [ScaffoldState] of this widget.
  ScaffoldState? get scaffoldState => _scaffoldKey.currentState;

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
      widget.onDrawerChanged?.call(isOpened);
    }
  }

  void _endDrawerOpenedCallback(bool isOpened) {
    if (_endDrawerOpened.value != isOpened) {
      _endDrawerOpened.value = isOpened;
      if (mounted) setState(() {});
      widget.onEndDrawerChanged?.call(isOpened);
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
      if (mounted) setState(() {});
    } else if (_overscrolling && !newValue) {
      _overscrolling = false;
      _overscrolledContext = null;
      _overscrollingForEndDrawer = false;
      widget.physicsController?.disableScrollLess = false;
      widget.physicsController?.disableScrollMore = false;
      if (mounted) setState(() {});
    }
  }

  bool _onNotification(Notification n) {
    var drawerGesture = widget.drawer != null && widget.drawerEnableOpenDragGesture;
    var endDrawerGesture = widget.endDrawer != null && widget.drawerEnableOpenDragGesture;
    if (!drawerGesture && !endDrawerGesture) {
      return false;
    }

    if (n is OverscrollNotification && n.dragDetails != null) {
      if (!_overscrolling) {
        if (drawerGesture && n.dragDetails!.delta.dx > 0) {
          _updateOverscrolling(true, n.context, false); // forDrawer
          closeEndDrawer();
          _drawerKey.currentState?.move(n.dragDetails!);
        } else if (endDrawerGesture && n.dragDetails!.delta.dx < 0) {
          _updateOverscrolling(true, n.context, true); // forEndDrawer
          closeDrawer();
          _endDrawerKey.currentState?.move(n.dragDetails!);
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

  List<Widget> _buildDrawerDragTriggers({required bool isEndDrawer, required CustomDrawerControllerState drawerState}) {
    var dragTriggers = !isEndDrawer ? widget.drawerExtraDragTriggers : widget.endDrawerExtraDragTriggers;
    if (dragTriggers == null || dragTriggers.isEmpty) {
      return [];
    }

    var out = <Widget>[];
    for (var trigger in dragTriggers) {
      var dragAreaWidth = trigger.dragWidth ?? (!isEndDrawer ? widget.drawerEdgeDragWidth : widget.endDrawerEdgeDragWidth);
      dragAreaWidth ??= kDrawerEdgeDragWidth + (!isEndDrawer ? MediaQuery.of(context).padding.left : MediaQuery.of(context).padding.right);
      Widget v = Positioned(
        left: trigger.left,
        top: trigger.top,
        right: trigger.right,
        bottom: trigger.bottom,
        width: trigger.width,
        height: trigger.height,
        child: Align(
          alignment: drawerState.drawerOuterAlignment,
          child: GestureDetector(
            onHorizontalDragUpdate: drawerState.move,
            onHorizontalDragEnd: drawerState.settle,
            behavior: HitTestBehavior.translucent,
            excludeFromSemantics: true,
            dragStartBehavior: widget.drawerDragStartBehavior,
            child: Container(width: dragAreaWidth),
          ),
        ),
      );
      out.add(v);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // origin scaffold
        Scaffold(
          key: _scaffoldKey,
          body: NotificationListener(
            onNotification: _onNotification,
            child: widget.body,
          ),
          drawer: widget.drawer,
          endDrawer: widget.endDrawer,
          // ===
          appBar: widget.appBar,
          drawerDragStartBehavior: widget.drawerDragStartBehavior,
          drawerScrimColor: widget.drawerScrimColor,
          onDrawerChanged: widget.onDrawerChanged,
          onEndDrawerChanged: widget.onEndDrawerChanged,
          drawerEdgeDragWidth: null,
          drawerEnableOpenDragGesture: false,
          endDrawerEnableOpenDragGesture: false,
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
        ),

        // TODO drawer drag triggers

        // end drawer
        if (widget.endDrawer != null) ...[
          if (_endDrawerKey.currentState != null && widget.endDrawerEnableOpenDragGesture)
            ..._buildDrawerDragTriggers(
              isEndDrawer: true,
              drawerState: _endDrawerKey.currentState!,
            ),
          CustomDrawerController(
            key: _endDrawerKey,
            alignment: DrawerAlignment.end,
            drawerCallback: _endDrawerOpenedCallback,
            dragStartBehavior: widget.drawerDragStartBehavior,
            scrimColor: widget.drawerScrimColor,
            edgeDragWidth: widget.endDrawerEdgeDragWidth,
            enableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
            isDrawerOpen: _endDrawerOpened.value,
            child: widget.endDrawer!,
          ),
        ],

        // drawer
        if (widget.drawer != null) ...[
          if (_drawerKey.currentState != null && widget.drawerEnableOpenDragGesture)
            ..._buildDrawerDragTriggers(
              isEndDrawer: false,
              drawerState: _drawerKey.currentState!,
            ),
          CustomDrawerController(
            key: _drawerKey,
            alignment: DrawerAlignment.start,
            drawerCallback: _drawerOpenedCallback,
            dragStartBehavior: widget.drawerDragStartBehavior,
            scrimColor: widget.drawerScrimColor,
            edgeDragWidth: widget.drawerEdgeDragWidth,
            enableOpenDragGesture: widget.drawerEnableOpenDragGesture,
            isDrawerOpen: _drawerOpened.value,
            child: widget.drawer!,
          ),
        ],
      ],
    );
  }
}

/// A data class which is used to describe [DrawerScaffold]'s drawer drag trigger.
class DrawerDragTrigger {
  const DrawerDragTrigger({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    this.dragWidth,
  });

  /// The trigger's left offset in scaffold.
  final double? left;

  /// The trigger's top offset in scaffold.
  final double? top;

  /// The trigger's right offset in scaffold.
  final double? right;

  /// The trigger's bottom offset in scaffold.
  final double? bottom;

  /// The trigger's width.
  final double? width;

  /// The trigger's height.
  final double? height;

  /// The width of the area within which a horizontal swipe will open the drawer, defaults to
  /// [DrawerScaffold.drawerEdgeDragWidth] or [DrawerScaffold.endDrawerEdgeDragWidth].
  final double? dragWidth;
}
