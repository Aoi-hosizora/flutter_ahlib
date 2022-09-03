# flutter_ahlib

[![Build Status](https://travis-ci.com/Aoi-hosizora/flutter_ahlib.svg?branch=master)](https://travis-ci.com/Aoi-hosizora/flutter_ahlib)
[![Release](https://img.shields.io/github/v/release/Aoi-hosizora/flutter_ahlib)](https://github.com/Aoi-hosizora/flutter_ahlib/releases)
[![pub package](https://img.shields.io/pub/v/flutter_ahlib.svg)](https://pub.dev/packages/flutter_ahlib)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](./LICENSE)

+ A personal flutter library, contains some useful widgets and utils.
+ Please visit https://pub.dev/packages/flutter_ahlib for this package.

### Usage

```dart
// Import package as required
import 'package:flutter_ahlib/widget.dart'; // for common widgets
import 'package:flutter_ahlib/list.dart'; // for list widgets
import 'package:flutter_ahlib/image.dart'; // for image widgets
import 'package:flutter_ahlib/util.dart'; // for utils

// Import all packages directly
import 'package:flutter_ahlib/flutter_ahlib.dart'; // the whole library
```

### Library contents

+ widget.dart:
    + `AnimatedFab` `ScrollAnimatedFab` `AnimatedFabController`
    + `CustomInkRipple` `CustomInkSplash`
    + `CustomInkWell` `CustomInkResponse`
    + `DrawerListView`
    + `IconText`
    + `LazyIndexedStack`
    + `flatButtonStyle` `raisedButtonStyle` `outlineButtonStyle`
    + `PlaceholderText`
    + `showPopupListMenu`
    + `ScrollbarWithMore`
    + `SliverHeaderDelegate` `SliverSeparatedListDelegate` `SliverSeparatedListBuilderDelegate`
    + `TabInPageNotification`
    + `TableCellHelper` `getTableRowRect`
    + `TextGroup`
    + `TextSelectionConfig` `TextSelectionWithColorHandle`
    + `StatelessWidgetWithCallback` `StatefulWidgetWithCallback`
+ list.dart:
    + `AppendIndicator` `AppendIndicatorState`
    + `RefreshableDataView` `RefreshableListView` `RefreshableSliverListView` `RefreshableMasonryGridView`
    + `PaginationDataView` `PaginationListView` `PaginationSliverListView` `PaginationMasonryGridView`
    + `UpdatableDataView` `UpdatableDataViewController`
+ image.dart:
    + `LocalOrCachedNetworkImageProvider`
    + `MultiImageStreamCompleter`
    + `PreloadablePageView`
    + `ReloadablePhotoViewGallery` `ReloadablePhotoViewGalleryState`
+ util.dart:
    + `ActionController`
    + `BoolExtension` `ListExtension`
    + `filesize`
    + `StateExtension` `ScrollControllerExtension` `PageControllerExtension` `ScrollMetricsExtension`
    + `hash2` ~ `hash6` `hashObjects`
    + `Tuple2` ~ `Tuple6`

### Dependencies

+ Visit [pubspec.yaml](./pubspec.yaml) for details.

```yaml
environment:
  sdk: ">=2.16.2 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_cache_manager: ^3.3.0
  flutter_staggered_grid_view: ^0.6.1
  http: ^0.13.4
  photo_view: ^0.14.0
```
