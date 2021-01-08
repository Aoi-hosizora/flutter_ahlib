# flutter_ahlib

[![Build Status](https://travis-ci.com/Aoi-hosizora/flutter_ahlib.svg?branch=master)](https://travis-ci.com/Aoi-hosizora/flutter_ahlib)
[![pub package](https://img.shields.io/pub/v/flutter_ahlib.svg)](https://pub.dev/packages/flutter_ahlib)
[![Release](https://img.shields.io/github/v/release/Aoi-hosizora/flutter_ahlib)](https://github.com/Aoi-hosizora/flutter_ahlib/releases)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](./LICENSE)

+ AoiHosizora's personal library used in flutter, contains some useful widgets and utils.
+ See package in https://pub.dev/packages/flutter_ahlib.

### Usage

```dart
import 'package:flutter_ahlib/widget.dart'; // for widgets
import 'package:flutter_ahlib/list.dart'; // for list widgets
import 'package:flutter_ahlib/util.dart'; // for some utils
import 'package:flutter_ahlib/image.dart'; // for image related

// Or import all packages directly.
import 'package:flutter_ahlib/flutter_ahlib.dart'; // the whole library
```

### Dependencies

+ See [pubspec.yaml](./pubspec.yaml)

```yaml
flutter_staggered_grid_view: ^0.3.2
flutter_cache_manager: ">=2.0.0 <3.0.0" # 2.0.0
http: ^0.12.2
```

### Functions

+ Widget:
    + `PlaceholderText`
    + `DrawerListView`
    + `IconText`
    + `showPopupListMenu`
    + `AnimatedFab` `ScrollAnimatedFab` `AnimatedFabController`
    + `LazyIndexedStack`
    + `SliverAppBarDelegate` `SliverAppBarSizedDelegate` `SliverSeparatedBuilderDelegate` `SliverSeparatedListDelegate`
    + `TextGroup`
    + `TabInPageNotification`
    + `FunctionPainter` `BannedIcon`
+ List:
  + `AppendIndicator`
  + `UpdatableDataView` `UpdatableDataViewController`
  + `RefreshableDataView` `RefreshableListView` `RefreshableSliverListView` `RefreshableStaggeredGridView`
  + `PaginationDataView` `PaginationListView` `PaginationSliverListView` `PaginationStaggeredGridView`
+ Image:
    + `LocalOrNetworkImageProvider`
    + `MultiImageStreamCompleter`
+ Util:
    + `ActionController`
    + `Tuple2` ~ `Tuple6`
    + `hashObjects()`, `hash2()` ~ `hash6()`
    + `BoolExtension` `ListExtension`
    + `StateExtension` `ScrollControllerExtension` `PageControllerExtension` `ScrollMetricsExtension`
    + `filesize`
    + `NotifiableData`
