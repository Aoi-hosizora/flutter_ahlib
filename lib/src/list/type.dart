import 'package:flutter/material.dart';

/// Append callback function, used in [AppendIndicator].
typedef AppendCallback = Future<void> Function();

/// data model for `AppendableSeriesListView` and `AppendableSeriesStaggeredGridView`
class SeriesData<T, U> {
  List<T> data;
  U maxId;

  SeriesData({@required this.data, @required this.maxId});
}

/// get non-page data function, used in `RefreshableListView` and `RefreshableStaggeredGridView` (refreshable)
typedef GetNonPageDataFunction<T> = Future<List<T>> Function();

/// get page data function, used in `AppendableListView` (appendable)
typedef GetPageDataFunction<T> = Future<List<T>> Function({int page});

/// get series data function, used in `AppendableListView` (appendable)
typedef GetSeriesDataFunction<T, U> = Future<SeriesData<T, U>> Function({U maxId});
