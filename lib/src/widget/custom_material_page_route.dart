import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
class CustomMaterialPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  ///
  CustomMaterialPageRoute({
    required this.context,
    required this.builder,
    RouteSettings? settings,
    bool? maintainState,
    bool fullscreenDialog = false,
    Duration? transitionDuration,
  })  : _maintainState = maintainState,
        _transitionDuration = transitionDuration,
        super(settings: settings, fullscreenDialog: fullscreenDialog) {
    assert(opaque);
  }

  final BuildContext context;

  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  // TODO PageRouteBuilder https://gaprot.jp/2020/10/05/flutter-transition-animation/

  final bool? _maintainState;

  @override
  bool get maintainState {
    final theme = CustomMaterialPageRouteTheme.of(context);
    return _maintainState ?? theme?.maintainState ?? true;
  }

  final Duration? _transitionDuration;

  @override
  Duration get transitionDuration {
    final theme = CustomMaterialPageRouteTheme.of(context);
    return _transitionDuration ?? theme?.transitionDuration ?? const Duration(milliseconds: 300);
  }
}

/// Associates an [CustomMaterialPageRouteThemeData] with a subtree. The [CustomMaterialPageRoute] uses
/// [of] methods to find the [CustomMaterialPageRouteThemeData] associated with its subtree.
class CustomMaterialPageRouteTheme extends InheritedWidget {
  /// Creates a widget that associates a [CustomMaterialPageRouteThemeData] with a subtree.
  const CustomMaterialPageRouteTheme({
    Key? key,
    required CustomMaterialPageRouteThemeData this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The [CustomMaterialPageRouteThemeData] associated with the subtree.
  final CustomMaterialPageRouteThemeData? data;

  /// Returns the [CustomMaterialPageRouteThemeData] most closely associated with the given context.
  static CustomMaterialPageRouteThemeData? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<CustomMaterialPageRouteTheme>();
    return result?.data;
  }

  @override
  bool updateShouldNotify(covariant CustomMaterialPageRouteTheme oldWidget) {
    return oldWidget.data != data;
  }
}

/// The theme data of [CustomMaterialPageRoute], which can be got from the subtree by [CustomMaterialPageRouteTheme.of].
class CustomMaterialPageRouteThemeData with Diagnosticable {
  const CustomMaterialPageRouteThemeData({
    this.maintainState,
    this.transitionDuration,
  });

  /// Mirrors to [ModalRoute.maintainState].
  final bool? maintainState;

  /// Mirrors to [TransitionRoute.transitionDuration].
  final Duration? transitionDuration;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  CustomMaterialPageRouteThemeData copyWith({
    bool? maintainState,
    Duration? transitionDuration,
  }) {
    return CustomMaterialPageRouteThemeData(
      maintainState: maintainState ?? this.maintainState,
      transitionDuration: transitionDuration ?? this.transitionDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! CustomMaterialPageRouteThemeData) {
      return false;
    }
    return other.maintainState == maintainState && //
        other.transitionDuration == transitionDuration;
  }

  @override
  int get hashCode {
    return hashValues(
      maintainState,
      transitionDuration,
    );
  }
}
