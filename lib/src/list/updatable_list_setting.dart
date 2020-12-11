import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// A setting for updatable list view. Including `RefreshableXXX` and `PaginationXXX`, including
/// [RefreshableListView], [RefreshableSliverListView], [RefreshableStaggeredGridView] and
/// [PaginationListView], [PaginationSliverListView], [PaginationStaggeredGridView].
class UpdatableListSetting<T> {
  const UpdatableListSetting({
    this.refreshFirst = true,
    this.clearWhenRefresh = false,
    this.clearWhenError = false,
    this.updateOnlyIfNotEmpty = false,
    this.onStartLoading,
    this.onStopLoading,
    this.onAppend,
    this.onError,
    this.placeholderSetting = const PlaceholderSetting(),
    this.onStateChanged,
  })  : assert(refreshFirst != null),
        assert(clearWhenRefresh != null),
        assert(clearWhenError != null),
        assert(updateOnlyIfNotEmpty != null),
        assert(placeholderSetting != null);

  /// Do refresh when init view.
  final bool refreshFirst;

  /// Clear list and error message when refresh data.
  final bool clearWhenRefresh;

  /// Clear list when error aroused.
  final bool clearWhenError;

  /// Update list only when return data is not empty.
  final bool updateOnlyIfNotEmpty;

  /// Callback when start loading.
  final void Function() onStartLoading;

  /// Callback when stop loading.
  final void Function() onStopLoading;

  /// Callback when data has been appended.
  final void Function(List<T>) onAppend;

  /// Callback when error invoked.
  final void Function(dynamic) onError;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// Callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;
}
