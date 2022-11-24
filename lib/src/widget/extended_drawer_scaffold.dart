import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/custom_drawer_controller.dart';
import 'package:flutter_ahlib/src/widget/custom_scroll_physics.dart';

// Note: Some content of this file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - Scaffold: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/scaffold.dart
// - AppBar: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/app_bar.dart

///
class ExtendedDrawerScaffold extends StatefulWidget {
  const ExtendedDrawerScaffold({
    Key? key,
    this.appBar,
    required this.body,
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

  ///
  final PreferredSizeWidget? appBar;

  ///
  final Widget body;

  ///
  final Widget drawer;

  ///
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

  void _updateOverscrolling(bool newValue) {
    if (!_overscrolling && newValue) {
      _overscrolling = true;
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
    if (n is OverscrollNotification && n.dragDetails != null) {
      if (n.dragDetails!.delta.dx > 0) {
        _updateOverscrolling(true);
        _drawerKey.currentState?.move(n.dragDetails!);
      } else if (_overscrolling && n.dragDetails!.delta.dx < 0) {
        _drawerKey.currentState?.move(n.dragDetails!);
      }
    }
    if (n is OverscrollIndicatorNotification && _overscrolling) {
      n.disallowIndicator();
    }
    if (n is ScrollEndNotification && _overscrolling) {
      _updateOverscrolling(false);
      _drawerKey.currentState?.settle(n.dragDetails ?? DragEndDetails());
    }

    // for multiple pages but scroll updated supported
    if (n is ScrollUpdateNotification && _overscrolling) {
      if (n.dragDetails != null) {
        _drawerKey.currentState?.move(n.dragDetails!);
      } else {
        _updateOverscrolling(false);
        _drawerKey.currentState?.settle(DragEndDetails());
      }
    }

    return false;
  }

  // This function is based on Flutter's source code, and is modified by AoiHosizora.
  PreferredSizeWidget? _buildAppBar() {
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
            appBar: _buildAppBar() /* <<< */,
            body: widget.body,
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
