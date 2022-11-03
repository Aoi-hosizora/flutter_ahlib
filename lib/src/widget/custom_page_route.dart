import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// TODO add test in example

/// A custom [PageRoute] which is similar to [MaterialPageRoute] or [CupertinoPageRoute],
/// but this supports customizable transition duration and transitions builder, which is
/// fixed in these two builtin [PageRoute].
class CustomPageRoute<T> extends PageRoute<T> {
  /// Creates a [CustomPageRoute] using given named parameters, here [transitionDuration]
  /// and [transitionsBuilder] will fallback to use [CustomPageRouteThemeData] if null.
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

  /// Creates a [CustomPageRoute] in a simple way.
  CustomPageRoute.simple(
    BuildContext context,
    WidgetBuilder builder, {
    RouteSettings? settings,
    bool fullscreenDialog = false,
    bool maintainState = true,
    Duration? transitionDuration,
    PageTransitionsBuilder? transitionsBuilder,
  }) : this(
          context: context,
          builder: builder,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          transitionDuration: transitionDuration,
          transitionsBuilder: transitionsBuilder,
        );

  /// The build context which is used for getting [CustomPageRouteThemeData] of the route.
  final BuildContext context;

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  /// The flag describing whether the route should remain in memory when it is inactive.
  @override
  final bool maintainState;

  /// The duration the transition going forwards, this field is private and [transitionDuration]
  /// will be used.
  final Duration? _transitionDuration;

  /// The function which defines a [MaterialPageRoute] page transition animation, this field
  /// is private and [buildTransitions] will be used.
  final PageTransitionsBuilder? _transitionsBuilder;

  /// Mirrors to [ModalRoute.barrierColor].
  @override
  Color? get barrierColor => null; // TODO effect and is customizable ???

  /// Mirrors to [ModalRoute.barrierLabel].
  @override
  String? get barrierLabel => null;

  /// The duration the transition going forwards.
  @override
  Duration get transitionDuration {
    final theme = CustomPageRouteTheme.of(context);
    return _transitionDuration ?? theme?.transitionDuration ?? const Duration(milliseconds: 300);
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
    final theme = CustomPageRouteTheme.of(context);
    var builder = (_transitionsBuilder ?? theme?.transitionsBuilder)?.buildTransitions ?? Theme.of(context).pageTransitionsTheme.buildTransitions;
    return builder<T>(this, context, animation, secondaryAnimation, child);
  }
}

/// Associates a [CustomPageRouteThemeData] with a subtree. The [CustomPageRoute] uses
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

  /// The duration the transition going forwards, which defaults to `Duration(milliseconds: 300)`
  /// in [MaterialPageRoute], and defaults to `Duration(milliseconds: 400)` in [CupertinoPageRoute].
  final Duration? transitionDuration;

  /// The function which defines a [MaterialPageRoute] page transition animation. You have
  /// to set this value the same as [PageTransitionsTheme] to ensure the transition behavior
  /// of [CustomPageRoute] normal.
  final PageTransitionsBuilder? transitionsBuilder;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  CustomPageRouteThemeData copyWith({
    Duration? transitionDuration,
    PageTransitionsBuilder? transitionsBuilder,
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
    return other.transitionDuration == transitionDuration && //
        other.transitionsBuilder == transitionsBuilder;
  }

  @override
  int get hashCode {
    return hashValues(
      transitionDuration,
      transitionsBuilder,
    );
  }
}

/// A no pop gesture version of [CupertinoPageTransitionsBuilder], which can deal with the
/// swipe behavior conflict between [CupertinoPageTransitionsBuilder] and [Drawer].
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
