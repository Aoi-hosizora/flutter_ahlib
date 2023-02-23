import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A customizable [PageRoute] which is similar to [MaterialPageRoute] or [CupertinoPageRoute],
/// but this [PageRoute] supports customizable transition duration, transitions builder, and
/// more, and these settings are fixed and can not be customized in these builtin [PageRoute].
class CustomPageRoute<T> extends PageRoute<T> {
  /// Creates a [CustomPageRoute] using given nullable [context] and named parameters.
  ///
  /// Here [transitionDuration], [reverseTransitionDuration], [barrierColor], [barrierCurve]
  /// and [transitionsBuilder] will fallback to use [CustomPageRouteThemeData] if these values
  /// are null.
  ///
  /// Note that when [Navigator.pushReplacement] is used, you need to pass the parent context to
  /// [context], or use [CustomPageRoute.fromTheme] with previously stored [CustomPageRouteThemeData],
  /// in order to get the correct theme data from not disposed context.
  CustomPageRoute({
    required this.context,
    required this.builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    this.maintainState = true,
    // <<<
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Color? barrierColor,
    Curve? barrierCurve,
    bool? disableCanTransitionTo,
    bool? disableCanTransitionFrom,
    PageTransitionsBuilder? transitionsBuilder,
  })  : _transitionDuration = transitionDuration,
        _reverseTransitionDuration = reverseTransitionDuration,
        _barrierColor = barrierColor,
        _barrierCurve = barrierCurve,
        _disableCanTransitionTo = disableCanTransitionTo,
        _disableCanTransitionFrom = disableCanTransitionFrom,
        _transitionsBuilder = transitionsBuilder,
        super(settings: settings, fullscreenDialog: fullscreenDialog) {
    assert(opaque);
  }

  /// Creates a [CustomPageRoute] using given [CustomPageRouteThemeData] and named parameters.
  ///
  /// Note that the only difference between the default constructor is, this constructor do not
  /// retrieve [CustomPageRouteTheme] from [context], and use passed nullable [themeData] instead.
  CustomPageRoute.fromTheme({
    required CustomPageRouteThemeData? themeData,
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    bool maintainState = true,
    // <<<
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Color? barrierColor,
    Curve? barrierCurve,
    bool? disableCanTransitionTo,
    bool? disableCanTransitionFrom,
    PageTransitionsBuilder? transitionsBuilder,
  }) : this(
          context: null,
          builder: builder,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          transitionDuration: transitionDuration ?? themeData?.transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration ?? themeData?.reverseTransitionDuration,
          barrierColor: barrierColor ?? themeData?.barrierColor,
          barrierCurve: barrierCurve ?? themeData?.barrierCurve,
          disableCanTransitionTo: disableCanTransitionTo ?? themeData?.disableCanTransitionTo,
          disableCanTransitionFrom: disableCanTransitionFrom ?? themeData?.disableCanTransitionFrom,
          transitionsBuilder: transitionsBuilder ?? themeData?.transitionsBuilder,
        );

  /// The build context which is used for getting [CustomPageRouteThemeData] of the route.
  ///
  /// Note that you can set [context] to null and ignore [CustomPageRouteTheme] in subtree,
  /// otherwise widget of [context] must not be deactivated, because looking up a deactivated
  /// widget's ancestor is unsafe.
  final BuildContext? context;

  /// The widget builder for building the primary contents of the route.
  final WidgetBuilder builder;

  @override
  final bool maintainState;
  final Duration? _transitionDuration;
  final Duration? _reverseTransitionDuration;
  final Color? _barrierColor;
  final Curve? _barrierCurve;
  final bool? _disableCanTransitionTo;
  final bool? _disableCanTransitionFrom;
  final PageTransitionsBuilder? _transitionsBuilder;

  // Gets [CustomPageRouteThemeData] from nullable [context].
  CustomPageRouteThemeData? get _theme => context == null ? null : CustomPageRouteTheme.of(context!);

  /// The duration the transition going forwards.
  @override
  Duration get transitionDuration {
    return _transitionDuration ?? _theme?.transitionDuration ?? const Duration(milliseconds: 300);
  }

  /// The duration the transition going in reverse.
  @override
  Duration get reverseTransitionDuration {
    return _reverseTransitionDuration ?? _theme?.reverseTransitionDuration ?? transitionDuration;
  }

  /// The color to use for the modal barrier.
  @override
  Color? get barrierColor {
    return _barrierColor ?? _theme?.barrierColor ?? Colors.transparent;
  }

  /// The curve that is used for animating the modal barrier in and out.
  @override
  Curve get barrierCurve {
    return _barrierCurve ?? _theme?.barrierCurve ?? Curves.ease;
  }

  /// Mirrors to [ModalRoute.barrierLabel].
  @override
  String? get barrierLabel => null;

  /// Mirrors to [ModalRoute.barrierDismissible].
  @override
  bool get barrierDismissible => false;

  /// The flag to disable this route's transition animation when next route is pushed or popped.
  bool get disableCanTransitionTo {
    return _disableCanTransitionTo ?? _theme?.disableCanTransitionTo ?? false;
  }

  /// The flag to disable transition previous route's animation when this route is pushed or popped.
  bool get disableCanTransitionFrom {
    return _disableCanTransitionFrom ?? _theme?.disableCanTransitionFrom ?? false;
  }

  /// The function which defines a [CustomPageRoute] page transition animation.
  PageTransitionsBuilder? get transitionsBuilder {
    return _transitionsBuilder ?? _theme?.transitionsBuilder;
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    // Will never be called when previous is MaterialPageRoute and CupertinoPageRoute.
    return !disableCanTransitionFrom && previousRoute is PageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return !disableCanTransitionTo && nextRoute is PageRoute && !nextRoute.fullscreenDialog;
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
    var builder = transitionsBuilder?.buildTransitions ?? Theme.of(context).pageTransitionsTheme.buildTransitions;
    return builder<T>(this, context, animation, secondaryAnimation, child);
  }
}

/// An inherited widget that associates an [CustomPageRouteThemeData] with a subtree.
class CustomPageRouteTheme extends InheritedWidget {
  const CustomPageRouteTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The data associated with the subtree.
  final CustomPageRouteThemeData data;

  /// Returns the data most closely associated with the given context.
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
    this.reverseTransitionDuration,
    this.barrierColor,
    this.barrierCurve,
    this.disableCanTransitionTo,
    this.disableCanTransitionFrom,
    this.transitionsBuilder,
  });

  /// The duration the transition going forwards, defaults to `Duration(milliseconds: 300)`.
  final Duration? transitionDuration;

  /// The duration the transition going in reverse, defaults to null, and it means
  /// equalling to [transitionDuration].
  final Duration? reverseTransitionDuration;

  /// The color to use for the modal barrier, defaults to `Colors.transparent`.
  final Color? barrierColor;

  /// The curve that is used for animating the modal barrier in and out, defaults to `Curves.ease`.
  final Curve? barrierCurve;

  /// The flag to disable this route's transition animation when next route is pushed or popped,
  /// defaults to false.
  ///
  /// Because of [MaterialPageRoute] and [CupertinoPageRoute]'s setting, transition animation
  /// of routes which push on top of these builtin routes will be disabled, and this will also
  /// affect the first pushed [CustomPageRoute] in [MaterialApp].
  final bool? disableCanTransitionTo;

  /// The flag to disable transition previous route's animation when this route is pushed or popped,
  /// defaults to false.
  ///
  /// Actually [CustomPageRoute.canTransitionFrom] will never be called when previous route is
  /// [MaterialPageRoute] or [CupertinoPageRoute] because of [TransitionRoute._updateSecondaryAnimation]'s
  /// short-circuit evaluation with [MaterialRouteTransitionMixin.canTransitionTo] and [CupertinoRouteTransitionMixin.canTransitionTo].
  final bool? disableCanTransitionFrom;

  /// The function which defines a [CustomPageRoute] page transition animation, defaults to [PageTransitionsTheme].
  ///
  /// You are suggested to to set this value manually to ensure [CustomPageRoute] have a normal transition behavior.
  final PageTransitionsBuilder? transitionsBuilder;

  /// Creates a copy of this value but with given fields replaced with the new values.
  CustomPageRouteThemeData copyWith({
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Color? barrierColor,
    Curve? barrierCurve,
    bool? disableCanTransitionTo,
    bool? disableCanTransitionFrom,
    PageTransitionsBuilder? transitionsBuilder,
  }) {
    return CustomPageRouteThemeData(
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration ?? this.reverseTransitionDuration,
      barrierColor: barrierColor ?? this.barrierColor,
      barrierCurve: barrierCurve ?? this.barrierCurve,
      disableCanTransitionTo: disableCanTransitionTo ?? this.disableCanTransitionTo,
      disableCanTransitionFrom: disableCanTransitionFrom ?? this.disableCanTransitionFrom,
      transitionsBuilder: transitionsBuilder ?? this.transitionsBuilder,
    );
  }

  /// Creates a new value that is a combination of given value and fallback value.
  static CustomPageRouteThemeData merge(CustomPageRouteThemeData data, CustomPageRouteThemeData? fallback) {
    return CustomPageRouteThemeData(
      transitionDuration: data.transitionDuration ?? fallback?.transitionDuration,
      reverseTransitionDuration: data.reverseTransitionDuration ?? fallback?.reverseTransitionDuration,
      barrierColor: data.barrierColor ?? fallback?.barrierColor,
      barrierCurve: data.barrierCurve ?? fallback?.barrierCurve,
      disableCanTransitionTo: data.disableCanTransitionTo ?? fallback?.disableCanTransitionTo,
      disableCanTransitionFrom: data.disableCanTransitionFrom ?? fallback?.disableCanTransitionFrom,
      transitionsBuilder: data.transitionsBuilder ?? fallback?.transitionsBuilder,
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
        other.reverseTransitionDuration == reverseTransitionDuration &&
        other.barrierColor == barrierColor &&
        other.barrierCurve == barrierCurve &&
        other.disableCanTransitionTo == disableCanTransitionTo &&
        other.disableCanTransitionFrom == disableCanTransitionFrom &&
        other.transitionsBuilder == transitionsBuilder;
  }

  @override
  int get hashCode {
    return hashValues(
      transitionDuration,
      reverseTransitionDuration,
      barrierColor,
      barrierCurve,
      disableCanTransitionTo,
      disableCanTransitionFrom,
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
