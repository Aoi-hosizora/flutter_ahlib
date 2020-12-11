# flutter_ahlib

[![Build Status](https://travis-ci.org/Aoi-hosizora/flutter_ahlib.svg?branch=master)](https://travis-ci.org/Aoi-hosizora/flutter_ahlib)
[![pub package](https://img.shields.io/pub/v/flutter_ahlib.svg)](https://pub.dev/packages/flutter_ahlib)
[![Release](https://img.shields.io/github/v/release/Aoi-hosizora/flutter_ahlib)](https://github.com/Aoi-hosizora/flutter_ahlib/releases)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](./LICENSE)

+ AoiHosizora's personal library used in flutter, contains some useful widgets and utils.
+ See package in https://pub.dev/packages/flutter_ahlib.

### Usage

```dart
import 'package:flutter_ahlib/flutter_ahlib.dart';
```

### Dependencies

+ See [pubspec.yaml](./pubspec.yaml)

```yaml
flutter_staggered_grid_view: ^0.3.2
flutter_cache_manager: ">=2.0.0 <3.0.0" # 2.0.0
http: ^0.12.2
filesize: ^1.0.4
```

### Functions

+ Widget:
    + `PlaceholderText`
    + `DrawerListView`
    + `IconText`
    + `showIconPopupMenu()`
    + `showTextPopupMenu()`
    + `ScrollFloatingActionButton`
    + `ScrollFabController`
    + `RippleSizedView` (deprecated)
    + `SliverContainer`
    + `DummyView`
    + `LazyIndexedStack`
    + `SliverAppBarDelegate`
    + `SliverSeparatorBuilderDelegate`
+ Image:
    + `LocalOrNetworkImageProvider`
    + `ImageLoadingView` (deprecated)
    + `ImageLoadFailedView` (deprecated)
    + `MultiImageStreamCompleter`
+ Util:
    + `ActionController`
    + `Tuple2` ~ `Tuple6`
    + `hashObjects()`, `hash2()` ~ `hash6()`
    + `StateExtension`
    + `ObjectExtension`
    + `BoolExtension`
+ List:
    + `AppendIndicator`
    + `ScrollMoreController` (deprecated)
    + `ScrollControllerExtension`
    + `UpdatableListController`
    + `RefreshableListView`
    + `RefreshableSliverListView`
    + `RefreshableStaggeredGridView`
    + `PaginationListView`
    + `PaginationSliverListView`
    + `PaginationStaggeredGridView`
