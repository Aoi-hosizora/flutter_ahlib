import 'package:flutter/material.dart';

/// The pagination strategy used in [PaginationListView].
enum PaginationStrategy {
  /// Use `page` and  `limit` as parameter to query list data.
  offsetBased,

  /// Use `maxId` and `limit` as parameter to query list data.
  seekBased,
}

/// Data model for seekBased pagination strategy.
class SeekList<T> {
  SeekList({
    @required this.list,
    @required this.nextMaxId,
  });

  List<T> list;
  dynamic nextMaxId;
}
