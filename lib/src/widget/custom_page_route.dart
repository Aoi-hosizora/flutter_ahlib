import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
class CustomPageRoute<T> extends PageRoute<T> {
  ///
  CustomPageRoute({
    required this.context,
    required this.builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    this.maintainState = true,
    Duration? transitionDuration /* 300ms */,
    PageTransitionsBuilder? transitionsBuilder /* PageTransitionsTheme */,
  })  : _transitionDuration = transitionDuration,
        _transitionsBuilder = transitionsBuilder,
        super(settings: settings, fullscreenDialog: fullscreenDialog) {
    assert(opaque);
  }

  CustomPageRoute.simple(
    BuildContext context,
    WidgetBuilder builder,
  ) : this(
          context: context,
          builder: builder,
          settings: null,
          fullscreenDialog: false,
          transitionDuration: null,
          transitionsBuilder: null,
        );

  ///
  final BuildContext context;

  ///
  final WidgetBuilder builder;

  ///
  @override
  final bool maintainState;

  ///
  final Duration? _transitionDuration;

  ///
  final PageTransitionsBuilder? _transitionsBuilder;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration {
    final theme = CustomPageRouteTheme.of(context);
    return _transitionDuration ?? theme?.transitionDuration ?? const Duration(milliseconds: 300);
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return super.canTransitionFrom(previousRoute);
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return super.canTransitionTo(nextRoute);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder.call(context),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // TODO allowSwipeTransition
    final theme = CustomPageRouteTheme.of(context);
    var builder = (_transitionsBuilder ?? theme?.transitionsBuilder)?.buildTransitions ?? Theme.of(context).pageTransitionsTheme.buildTransitions;
    return builder<T>(this, context, animation, secondaryAnimation, child);
  }
}

/// Associates an [CustomPageRouteThemeData] with a subtree. The [CustomPageRoute] uses
/// [of] methods to find the [CustomPageRouteThemeData] associated with its subtree.
class CustomPageRouteTheme extends InheritedWidget {
  /// Creates a widget that associates a [CustomPageRouteThemeData] with a subtree.
  const CustomPageRouteTheme({
    Key? key,
    required CustomPageRouteThemeData this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The [CustomPageRouteThemeData] associated with the subtree.
  final CustomPageRouteThemeData? data;

  /// Returns the [CustomPageRouteThemeData] most closely associated with the given context.
  static CustomPageRouteThemeData? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<CustomPageRouteTheme>();
    return result?.data;
  }

  @override
  bool updateShouldNotify(covariant CustomPageRouteTheme oldWidget) {
    return oldWidget.data != data;
  }
}

/// The theme data of [CustomPageRoute], which can be got from the subtree by [CustomPageRouteTheme.of].
class CustomPageRouteThemeData with Diagnosticable {
  const CustomPageRouteThemeData({
    this.transitionDuration,
    this.transitionsBuilder,
  });

  /// Mirrors to [TransitionRoute.transitionDuration].
  final Duration? transitionDuration;

  ///
  final PageTransitionsBuilder? transitionsBuilder;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  CustomPageRouteThemeData copyWith({
    bool? maintainState,
    Duration? transitionDuration,
    PageTransitionsBuilder? transitionsBuilder,
    bool? allowSwipeTransition,
  }) {
    return CustomPageRouteThemeData(
      transitionDuration: transitionDuration ?? this.transitionDuration,
      transitionsBuilder: transitionsBuilder ?? this.transitionsBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! CustomPageRouteThemeData) {
      return false;
    }
    return other.transitionDuration == transitionDuration && other.transitionsBuilder == transitionsBuilder;
  }

  @override
  int get hashCode {
    return hashValues(
      transitionDuration,
      transitionsBuilder,
    );
  }
}

/// [CupertinoPageTransitionsBuilder] ...
///
///
class NoPopGestureCupertinoPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoPopGestureCupertinoPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // return CupertinoRouteTransitionMixin.buildPageTransitions<T>(route, context, animation, secondaryAnimation, child);
    final bool linearTransition = CupertinoRouteTransitionMixin.isPopGestureInProgress(route);
    if (route.fullscreenDialog) {
      return CupertinoFullscreenDialogTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: linearTransition,
        child: child,
      );
    } else {
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: linearTransition,
        child: child, // _CupertinoBackGestureDetector
      );
    }
  }
}
