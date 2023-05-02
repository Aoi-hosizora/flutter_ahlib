# flutter_ahlib

[![Build Status](https://app.travis-ci.com/Aoi-hosizora/flutter_ahlib.svg?branch=master)](https://app.travis-ci.com/github/Aoi-hosizora/flutter_ahlib)
[![Release](https://img.shields.io/github/v/release/Aoi-hosizora/flutter_ahlib)](https://github.com/Aoi-hosizora/flutter_ahlib/releases)
[![pub package](https://img.shields.io/pub/v/flutter_ahlib.svg)](https://pub.dev/packages/flutter_ahlib)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](./LICENSE)

+ A personal flutter library, contains some useful widgets and utilities.
+ Please visit https://pub.dev/packages/flutter_ahlib for details. Note that this library only passes tests in Flutter 2.x.

### Usage

```dart
// Import the whole library, including common widgets, list widgets, image widgets and utilities.
import 'package:flutter_ahlib/flutter_ahlib.dart';

// Only import the util library.
import 'package:flutter_ahlib/flutter_ahlib_util.dart'; 
```

### Library contents

+ Common widgets ([lib/src/widget/](./lib/src/widget))
    + `AnimatedFab` `ScrollAnimatedFab` `AnimatedFabController`
    + `AppBarActionButtonTheme` `AppBarActionButton`
    + `CustomDrawerController` `CustomDrawerControllerState`
    + `CustomInkRipple` `CustomInkSplash`
    + `CustomInkWell` `CustomInkResponse`
    + `CustomPageRoute` `CustomPageRouteTheme` `NoPopGestureCupertinoPageTransitionsBuilder`
    + `CustomScrollPhysics` `CustomScrollPhysicsController` `DefaultCustomScrollPhysics`
    + `CustomSingleChildLayoutDelegate`
    + `DrawerScaffold` `DrawerScaffoldState`
    + `ExtendedDropdownButton` `ExtendedDropdownButtonState` `ViewInsetsData`
    + `ExtendedNestedScrollView` `ExtendedNestedScrollViewState`
    + `ExtendedScrollbar`
    + `ExtendedTabBarView` `ExtendedTabBarViewState`
    + `IconText`
    + `LazyIndexedStack` `PositionArgument`
    + `NestedPageViewNotifier`
    + `flatButtonStyle` `raisedButtonStyle` `outlineButtonStyle` `ThemeDataExtension`
    + `OverflowClipBox`
    + `PlaceholderText` `PreviouslySwitchedWidget` `switchLayoutBuilderWithSwitchedFlag`
    + `TextDialogOption` `IconTextDialogOption` `CircularProgressDialogOption` `showYesNoAlertDialog`
    + `PreloadablePageView` `PageChangedListener`
    + `SliverHeaderDelegate` `SliverSeparatedListDelegate` `SliverSeparatedListBuilderDelegate`
    + `TableWholeRowInkWell` `TableCellHelper`
    + `TextGroup`
    + `TextSelectionConfig` `TextSelectionWithColorHandle`
    + `VideoProgressIndicator`
    + `StatelessWidgetWithCallback` `StatefulWidgetWithCallback`
+ List widgets ([lib/src/list/](./lib/src/list))
    + `AppendIndicator` `AppendIndicatorState`
    + `MultiSelectable` `MultiSelectableController` `SelectableItem` `SelectableCheckboxItem`
    + `RefreshableDataView` `RefreshableDataViewState`
    + `PaginationDataView` `PaginationDataViewState`
    + `UpdatableDataView`
+ Image widgets ([lib/src/image/](./lib/src/image))
    + `ExtendedPhotoGallery` `ExtendedPhotoGalleryState`
    + `loadLocalOrNetworkImageBytes` `loadLocalOrNetworkImageCodec`
    + `LocalOrCachedNetworkImage`
    + `LocalOrCachedNetworkImageProvider`
    + `MultiImageStreamCompleter`
    + `ReloadablePhotoView` `ReloadablePhotoViewState`
+ Utilities ([lib/src/util/](./lib/src/util))
    + `ActionController`
    + `BoolExtension` `IterableExtension` `ListExtension` `ObjectExtension` `FutureExtension`
    + `downloadFile`
    + `ExtendedLogger` `PreferredPrinter`
    + `filesize` `filesizeWithoutSpace`
    + `Flutter material constants`
    + `StateExtension` `ScrollControllerExtension` `ScrollMetricsExtension` `PageControllerExtension` `ColorExtension` `TextSpanExtension` `RenderObjectExtension` `BuildContextExtension`
    + `getMimeFromExtension` `getExtensionsFromMime` `getPreferredExtensionFromMime`
    + `TaskResult` `Ok` `Err` `TaskResultFutureExtension`
    + `Tuple2` ~ `Tuple6`

### Dependencies

+ Visit [pubspec.yaml](./pubspec.yaml) for details.

```yaml
environment:
  sdk: ">=2.16.2 <3.0.0"

dependencies:
  flutter_cache_manager: ^3.3.0
  flutter_staggered_grid_view: ^0.6.2
  http: ^0.13.5
  logger: ^1.2.2
  octo_image: ^1.0.2
  path: ^1.8.0
  photo_view: ^0.14.0

dev_dependencies:
  flutter_lints: ^1.0.0
```
