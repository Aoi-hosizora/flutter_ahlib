import 'package:flutter_ahlib/src/list/appendable_series_listview.dart';
import 'package:flutter_ahlib/src/list/placeholder_text.dart';

/// Append callback funtion, used in `AppendIndicator`
typedef AppendCallback = Future<void> Function();

/// Placeholder state changed callback function, used in `PlaceholderText`
typedef PlaceholderStateChangedCallback = void Function(PlaceholderState);

/// get page data function, used in `AppendableListView` (appendable)
typedef GetPageDataFunction<T> = Future<List<T>> Function({int page});

/// get non-page data function, used in `RefreshableListView` and `RefreshableStaggeredGridView` (refreshable)
typedef GetNonPageDataFunction<T> = Future<List<T>> Function();

/// get series data function, used in `AppendableListView` (appendable)
typedef GetSeriesDataFunction<T, U> = Future<PageData<T, U>> Function({U maxId});
