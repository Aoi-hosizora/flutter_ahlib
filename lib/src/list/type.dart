import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/placeholder_text.dart';

/// Append callback funtion, used in `AppendIndicator`
typedef AppendCallback = Future<void> Function();

/// Placeholder state changed callback function, used in `PlaceholderText`
typedef PlaceholderStateChangedCallback = void Function(PlaceholderState);

/// get page data function, used in `AppendableListView` (appendable)
typedef GetPageDataFunction<T> = Future<List<T>> Function({int page});

/// get non-page data function, used in `RefreshableListView` and `RefreshableStaggeredGridView` (refreshable)
typedef GetNonPageDataFunction<T> = Future<List<T>> Function();

/// data model for `AppendableSeriesListView` and `AppendableSeriesStaggeredGridView`
class SeriesData<T, U> {
  List<T> data;
  U maxId;

  SeriesData({@required this.data, @required this.maxId});
}

/// get series data function, used in `AppendableListView` (appendable)
typedef GetSeriesDataFunction<T, U> = Future<SeriesData<T, U>> Function({U maxId});
