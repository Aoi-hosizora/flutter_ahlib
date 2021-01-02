import 'package:flutter/material.dart';

/// An enum type that represents the kind of abstract [DrawerItem].
enum _DrawerItemType {
  /// Type for [DrawerPage].
  page,

  /// Type for [DrawerAction].
  action,

  /// Type for [DrawerWidget].
  widget,
}

/// Abstract drawer item used in [DrawerListView], inherited by [DrawerPageItem], [DrawerActionItem] and [DrawerWidgetItem].
abstract class DrawerItem {
  const DrawerItem({this.type});

  /// The derived class type.
  final _DrawerItemType type;
}

/// A [DrawerItem] which is used to navigate to a page, where [T] can be an enum type for pages, will be wrapped by [ListTile].
class DrawerPageItem<T> extends DrawerItem {
  const DrawerPageItem({
    @required this.title,
    this.leading,
    this.trailing,
    @required this.page,
    this.selection,
    this.backgroundColor = Colors.transparent,
    this.highlightColor = const Color(0xFFE0E0E0),
    this.autoCloseWhenTapped = true,
    this.autoCloseWhenAlreadySelected = false,
  })  : assert(title != null),
        assert(page != null),
        assert(backgroundColor != null),
        assert(highlightColor != null),
        assert(autoCloseWhenTapped != null),
        assert(autoCloseWhenAlreadySelected != null),
        super(type: _DrawerItemType.page);

  /// A simple constructor to create a default [DrawerPageItem].
  DrawerPageItem.simple(String title, IconData icon, Widget page, T selection)
      : this(
          title: Text(title),
          leading: Icon(icon),
          page: page,
          selection: selection,
        );

  /// Title widget for [ListTile].
  final Widget title;

  /// Leading widget for [ListTile].
  final Widget leading;

  /// Trailing widget for [ListTile].
  final Widget trailing;

  /// Navigator destination page.
  final Widget page;

  /// Current page selection value, with [T] type.
  final T selection;

  /// Background color for this item.
  final Color backgroundColor;

  /// Highlight color for current selected item.
  final Color highlightColor;

  /// Auto close the drawer when page is shown.
  final bool autoCloseWhenTapped;

  /// Auto close the drawer when current item is already selected.
  final bool autoCloseWhenAlreadySelected;
}

/// A [DrawerItem] which is used to invoke an action, will be wrapped by [ListTile].
class DrawerActionItem extends DrawerItem {
  const DrawerActionItem({
    @required this.title,
    this.leading,
    this.trailing,
    @required this.action,
    this.longPressAction,
    this.backgroundColor = Colors.transparent,
    this.autoCloseWhenTapped = true,
    this.autoCloseWhenLongPressed = false,
  })  : assert(title != null),
        assert(action != null),
        assert(backgroundColor != null),
        assert(autoCloseWhenTapped != null),
        assert(autoCloseWhenLongPressed != null),
        super(type: _DrawerItemType.action);

  /// A simple constructor to create a default [DrawerActionItem].
  DrawerActionItem.simple(String title, IconData icon, Function action)
      : this(
          title: Text(title),
          leading: Icon(icon),
          action: action,
        );

  /// Title widget for [ListTile].
  final Widget title;

  /// Leading widget for [ListTile].
  final Widget leading;

  /// Trailing widget for [ListTile].
  final Widget trailing;

  /// Tap action for [ListTile].
  final Function action;

  /// LongPressed action for [ListTile].
  final Function longPressAction;

  /// Background color for this item.
  final Color backgroundColor;

  /// Auto close the drawer when item is tapped.
  final bool autoCloseWhenTapped;

  /// Auto close the drawer when item is long pressed.
  final bool autoCloseWhenLongPressed;
}

/// A [DrawerItem] which is used to show a widget.
class DrawerWidgetItem extends DrawerItem {
  const DrawerWidgetItem({
    @required this.child,
  })  : assert(child != null),
        super(type: _DrawerItemType.widget);

  /// A simple constructor to create a default [DrawerWidgetItem].
  DrawerWidgetItem.simple(Widget child) : this(child: child);

  /// A custom child.
  final Widget child;
}

/// A wrapped [Column] with a list of [DrawerItem], which can be used in [ListView] with [Drawer].
/// Example:
/// ```
/// Drawer(
///   child: ListView(
///     padding: EdgeInsets.all(0.0),
///     children: [
///       DrawerHeader( ... ),
///       DrawerListView<DrawerSelection>(
///         items: [ ... ],
///         currentSelection: ...,
///         onGoto: (t, v) {
///           if (t == xxx) {
///             Navigator.of(context).popUntil((route) => route.settings.name == 'xxx');
///           } else {
///             Navigator.of(context).push(MaterialPageRoute(builder: (c) => v));
///           }
///         },
///       ),
///     ],
///   ),
/// );
/// ```
class DrawerListView<T> extends StatefulWidget {
  const DrawerListView({
    Key key,
    @required this.items,
    @required this.onGoto,
    this.currentSelection,
    this.enableHighlight = true,
  })  : assert(items != null && items.length > 0),
        assert(onGoto != null),
        assert(enableHighlight != null),
        super(key: key);

  /// A list of [DrawerItem] to show..
  final List<DrawerItem> items;

  /// Goto callback for [DrawerPageItem].
  final Function(T, Widget) onGoto;

  /// Current selected item for [DrawerPageItem].
  final T currentSelection;

  /// Need to highlight the item when selected, for [DrawerPageItem].
  final bool enableHighlight;

  @override
  _DrawerListViewState<T> createState() => _DrawerListViewState<T>();
}

class _DrawerListViewState<T> extends State<DrawerListView<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map(
        (item) {
          switch (item.type) {
            case _DrawerItemType.page:
              DrawerPageItem<T> page = item;
              return Container(
                color: widget.enableHighlight && widget.currentSelection == page.selection ? page.highlightColor : page.backgroundColor,
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: page.title,
                    leading: page.leading,
                    trailing: page.trailing,
                    selected: widget.enableHighlight && widget.currentSelection == page.selection,
                    onTap: () {
                      if (page.selection != widget.currentSelection) {
                        if (page.autoCloseWhenTapped) {
                          Navigator.pop(context);
                        }
                        widget.onGoto?.call(page.selection, page.page);
                      } else if (page.autoCloseWhenAlreadySelected) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              );
            case _DrawerItemType.action:
              DrawerActionItem action = item;
              return Container(
                color: action.backgroundColor,
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: action.title,
                    leading: action.leading,
                    trailing: action.trailing,
                    onTap: action.action == null
                        ? null
                        : () {
                            if (action.autoCloseWhenTapped) {
                              Navigator.pop(context);
                            }
                            action.action();
                          },
                    onLongPress: action.longPressAction == null
                        ? null
                        : () {
                            if (action.autoCloseWhenLongPressed) {
                              Navigator.pop(context);
                            }
                            action.longPressAction?.call();
                          },
                  ),
                ),
              );
            case _DrawerItemType.widget:
              DrawerWidgetItem widget = item;
              return widget.child;
            default:
              return Container();
          }
        },
      ).toList(),
    );
  }
}
