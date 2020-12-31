import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/util/flutter_extensions.dart';

/// An abstract widget for updatable data view, including
/// [RefreshableDataView] and [PaginationDataView].
abstract class UpdatableDataView<T> extends StatefulWidget {
  const UpdatableDataView({Key key}) : super(key: key);

  /// The list of scored data, need to be created out of widget.
  List<T> get data;

  /// Some behavior and display settings.
  UpdatableDataViewSetting get setting;

  /// The controller of the behavior.
  UpdatableDataViewController get controller;

  /// The controller for [ScrollView].
  ScrollController get scrollController;

  /// The itemBuilder for [ScrollView].
  Widget Function(BuildContext, T) get itemBuilder;

  /// The padding for [ScrollView].
  EdgeInsetsGeometry get padding;

  /// The physics for [ScrollView].
  ScrollPhysics get physics => AlwaysScrollableScrollPhysics();

  /// The reverse for [ScrollView].
  bool get reverse => false;

  /// The shrinkWrap for [ScrollView].
  bool get shrinkWrap => false;
}

/// A duration of a flashing after clear list, used in [RefreshableDataView.getDataCore] and [PaginationDataView.getDataCore].
final _kFlashListDuration = Duration(milliseconds: 20);

/// A duration of a fake refresh, used in [PaginationDataView.getDataCore].
final _kFakeRefreshDuration = Duration(milliseconds: 100);

/// An abstract [UpdatableDataView] for refreshable data view, including
/// [RefreshableListView], [RefreshableSliverListView], [RefreshableStaggeredGridView].
abstract class RefreshableDataView<T> extends UpdatableDataView<T> {
  const RefreshableDataView({Key key}) : super(key: key);

  /// Function to get list data.
  Future<List<T>> Function() get getData;

  /// The getData implementation.
  Future<void> getDataCore({
    @required void Function(bool) setLoading,
    @required void Function(String) setErrorMessage,
    @required Function() setState,
  }) async {
    // TODO need to test this function in the inherited class.
    assert(setLoading != null);
    assert(setErrorMessage != null);
    assert(setState != null);

    // start loading
    setLoading(true);
    if (setting.clearWhenRefresh) {
      setErrorMessage('');
      data.clear();
    }
    setting.onStartLoading?.call();
    setState();

    // get data
    final func = getData();

    // return future
    return func.then((List<T> list) async {
      // success to get data without error
      setErrorMessage('');
      if (setting.updateOnlyIfNotEmpty && list.isEmpty) {
        return; // get an empty list
      }
      if (data.isNotEmpty) {
        data.clear();
        setState();
        await Future.delayed(_kFlashListDuration);
      }
      data.addAll(list);
      setting.onAppend?.call(list);
    }).catchError((e) {
      // error aroused
      setErrorMessage(e.toString());
      if (setting.clearWhenError) {
        data.clear();
      }
      setting.onError?.call(e);
    }).whenComplete(() {
      // finish loading and setState
      setLoading(false);
      setting.onStopLoading?.call();
      setState();
    });
  }
}

/// A abstract [UpdatableDataView] for appendable data view, including
/// [PaginationListView], [PaginationSliverListView], [PaginationStaggeredGridView].
abstract class PaginationDataView<T> extends UpdatableDataView<T> {
  const PaginationDataView({Key key}) : super(key: key);

  /// The pagination strategy.
  PaginationStrategy get strategy;

  /// Function to get list data when used [PaginationStrategy.offsetBased].
  Future<List<T>> Function({int page}) get getDataByOffset;

  /// Function to get list data when used [PaginationStrategy.seekBased].
  Future<SeekList<T>> Function({dynamic maxId}) get getDataBySeek;

  /// Some pagination settings.
  PaginationDataViewSetting get paginationSetting;

  /// The getData implementation.
  Future<void> getDataCore({
    @required bool reset,
    @required bool downScrollable,
    @required void Function(bool) setLoading,
    @required void Function(String) setErrorMessage,
    @required void Function(int) setNextPage,
    @required void Function(dynamic) setNextMaxId,
    @required int Function() getNextPage,
    @required dynamic getNextMaxId,
    @required Function() setState,
  }) async {
    // TODO need to test this function in the inherited class.
    assert(reset != null);
    assert(downScrollable != null);
    assert(setLoading != null);
    assert(setErrorMessage != null);
    assert(setNextPage != null);
    assert(setNextMaxId != null);
    assert(getNextPage != null);
    assert(getNextMaxId != null);
    assert(setState != null);

    // reset page
    if (reset) {
      setNextPage(paginationSetting.initialPage);
      setNextMaxId(paginationSetting.initialMaxId);
    }

    // start loading
    setLoading(true);
    if (reset && setting.clearWhenRefresh) {
      setErrorMessage('');
      data.clear();
    }
    setting.onStartLoading?.call();
    setState();

    // get data
    switch (strategy) {
      case PaginationStrategy.offsetBased:
        // ==========================
        // offsetBased, use _nextPage
        // ==========================
        final func = getDataByOffset(page: getNextPage());

        // return future
        return func.then((List<T> list) async {
          // success to get data without error
          setErrorMessage('');
          if (setting.updateOnlyIfNotEmpty && list.isEmpty) {
            return; // get an empty list
          }
          // replace or append
          if (reset) {
            if (data.isNotEmpty) {
              data.clear();
              setState();
              await Future.delayed(_kFlashListDuration);
            }
            data.addAll(list);
          } else {
            data.addAll(list);
            scrollController?.scrollDown();
          }
          setNextPage(getNextPage() + 1);
          setting.onAppend?.call(list);
        }).catchError((e) {
          // error aroused
          setErrorMessage(e.toString());
          if (setting.clearWhenError) {
            data.clear();
          }
          setting.onError?.call(e);
        }).whenComplete(() {
          // finish loading and setState
          setLoading(false);
          setting.onStopLoading?.call();
          setState();
        });

      case PaginationStrategy.seekBased:
        // =========================
        // seekBased, use _nextMaxId
        // =========================
        if (getNextMaxId() == paginationSetting.nothingMaxId) {
          await Future.delayed(_kFakeRefreshDuration);
          return Future.value();
        }
        final func = getDataBySeek(maxId: getNextMaxId());

        // return future
        return func.then((SeekList<T> sl) async {
          // success to get data without error
          setErrorMessage('');
          if (setting.updateOnlyIfNotEmpty && sl.list.isEmpty) {
            return; // get an empty list
          }
          // replace or append
          if (reset) {
            if (sl.list.isNotEmpty) {
              data.clear();
              setState();
              await Future.delayed(_kFlashListDuration);
            }
            data.addAll(sl.list);
          } else {
            data.addAll(sl.list);
            if (downScrollable) {
              scrollController?.scrollDown();
            }
          }
          setNextMaxId(sl.nextMaxId);
          setting.onAppend?.call(sl.list);
        }).catchError((e) {
          // error aroused
          setErrorMessage(e.toString());
          if (setting.clearWhenError) {
            data.clear();
          }
          setting.onError?.call(e);
        }).whenComplete(() {
          // finish loading and setState
          setLoading(false);
          setting.onStopLoading?.call();
          setState();
        });
    }
  }
}

/// A list of behavior settings for [UpdatableDataView].
class UpdatableDataViewSetting<T> {
  const UpdatableDataViewSetting({
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
    this.showScrollbar = true,
    this.scrollbarThickness,
    this.scrollbarRadius,
  })  : assert(refreshFirst != null),
        assert(clearWhenRefresh != null),
        assert(clearWhenError != null),
        assert(updateOnlyIfNotEmpty != null),
        assert(placeholderSetting != null),
        assert(showScrollbar != null);

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

  /// The visibility for [Scrollbar].
  final bool showScrollbar;

  /// The thickness for [Scrollbar].
  final double scrollbarThickness;

  /// The radius for [Scrollbar].
  final Radius scrollbarRadius;
}

/// A list of pagination settings for [PaginationDataView].
class PaginationDataViewSetting {
  const PaginationDataViewSetting({
    this.initialPage = 1,
    this.initialMaxId,
    this.nothingMaxId,
  }) : assert(initialPage != null);

  /// The initial page when using [PaginationStrategy.offsetBased], default is 1.
  final int initialPage;

  /// The initial maxId when using [PaginationStrategy.seekBased], nullable.
  final dynamic initialMaxId;

  /// The nothing maxId when using [PaginationStrategy.seekBased], nullable.
  final dynamic nothingMaxId;
}

/// A controller for [UpdatableDataView], it uses two [GlobalKey] to control
/// [RefreshIndicator] and [AppendIndicator], and includes [refresh] and [append].
class UpdatableDataViewController {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;

  /// Register the given [GlobalKey] of [RefreshIndicatorState] to this controller.
  void attachRefresh(GlobalKey<RefreshIndicatorState> key) => _refreshIndicatorKey = key;

  /// Register the given [GlobalKey] of [AppendIndicatorState] to this controller.
  void attachAppend(GlobalKey<AppendIndicatorState> key) => _appendIndicatorKey = key;

  /// Unregister the given [GlobalKey] of [RefreshIndicatorState] from this controller.
  void detachRefresh() => _refreshIndicatorKey = null;

  /// Unregister the given [GlobalKey] of [AppendIndicatorState] from this controller.
  void detachAppend() => _appendIndicatorKey = null;

  @mustCallSuper
  void dispose() {
    detachRefresh();
    detachAppend();
  }

  /// Show the refresh indicator and run the callback as if it had been started interactively.
  /// See [RefreshIndicatorState.show].
  Future<void> refresh() {
    if (_refreshIndicatorKey == null) {
      return Future.value();
    }
    return _refreshIndicatorKey.currentState?.show();
  }

  /// Show the append indicator and run the callback as if it had been started interactively.
  /// See [AppendIndicatorState.show].
  Future<void> append() {
    if (_appendIndicatorKey == null) {
      return Future.value();
    }
    return _appendIndicatorKey.currentState?.show();
  }
}

/// Pagination strategy for [PaginationDataView], including
/// [offsetBased] and [seekBased].
enum PaginationStrategy {
  /// Use `page` and  `limit` as parameters to query list data.
  offsetBased,

  /// Use `maxId` and `limit` as parameters to query list data.
  seekBased,
}

/// Data model for [PaginationDataView], used when using [PaginationStrategy.seekBased] pagination strategy.
class SeekList<T> {
  const SeekList({
    @required this.list,
    @required this.nextMaxId,
  });

  /// Represents the return list.
  final List<T> list;

  /// Represents the next `maxId`, [PaginationDataViewSetting.nothingMaxId] if this is the last page.
  final dynamic nextMaxId;
}
