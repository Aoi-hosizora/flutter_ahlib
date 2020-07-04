import 'package:flutter_ahlib/src/list/placeholder_text.dart';

/// Append callback funtion, used in `AppendIndicator`
typedef AppendCallback = Future<void> Function();

/// Placeholder state changed callback function, used in `ListPlaceholderText`
typedef StateChangedCallback = void Function(PlaceholderState);

/// get page data function, used in `AppendableListView` (appendable)
typedef GetPageDataFunction<T> = Future<List<T>> Function({int page});

/// get non-page data function, used in `RefreshableListView` and `RefreshableStaggeredGridView` (refreshable)
typedef GetNonPageDataFunction<T> = Future<List<T>> Function();
