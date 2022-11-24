import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/custom_drawer_controller.dart';
import 'package:flutter_ahlib/src/widget/custom_scroll_physics.dart';

// Note: Part of this file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source code:
// - Scaffold: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/scaffold.dart
// - AppBar: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/app_bar.dart

/// An extended [Scaffold] with [Drawer], mainly for making [Drawer] openable when
/// [PageView] or [TabBarView] is overscrolled horizontally.
class DrawerScaffold extends StatefulWidget {
  const DrawerScaffold({
    Key? key,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.physicsController,
    // ===
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerScrimColor,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.drawerEdgeDragWidth,
    this.endDrawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
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

  /// The body of [Scaffold]. [PageView] or [TabBarView] in [body] will listened
  /// its scroll event, and is used to control [Drawer]'s opening and closing.
  final Widget body;

  /// The drawer of [Scaffold].
  final Widget? drawer;

  /// The end drawer of [Scaffold].
  final Widget? endDrawer;

  /// The [CustomScrollPhysicsController] used in [body]. This controller will be
  /// used to refine [PageView] or [TabBarView] physics when [drawer] is opening.
  final CustomScrollPhysicsController? physicsController;

  // ===

  final DragStartBehavior drawerDragStartBehavior;
  final Color? drawerScrimColor;
  final DrawerCallback? onDrawerChanged;
  final DrawerCallback? onEndDrawerChanged;
  final double? drawerEdgeDragWidth;
  final double? endDrawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

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

  /// Finds the [DrawerScaffoldState] from the closest instance of this class the
  /// encloses the given context.
  static DrawerScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<DrawerScaffoldState>();
  }

  @override
  DrawerScaffoldState createState() => DrawerScaffoldState();
}

/// The state of [DrawerScaffold], you can use [openDrawer] and [closeDrawer] to
/// control the drawer's offset.
class DrawerScaffoldState extends State<DrawerScaffold> with RestorationMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Returns the origin [ScaffoldState] of this widget.
  ScaffoldState? get scaffoldState => _scaffoldKey.currentState;

  final _drawerKey = GlobalKey<CustomDrawerControllerState>();
  final _endDrawerKey = GlobalKey<CustomDrawerControllerState>();
  final _drawerOpened = RestorableBool(false);
  final _endDrawerOpened = RestorableBool(false);

  /// Returns true if the drawer is opened.
  bool get isDrawerOpen => _drawerOpened.value;

  /// Returns true if the end drawer is opened.
  bool get isEndDrawerOpen => _endDrawerOpened.value;

  /// Returns true if this scaffold has a non-null drawer.
  bool get hasDrawer => widget.drawer != null;

  /// Returns true if this scaffold has a non-null end drawer.
  bool get hasEndDrawer => widget.endDrawer != null;

  /// Opens the drawer manually.
  void openDrawer() {
    if (_endDrawerKey.currentState != null && _endDrawerOpened.value) {
      _endDrawerKey.currentState!.close();
    }
    _drawerKey.currentState?.open();
  }

  /// Closes the drawer manually.
  void closeDrawer() {
    _drawerKey.currentState?.close();
  }

  /// Opens the end drawer manually.
  void openEndDrawer() {
    if (_drawerKey.currentState != null && _drawerOpened.value) {
      _drawerKey.currentState!.close();
    }
    _endDrawerKey.currentState?.open();
  }

  /// Closes the end drawer manually.
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
  var _overscrollingForEndDrawer = false;

  void _updateOverscrolling(bool newValue, [bool endDrawer = false]) {
    if (!_overscrolling && newValue) {
      _overscrolling = true;
      _overscrollingForEndDrawer = endDrawer;
      widget.physicsController?.disableScrollLeft = true;
      widget.physicsController?.disableScrollRight = true;
      if (mounted) setState(() {});
    } else if (_overscrolling && !newValue) {
      _overscrolling = false;
      widget.physicsController?.disableScrollLeft = false;
      widget.physicsController?.disableScrollRight = false;
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
        if (n.dragDetails!.delta.dx > 0 && drawerGesture) {
          _updateOverscrolling(true, false); // forDrawer
          closeEndDrawer();
          _drawerKey.currentState?.move(n.dragDetails!);
        } else if (n.dragDetails!.delta.dx < 0 && endDrawerGesture) {
          _updateOverscrolling(true, true); // forEndDrawer
          closeDrawer();
          _endDrawerKey.currentState?.move(n.dragDetails!);
        }
      } else {
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

    if (n is ScrollEndNotification && _overscrolling) {
      _updateOverscrolling(false);
      if (!_overscrollingForEndDrawer) {
        _drawerKey.currentState?.settle(n.dragDetails ?? DragEndDetails());
      } else {
        _endDrawerKey.currentState?.settle(n.dragDetails ?? DragEndDetails());
      }
    }

    // for multiple pages but scroll updated supported
    if (n is ScrollUpdateNotification && _overscrolling) {
      if (n.dragDetails != null) {
        if (!_overscrollingForEndDrawer) {
          _drawerKey.currentState?.move(n.dragDetails!);
        } else {
          _endDrawerKey.currentState?.move(n.dragDetails!);
        }
      } else {
        _updateOverscrolling(false);
        if (!_overscrollingForEndDrawer) {
          _drawerKey.currentState?.settle(DragEndDetails());
        } else {
          _endDrawerKey.currentState?.settle(DragEndDetails());
        }
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
          // ===
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
        if (widget.drawer != null)
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
        if (widget.endDrawer != null)
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
    );
  }
}
