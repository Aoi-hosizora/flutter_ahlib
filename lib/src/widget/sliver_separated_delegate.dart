import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/dart_extensions.dart';

/// This is a custom [SliverChildBuilderDelegate] with separator,
/// notice that this class has not a const constructor.
class SliverSeparatedBuilderDelegate extends SliverChildBuilderDelegate {
  SliverSeparatedBuilderDelegate(
    NullableIndexedWidgetBuilder builder, {
    @required Widget separator,
    int childCount,
  })  : assert(builder != null),
        assert(separator != null),
        super(
          (c, idx) => idx % 2 != 0 ? separator : builder.call(c, idx ~/ 2),
          childCount: childCount * 2 - 1,
        );
}

/// This is a custom [SliverChildListDelegate] with separator,
/// notice that this class has not a const constructor.
class SliverSeparatedListDelegate extends SliverChildListDelegate {
  SliverSeparatedListDelegate(
    List<Widget> children, {
    @required Widget separator,
  })  : assert(children != null),
        assert(separator != null),
        super(
          children.separate(separator),
        );
}
