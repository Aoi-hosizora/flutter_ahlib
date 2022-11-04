import 'package:flutter/material.dart';

/// An extended [Scrollbar], this widget uses [ScrollbarTheme] to enrich builtin [Scrollbar].
class ExtendedScrollbar extends StatelessWidget {
  const ExtendedScrollbar({
    Key? key,
    required this.child,
    this.controller,
    this.isAlwaysShown,
    this.trackVisibility,
    this.showTrackOnHover,
    this.hoverThickness,
    this.thickness,
    this.radius,
    this.interactive,
    this.notificationPredicate,
    this.scrollbarOrientation,
    this.thumbColor,
    this.trackColor,
    this.trackBorderColor,
    this.crossAxisMargin,
    this.mainAxisMargin,
    this.minThumbLength,
  }) : super(key: key);

  /// Mirrors to [Scrollbar.child].
  final Widget child;

  /// Mirrors to [Scrollbar.controller].
  final ScrollController? controller;

  /// Mirrors to [Scrollbar.isAlwaysShown].
  final bool? isAlwaysShown;

  /// Mirrors to [Scrollbar.trackVisibility].
  final bool? trackVisibility;

  /// Mirrors to [Scrollbar.showTrackOnHover].
  final bool? showTrackOnHover;

  /// Mirrors to [Scrollbar.hoverThickness].
  final double? hoverThickness;

  /// Mirrors to [Scrollbar.thickness].
  final double? thickness;

  /// Mirrors to [Scrollbar.radius].
  final Radius? radius;

  /// Mirrors to [Scrollbar.interactive].
  final bool? interactive;

  /// Mirrors to [Scrollbar.notificationPredicate].
  final ScrollNotificationPredicate? notificationPredicate;

  /// Mirrors to [Scrollbar.scrollbarOrientation].
  final ScrollbarOrientation? scrollbarOrientation;

  /// Mirrors to [ScrollbarThemeData.thumbColor].
  final MaterialStateProperty<Color?>? thumbColor;

  /// Mirrors to [ScrollbarThemeData.trackColor].
  final MaterialStateProperty<Color?>? trackColor;

  /// Mirrors to [ScrollbarThemeData.trackBorderColor].
  final MaterialStateProperty<Color?>? trackBorderColor;

  /// Mirrors to [ScrollbarThemeData.crossAxisMargin].
  final double? crossAxisMargin;

  /// Mirrors to [ScrollbarThemeData.mainAxisMargin].
  final double? mainAxisMargin;

  /// Mirrors to [ScrollbarThemeData.minThumbLength].
  final double? minThumbLength;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: Theme.of(context).scrollbarTheme.copyWith(
              thumbColor: thumbColor,
              trackColor: trackColor,
              trackBorderColor: trackBorderColor,
              crossAxisMargin: crossAxisMargin,
              mainAxisMargin: mainAxisMargin,
              minThumbLength: minThumbLength,
            ),
      ),
      child: Scrollbar(
        child: child,
        controller: controller,
        isAlwaysShown: isAlwaysShown,
        trackVisibility: trackVisibility,
        showTrackOnHover: showTrackOnHover,
        hoverThickness: hoverThickness,
        thickness: thickness,
        radius: radius,
        interactive: interactive,
        notificationPredicate: notificationPredicate,
        scrollbarOrientation: scrollbarOrientation,
      ),
    );
  }
}
