# flutter_ahlib

[![Build Status](https://travis-ci.com/Aoi-hosizora/flutter_ahlib.svg?branch=master)](https://travis-ci.com/Aoi-hosizora/flutter_ahlib)
[![Release](https://img.shields.io/github/v/release/Aoi-hosizora/flutter_ahlib)](https://github.com/Aoi-hosizora/flutter_ahlib/releases)
[![pub package](https://img.shields.io/pub/v/flutter_ahlib.svg)](https://pub.dev/packages/flutter_ahlib)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](./LICENSE)

+ A personal flutter library, contains some useful widgets and utils.
+ Please visit https://pub.dev/packages/flutter_ahlib for this library.

### Usage

```dart
// Import the whole library, including common widgets, list widgets, image widgets and utils.
import 'package:flutter_ahlib/flutter_ahlib.dart';

// Only import the util library.
import 'package:flutter_ahlib/flutter_ahlib_util.dart'; 
```

### Library contents

+ Common widgets ([lib/src/widget/](./lib/src/widget))
    + `AnimatedFab` `ScrollAnimatedFab` `AnimatedFabController`
    + `AppBarActionButtonTheme` `AppBarActionButton`
    + `CustomInkRipple` `CustomInkSplash`
    + `CustomInkWell` `CustomInkResponse`
    + `CustomPageRoute` `CustomPageRouteTheme` `NoPopGestureCupertinoPageTransitionsBuilder`
    + `CustomSingleChildLayoutDelegate`
    + `ExtendedNestedScrollView`
    + `ExtendedScrollbar`
    + `IconText`
    + `LazyIndexedStack`
    + `flatButtonStyle` `raisedButtonStyle` `outlineButtonStyle`
    + `PlaceholderText`
    + `TextDialogOption` `IconTextDialogOption` `CircularProgressDialogOption`
    + `PreloadablePageView`
    + `SliverHeaderDelegate` `SliverSeparatedListDelegate` `SliverSeparatedListBuilderDelegate`
    + `TabInPageNotification`
    + `TableWholeRowInkWell` `TableCellHelper`
    + `TextGroup`
    + `TextSelectionConfig` `TextSelectionWithColorHandle`
    + `VideoProgressIndicator`
    + `StatelessWidgetWithCallback` `StatefulWidgetWithCallback`
+ List widgets ([lib/src/list/](./lib/src/list))
    + `AppendIndicator` `AppendIndicatorState`
    + `RefreshableDataView` `RefreshableDataViewState`
    + `PaginationDataView` `PaginationDataViewState`
    + `UpdatableDataView`
+ Image widgets ([lib/src/image/](./lib/src/image))
    + `ExtendedPhotoGallery` `ExtendedPhotoGalleryState`
    + `LocalOrCachedNetworkImageProvider`
    + `MultiImageStreamCompleter`
    + `ReloadablePhotoView` `ReloadablePhotoViewState`
+ Utils ([lib/src/util/](./lib/src/util))
    + `ActionController`
    + `BoolExtension` `IterableExtension` `LetExtension`
    + `filesize`
    + `flutter material constants ...`
    + `StateExtension` `ScrollControllerExtension` `ScrollMetricsExtension` `PageControllerExtension` `RenderObjectExtension`
    + `hash2` ~ `hash6` `hashObjects`
    + `getMimeFromExtension` `getExtensionsFromMime` `getPreferredExtensionFromMime`
    + `Tuple2` ~ `Tuple6`

### Dependencies

+ Visit [pubspec.yaml](./pubspec.yaml) for details.

```yaml
environment:
  sdk: ">=2.16.2 <3.0.0"

dependencies:
  flutter_cache_manager: ^3.3.0
  flutter_staggered_grid_view: ^0.6.1
  http: ^0.13.4
  photo_view: ^0.14.0

dev_dependencies:
  flutter_lints: ^1.0.0
```
