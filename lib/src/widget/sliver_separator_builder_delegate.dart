import 'package:flutter/material.dart';

/// This is a custom [SliverChildBuilderDelegate] with separator,
/// notice that this class has not a const constructor.
class SliverSeparatorBuilderDelegate extends SliverChildBuilderDelegate {
  SliverSeparatorBuilderDelegate(
    NullableIndexedWidgetBuilder builder, {
    @required Widget separator,
    ChildIndexGetter findChildIndexCallback,
    int childCount,
  })  : assert(builder != null),
        assert(separator != null),
        super(
          (c, idx) => idx % 2 != 0 ? separator : builder.call(c, idx ~/ 2),
          findChildIndexCallback: findChildIndexCallback,
          childCount: childCount * 2 - 1,
        );
}
