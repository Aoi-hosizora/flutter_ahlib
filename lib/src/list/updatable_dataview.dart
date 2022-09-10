import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// An abstract widget for updatable data view, implemented by [RefreshableDataView] and [PaginationDataView].
abstract class UpdatableDataView<T> extends StatefulWidget {
  const UpdatableDataView({Key? key}) : super(key: key);

  /// The list of data.
  List<T> get data;

  /// The data display style.
  UpdatableDataViewStyle get style;

  /// The display and behavior setting.
  UpdatableDataViewSetting<T> get setting;

  /// The controller for [ScrollView].
  ScrollController? get scrollController;

  /// The itemBuilder for [ScrollView].
  Widget Function(BuildContext, int, T) get itemBuilder;

  /// The extra widgets around [ScrollView].
  UpdatableDataViewExtraWidgets? get extra;
}

/// An enum type for [UpdatableDataView], which represents the data display style.
enum UpdatableDataViewStyle {
  /// Displays data in [ListView].
  listView,

  /// Displays data in [SliverList] and [CustomScrollView].
  sliverListView,

  /// Displays data in [MasonryGridView].
  masonryGridView,

  /// Displays data in [SliverMasonryGrid] and [CustomScrollView].
  sliverMasonryGridView,
}

/// A list of behavior and display settings for [UpdatableDataView].
class UpdatableDataViewSetting<T> {
  const UpdatableDataViewSetting({
    // display settings for scroll view
    this.padding,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.reverse = false,
    this.shrinkWrap = false,
    this.wantKeepAlive = true,
    // display settings for scrollbar
    this.scrollbar = true,
    this.alwaysShowScrollbar = false,
    this.interactiveScrollbar = false,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarMainAxisMargin,
    this.scrollbarCrossAxisMargin,
    // display settings for refresh indicator
    this.refreshIndicatorColor,
    this.refreshIndicatorBackgroundColor,
    this.refreshIndicatorDisplacement = 40.0,
    this.refreshIndicatorStrokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.refreshNotificationPredicate = defaultScrollNotificationPredicate,
    // display settings for append indicator
    this.appendIndicatorColor,
    this.appendIndicatorBackgroundColor,
    this.appendIndicatorMinHeight = 5.0,
    this.appendNotificationPredicate = defaultScrollNotificationPredicate,
    // display settings for placeholder text
    this.placeholderSetting = const PlaceholderSetting(),
    // behavior settings
    this.refreshFirst = true,
    this.clearWhenRefresh = false,
    this.clearWhenError = false,
    this.updateOnlyIfNotEmpty = false,
    // behavior callbacks
    this.onPlaceholderStateChanged,
    this.onStartRefreshing,
    this.onStopRefreshing,
    this.onStartGettingData,
    this.onStopGettingData,
    this.onAppend,
    this.onError,
    this.onNothing,
  });

  // Display settings

  /// The padding for [ScrollView].
  final EdgeInsetsGeometry? padding;

  /// The physics for [ScrollView], defaults to [AlwaysScrollableScrollPhysics()].
  final ScrollPhysics? physics;

  /// The reverse for [ScrollView], defaults to false.
  final bool? reverse;

  /// The shrinkWrap for [ScrollView], defaults to false.
  final bool? shrinkWrap;

  /// The wantKeepAlive for [AutomaticKeepAliveClientMixin], defaults to true.
  final bool? wantKeepAlive;

  /// The visibility for [Scrollbar], defaults to true.
  final bool? scrollbar;

  /// The check to always show [Scrollbar], defaults to false.
  final bool? alwaysShowScrollbar;

  /// The interactive for [Scrollbar], defaults to false, you must pass non-null [ScrollController] if you set this to true.
  final bool? interactiveScrollbar;

  /// The radius for [Scrollbar].
  final Radius? scrollbarRadius;

  /// The thickness for [Scrollbar].
  final double? scrollbarThickness;

  /// The mainAxisMargin for [Scrollbar].
  final double? scrollbarMainAxisMargin;

  /// The crossAxisMargin for [Scrollbar].
  final double? scrollbarCrossAxisMargin;

  /// The color for [RefreshIndicator], defaults to [ColorScheme.primary].
  final Color? refreshIndicatorColor; // TODO

  /// The background color for [RefreshIndicator], defaults to [ThemeData.canvasColor].
  final Color? refreshIndicatorBackgroundColor; // TODO

  /// The displacement for [RefreshIndicator], defaults to 40.0.
  final double? refreshIndicatorDisplacement; // TODO

  /// The stroke width for [RefreshIndicator], defaults to [RefreshProgressIndicator.defaultStrokeWidth].
  final double? refreshIndicatorStrokeWidth; // TODO

  /// The notificationPredicate for [RefreshIndicator], defaults to [defaultScrollNotificationPredicate]..
  final ScrollNotificationPredicate? refreshNotificationPredicate;

  /// The Color for [AppendIndicator], only used for pagination.
  final Color? appendIndicatorColor; // TODO

  /// The BackgroundColor for [AppendIndicator], only used for pagination.
  final Color? appendIndicatorBackgroundColor; // TODO

  /// The MinHeight for [AppendIndicator], defaults to 5.0, only used for pagination.
  final double? appendIndicatorMinHeight; // TODO

  /// The notificationPredicate for [AppendIndicator], defaults to [defaultScrollNotificationPredicate], only used for pagination.
  final ScrollNotificationPredicate? appendNotificationPredicate;

  /// The setting for [PlaceholderText], defaults to [PlaceholderSetting()].
  final PlaceholderSetting? placeholderSetting;

  // Behavior settings and callbacks

  /// The switcher to do refresh when init view, defaults to true.
  final bool? refreshFirst;

  /// The switcher to clear list and error message when refresh data, defaults to false.
  final bool? clearWhenRefresh;

  /// The switcher to clear list when error aroused, defaults to false.
  final bool? clearWhenError;

  /// The switcher to update list only when returned data is not empty, defaults to false, only used for pagination.
  final bool? updateOnlyIfNotEmpty;

  /// The callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback? onPlaceholderStateChanged;

  /// The callback when start refreshing.
  final void Function()? onStartRefreshing;

  /// The callback when stop refreshing.
  final void Function()? onStopRefreshing;

  /// The callback when start getting data.
  final void Function()? onStartGettingData;

  /// The callback when stop getting data.
  final void Function()? onStopGettingData;

  /// The callback when data has been replaced or appended.
  final void Function(dynamic indicator, List<T> appendedData)? onAppend;

  /// The callback when error invoked.
  final void Function(dynamic error)? onError;

  /// The callback when get nothing, used for only pagination.
  final void Function()? onNothing;
}

/// A list of extra widgets used in [UpdatableDataView], includes widget and divider lies before or after [ScrollView], inside or outside [PlaceholderText].
///
/// Widgets order:
/// ```
/// outerTopWidgets
/// ================== (PlaceholderText)
/// innerTopWidgets
/// ================== (ScrollView)
/// listTopWidgets
/// ...                (with separator)
/// listBottomWidgets
/// ================== (ScrollView)
/// innerBottomWidgets
/// ================== (PlaceholderText)
/// outerBottomWidgets
/// ```
class UpdatableDataViewExtraWidgets {
  const UpdatableDataViewExtraWidgets({
    this.outerCrossAxisAlignment = CrossAxisAlignment.center,
    this.innerCrossAxisAlignment = CrossAxisAlignment.center,
    this.outerTopWidgets,
    this.innerTopWidgets,
    this.listTopWidgets,
    this.listBottomWidgets,
    this.innerBottomWidgets,
    this.outerBottomWidgets,
  });

  /// The crossAxisAlignment for outer [Column] outside [PlaceholderText], defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment? outerCrossAxisAlignment;

  /// The crossAxisAlignment for inner [Column] inside [PlaceholderText], defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment? innerCrossAxisAlignment;

  /// The widget before [ScrollView] and outside [PlaceholderText].
  final List<Widget>? outerTopWidgets;

  /// The widget before [ScrollView] and inside [PlaceholderText].
  final List<Widget>? innerTopWidgets;

  /// The widgets in the top of [ScrollView], and there is no separator between widgets.
  final List<Widget>? listTopWidgets;

  /// The widgets in the bottom of [ScrollView], and there is no separator between widgets.
  final List<Widget>? listBottomWidgets;

  /// The widget after [ScrollView] and inside [PlaceholderText].
  final List<Widget>? innerBottomWidgets;

  /// The widget after [ScrollView] and outside [PlaceholderText].
  final List<Widget>? outerBottomWidgets;
}
