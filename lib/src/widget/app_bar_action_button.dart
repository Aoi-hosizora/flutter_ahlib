import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Note: Part of this file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source code:
// - IconButton: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/icon_button.dart
// - AppBar: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/app_bar.dart

/// An extended [IconButton] that uses [AppBarActionButtonThemeData] as its default theme,
/// can be used to show action button with consistent theme in [AppBar].
class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.onLongPress,
    // ===
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

  // The following fields are not contained in theme.

  /// Mirrors to [IconButton.icon].
  final Widget icon;

  /// Mirrors to [IconButton.onPressed].
  final VoidCallback? onPressed;

  /// Mirrors to [IconButton.tooltip].
  final String? tooltip;

  /// The callback for long pressing the button, which can not be customized in [IconButton].
  /// Note that [onLongPress] will make [tooltip] unavailable.
  final VoidCallback? onLongPress;

  // The following fields are all contained in theme, except for focusNode.

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

  // This function is based on Flutter's source code, and is modified by AoiHosizora.
  Widget _buildIconButton({
    required BuildContext context,
    required Widget icon,
    required VoidCallback? onPressed,
    String? tooltip,
    VoidCallback? onLongPress,
    // ===
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    AlignmentGeometry alignment = Alignment.center,
    double? splashRadius,
    Color? focusColor,
    Color? hoverColor,
    Color? color,
    Color? splashColor,
    Color? highlightColor,
    Color? disabledColor,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = true,
    BoxConstraints? constraints,
  }) {
    assert(debugCheckHasMaterial(context));
    const double _kMinButtonSize = kMinInteractiveDimension;
    final ThemeData theme = Theme.of(context);
    final Color? currentColor = onPressed != null ? color : (disabledColor ?? theme.disabledColor);
    final VisualDensity effectiveVisualDensity = visualDensity ?? theme.visualDensity;
    final BoxConstraints unadjustedConstraints = constraints ?? const BoxConstraints(minWidth: _kMinButtonSize, minHeight: _kMinButtonSize);
    final BoxConstraints adjustedConstraints = effectiveVisualDensity.effectiveConstraints(unadjustedConstraints);
    final double effectiveIconSize = iconSize ?? IconTheme.of(context).size ?? 24.0;

    Widget result = ConstrainedBox(
      constraints: adjustedConstraints,
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: effectiveIconSize,
          width: effectiveIconSize,
          child: Align(
            alignment: alignment,
            child: IconTheme.merge(
              data: IconThemeData(
                size: effectiveIconSize,
                color: currentColor,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
    if (onLongPress == null /* <<< Modified by AoiHosizora */ && tooltip != null) {
      result = Tooltip(
        message: tooltip,
        child: result,
      );
    }
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: InkResponse(
        focusNode: focusNode,
        autofocus: autofocus,
        canRequestFocus: onPressed != null,
        onTap: onPressed,
        onLongPress: onLongPress /* <<< Modified by AoiHosizora */,
        mouseCursor: mouseCursor ?? (onPressed == null ? SystemMouseCursors.forbidden : SystemMouseCursors.click),
        enableFeedback: enableFeedback,
        focusColor: focusColor ?? theme.focusColor,
        hoverColor: hoverColor ?? theme.hoverColor,
        highlightColor: highlightColor ?? theme.highlightColor,
        splashColor: splashColor ?? theme.splashColor,
        radius: splashRadius ??
            math.max(
              Material.defaultSplashRadius,
              (effectiveIconSize + math.min(padding.horizontal, padding.vertical)) * 0.7,
              // x 0.5 for diameter -> radius and + 40% overflow derived from other Material apps.
            ),
        child: result,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppBarActionButtonTheme.of(context);
    return _buildIconButton(
      context: context,
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      onLongPress: onLongPress,
      // ===
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
  ///
  /// Note that if you want to use [leading] as [Scaffold.appBar]'s leading directly (which
  /// means do not wrap any widgets right under [Scaffold]) and want to display the correct
  /// drawer button, please set [forceUseBuilder] to true.
  ///
  /// [forceUseBuilder] ensures [ScaffoldState] is available by using [Builder] to get the correct
  /// [context], but it will also make [leading] never return null. So if there is no drawer button,
  /// close button or back button, a blank with [AppBar.leadingWidth] width will be displayed.
  static Widget? leading({
    required BuildContext context,
    bool forceUseBuilder = false,
    bool allowDrawerButton = true,
    bool allowPopButton = true,
    String? forceTooltip,
    VoidCallback? forceOnLongPress,
    // <<<
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
    Widget? _build(BuildContext context) {
      final scaffold = Scaffold.maybeOf(context);
      final hasDrawer = scaffold?.hasDrawer ?? false; // no consideration of hasEndDrawer

      final parentRoute = ModalRoute.of(context);
      final canPop = parentRoute?.canPop ?? false;
      final useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

      Widget icon;
      String tooltip;
      VoidCallback onPressed;
      if (allowDrawerButton && hasDrawer) {
        icon = const Icon(Icons.menu);
        tooltip = MaterialLocalizations.of(context).openAppDrawerTooltip;
        onPressed = () => Scaffold.of(context).openDrawer();
      } else if (allowPopButton && canPop) {
        if (useCloseButton) {
          icon = const Icon(Icons.close);
          tooltip = MaterialLocalizations.of(context).closeButtonTooltip;
          onPressed = () => Navigator.maybePop(context);
        } else {
          icon = const BackButtonIcon(); // Icons.arrow_back / Icons.arrow_back_ios
          tooltip = MaterialLocalizations.of(context).backButtonTooltip;
          onPressed = () => Navigator.maybePop(context);
        }
      } else {
        return null;
      }

      return AppBarActionButton(
        icon: icon,
        onPressed: onPressed,
        tooltip: forceTooltip ?? tooltip,
        onLongPress: forceOnLongPress,
        // ===
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

    if (!forceUseBuilder) {
      return _build(context); // nullable
    }
    return Builder(
      builder: (c) =>
          _build(c) ?? //
          const SizedBox.shrink() /* display a blank with fixed width */,
    );
  }
}

/// An inherited widget that associates an [AppBarActionButtonThemeData] with a subtree.
class AppBarActionButtonTheme extends InheritedWidget {
  const AppBarActionButtonTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The data associated with the subtree.
  final AppBarActionButtonThemeData data;

  /// Returns the data most closely associated with the given context.
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

  /// Creates a copy of this value but with given fields replaced with the new values.
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

  /// Creates a new value that is a combination of given value and fallback value.
  static AppBarActionButtonThemeData merge(AppBarActionButtonThemeData data, AppBarActionButtonThemeData? fallback) {
    return AppBarActionButtonThemeData(
      iconSize: data.iconSize ?? fallback?.iconSize,
      visualDensity: data.visualDensity ?? fallback?.visualDensity,
      padding: data.padding ?? fallback?.padding,
      alignment: data.alignment ?? fallback?.alignment,
      splashRadius: data.splashRadius ?? fallback?.splashRadius,
      focusColor: data.focusColor ?? fallback?.focusColor,
      hoverColor: data.hoverColor ?? fallback?.hoverColor,
      color: data.color ?? fallback?.color,
      splashColor: data.splashColor ?? fallback?.splashColor,
      highlightColor: data.highlightColor ?? fallback?.highlightColor,
      disabledColor: data.disabledColor ?? fallback?.disabledColor,
      mouseCursor: data.mouseCursor ?? fallback?.mouseCursor,
      autofocus: data.autofocus ?? fallback?.autofocus,
      enableFeedback: data.enableFeedback ?? fallback?.enableFeedback,
      constraints: data.constraints ?? fallback?.constraints,
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
