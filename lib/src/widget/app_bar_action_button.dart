import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Associates an [AppBarActionButtonThemeData] with a subtree. The [AppBarActionButton] uses
/// [of] methods to find the [AppBarActionButtonThemeData] associated with its subtree.
class AppBarActionButtonTheme extends InheritedWidget {
  /// Creates a widget that associates a [AppBarActionButtonThemeData] with a subtree.
  const AppBarActionButtonTheme({
    Key? key,
    required AppBarActionButtonThemeData this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The [AppBarActionButtonThemeData] associated with the subtree.
  final AppBarActionButtonThemeData? data;

  /// Returns the [AppBarActionButtonThemeData] most closely associated with the given context.
  static AppBarActionButtonThemeData? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppBarActionButtonTheme>();
    return result?.data;
  }

  @override
  bool updateShouldNotify(covariant AppBarActionButtonTheme oldWidget) {
    return oldWidget.data != data;
  }
}

/// The theme data of [AppBarActionButton], which can be got from the subtree by [AppBarActionButtonTheme.of].
class AppBarActionButtonThemeData with Diagnosticable {
  const AppBarActionButtonThemeData({
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.focusColor,
    this.hoverColor,
    this.color,
    this.splashColor,
    this.highlightColor,
    this.disabledColor,
    this.mouseCursor,
    this.autofocus,
    this.enableFeedback,
    this.constraints,
  });

  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? splashRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? color;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? disabledColor;
  final MouseCursor? mouseCursor;
  final bool? autofocus;
  final bool? enableFeedback;
  final BoxConstraints? constraints;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  AppBarActionButtonThemeData copyWith({
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Color? focusColor,
    Color? hoverColor,
    Color? color,
    Color? splashColor,
    Color? highlightColor,
    Color? disabledColor,
    MouseCursor? mouseCursor,
    bool? autofocus,
    bool? enableFeedback,
    BoxConstraints? constraints,
  }) {
    return AppBarActionButtonThemeData(
      iconSize: iconSize ?? this.iconSize,
      visualDensity: visualDensity ?? this.visualDensity,
      padding: padding ?? this.padding,
      alignment: alignment ?? this.alignment,
      splashRadius: splashRadius ?? this.splashRadius,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      color: color ?? this.color,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      disabledColor: disabledColor ?? this.disabledColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      autofocus: autofocus ?? this.autofocus,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      constraints: constraints ?? this.constraints,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! AppBarActionButtonThemeData) {
      return false;
    }
    return other.iconSize == iconSize && //
        other.visualDensity == visualDensity &&
        other.padding == padding &&
        other.alignment == alignment &&
        other.splashRadius == splashRadius &&
        other.focusColor == focusColor &&
        other.hoverColor == hoverColor &&
        other.color == color &&
        other.splashColor == splashColor &&
        other.highlightColor == highlightColor &&
        other.disabledColor == disabledColor &&
        other.mouseCursor == mouseCursor &&
        other.autofocus == autofocus &&
        other.enableFeedback == enableFeedback &&
        other.constraints == constraints;
  }

  @override
  int get hashCode {
    return hashValues(
      iconSize,
      visualDensity,
      padding,
      alignment,
      splashRadius,
      focusColor,
      hoverColor,
      color,
      splashColor,
      highlightColor,
      disabledColor,
      mouseCursor,
      autofocus,
      enableFeedback,
      constraints,
    );
  }
}

/// An [IconButton] that uses [AppBarActionButtonThemeData] as its default theme, can be used
/// to show action button with consistent theme in [AppBar].
class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    // <<<
    this.iconSize /* 24 */,
    this.visualDensity,
    this.padding /* const EdgeInsets.all(8.0) */,
    this.alignment /* Alignment.center */,
    this.splashRadius,
    this.focusColor,
    this.hoverColor,
    this.color,
    this.splashColor,
    this.highlightColor,
    this.disabledColor,
    this.mouseCursor,
    this.focusNode,
    this.autofocus /* false */,
    this.enableFeedback /* true */,
    this.constraints,
  })  : assert(splashRadius == null || splashRadius > 0),
        super(key: key);

  // not contained in theme
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  // contained in theme, except for focusNode
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? splashRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? color;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? disabledColor;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? enableFeedback;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final theme = AppBarActionButtonTheme.of(context);
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      // <<<
      iconSize: iconSize ?? theme?.iconSize ?? 24,
      visualDensity: visualDensity ?? theme?.visualDensity,
      padding: padding ?? theme?.padding ?? const EdgeInsets.all(8.0),
      alignment: alignment ?? theme?.alignment ?? Alignment.center,
      splashRadius: splashRadius ?? theme?.splashRadius,
      focusColor: focusColor ?? theme?.focusColor,
      hoverColor: hoverColor ?? theme?.hoverColor,
      color: color ?? theme?.color,
      splashColor: splashColor ?? theme?.splashColor,
      highlightColor: highlightColor ?? theme?.highlightColor,
      disabledColor: disabledColor ?? theme?.disabledColor,
      mouseCursor: mouseCursor ?? theme?.mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus ?? theme?.autofocus ?? false,
      enableFeedback: enableFeedback ?? theme?.enableFeedback ?? true,
      constraints: constraints ?? theme?.constraints,
    );
  }

  /// Creates the default [AppBarActionButton] which will be used as leading button in [AppBar].
  static Widget? leading({
    required BuildContext context,
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Color? focusColor,
    Color? hoverColor,
    Color? color,
    Color? splashColor,
    Color? highlightColor,
    Color? disabledColor,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool? autofocus,
    bool? enableFeedback,
    BoxConstraints? constraints,
  }) {
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;

    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    Widget icon;
    String tooltip;
    VoidCallback onPressed;
    if (hasDrawer) {
      icon = const Icon(Icons.menu);
      tooltip = MaterialLocalizations.of(context).openAppDrawerTooltip;
      onPressed = () => Scaffold.of(context).openDrawer();
    } else if (!hasEndDrawer && canPop) {
      if (useCloseButton) {
        icon = const Icon(Icons.close);
        tooltip = MaterialLocalizations.of(context).closeButtonTooltip;
        onPressed = () => Navigator.maybePop(context);
      } else {
        icon = const BackButtonIcon();
        tooltip = MaterialLocalizations.of(context).backButtonTooltip;
        onPressed = () => Navigator.maybePop(context);
      }
    } else {
      return null;
    }

    return AppBarActionButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: onPressed,
      // <<<
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      focusColor: focusColor,
      hoverColor: hoverColor,
      color: color,
      splashColor: splashColor,
      highlightColor: highlightColor,
      disabledColor: disabledColor,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      constraints: constraints,
    );
  }
}
