## [1.3.0] - Refactor and improve the whole library

> This upgrading contains lots of large changes, visit https://github.com/Aoi-hosizora/flutter_ahlib/pull/14 for details.

1. This is a break update, which begins to support null-safety dart. (Sorry for merging these updates and changes so late :P)
2. Currently, this package is separated into four parts - `Common widgets`, `List widgets`, `Image widgets`, `Utilities`, each part contains some useful widgets or utilities.
3. New common widgets since v1.2.0: `AppBarActionButton` `CustomDrawerController` `CustomInkRipple` `CustomInkSplash` `CustomInkWell` `CustomInkResponse` `CustomPageRoute` `CustomPageRouteTheme`
   `CustomScrollPhysics` `DefaultCustomScrollPhysics` `CustomSingleChildLayoutDelegate` `DrawerScaffold` `ExtendedDropdownButton` `ExtendedNestedScrollView` `ExtendedScrollbar`
   `ExtendedTabBarView` `OverflowClipBox` `PreviouslySwitchedWidget` `PreloadablePageView` `PageChangedListener` `TableWholeRowInkWell` `TextSelectionWithColorHandle` `VideoProgressIndicator` 
   `StatelessWidgetWithCallback` `StatefulWidgetWithCallback` etc...
4. New list widgets since v1.2.0: `MultiSelectable` `SelectableItem` `SelectableCheckboxItem` `PaginationGridView` `PaginationSliverGridView` `RefreshableGridView` `RefreshableSliverGridView`
5. New image widgets and image utilities since v1.2.0: `ExtendedPhotoGallery` `loadLocalOrNetworkImageBytes` `loadLocalOrNetworkImageCodec` `LocalOrCachedNetworkImage` `ReloadablePhotoView`
6. New utilities since v1.2.0: `downloadFile` `ExtendedLogger` `PreferredPrinter` `Flutter material constants` `Flutter extensions` `getMimeFromExtension` `getExtensionsFromMime` `TaskResult`
7. Deleted or renamed components since v1.2.0: `DrawerListView -> x` `showPopupListMenu -> XXXDialogOption` `SliverAppBarDelegate / SliverAppBarSizedDelegate -> SliverHeaderDelegate` 
   `TabInPageNotification -> NestedPageViewNotifier` `FileOrNetworkImageProvider -> LocalOrCachedNetworkImageProvider` `NotifiableData` etc...

## [1.2.0] - Refactor the whole library and add some widgets

1. This is a break update, see https://github.com/Aoi-hosizora/flutter_ahlib/pull/13

## [1.1.3+1] - Fix list widgets and add some examples

## [1.1.3] - Add more settings for widgets

1. Update `IconText` and `PlaceholderText` parameters.
2. Fix `LocalOrNetworkImageProvider` header.
3. Update list widgets.
4. Add `image` packages and upgrade dependencies.

## [1.1.2] - Update some bugs in PlaceholderText and PaginationXXX

1. Fix `PlaceholderText` some bugs.
2. Update `PaginationXXX` `initialPage` conditions.

## [1.1.1] - Refactor the whole library

+ Add some comments to api, update some filenames.
+ Merge `common` and `item` packages to `widget`.
+ Add `common` package with `action_controller.dart`, `hash.dart` and `tuple.dart`.
+ Update `list` package, merge `PaginationXXX` and `SeriableXXX` by using `PaginationStrategy`.
+ Add new `hash.dart` and `tuple.dart` from `google/quiver-dart` and `google/tuple.dart`.
+ Rewrite tests for `common` package using `group()` and `test()`.

## [1.0.12] - Add LocalOrNetworkImageProvider

+ Update file structure
+ Add `LocalOrNetworkImageProvider`

## [1.0.11] - Update list package

+ Update some name: `PaginationListView` `SeriationListView` `PaginationStaggeredGridView` `SeriationStaggeredGridView`
+ Add sliver: `RefreshableSliverListView` `PaginationSliverListView` `SeriationSliverListView`

## [1.0.9] - Update structure

+ Move all source file to `lib/src/` and export it on `lib/flutter_ahlib.dart`
+ Extract `lib/src/list/` package types to `lib/src/list/type.dart`
+ Rename `PlaceHolder` to `Placeholder`
+ Split `lib/src/list` to `lib/src/fab`
+ Add some document comments

## [1.0.8] - Add DrawerListView

+ Add `DrawerListView<T>` and some types
+ Rename `PopupMenuItem` to `PopupActionItem`
+ Update `RippleSizedView` actions

## [1.0.5] - Update ListPlaceholderText

+ Add `ListPlaceholderSetting` to list widgets

## [1.0.3] - Fix ScrollMoreController

+ Fix `ScrollMoreController`.`scrollWithAnimate`

## [1.0.2] - Add widgets from mmnj

+ Add `RefreshableStaggeredGridView`, `IconText`, `RippleSizedView`, `SliverContainer` widgets
+ Add `ActionController` controller
+ Add `showPopupMenu()` function

## [1.0.1] - Initial flutter_ahlib

+ Initial `flutter_ahlib`
+ Add `AppendIndicator`, `ListPlaceholderText`, `AppendableListView`, `RefreshableListView`, `ScrollFloatingActionButton` widgets
+ Add `ScrollMoreController`, `ScrollFabController` controllers
