import 'package:flutter/material.dart';

/// An enum type to represent the kind of the abstract [DrawerItem].
enum _DrawerItemType {
  /// Represents [DrawerPageItem] type.
  page,

  /// Represents [DrawerActionItem] type.
  action,

  /// Represents [DrawerWidgetItem] type.
  widget,
}

// ==========
// DrawerItem
// ==========

/// An abstract drawer item used in [DrawerListView], implemented by [DrawerPageItem], [DrawerActionItem] and [DrawerWidgetItem].
/// This is not a [Widget], but just a data class to store options and used in [DrawerListView].
abstract class DrawerItem {
  const DrawerItem({this.type});

  /// The derived class type in [_DrawerItemType] type.
  final _DrawerItemType type;
}

/// A [DrawerItem] which is used to navigate to a page, where [T] can be an enum type of page, this will be wrapped by [ListTile].
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

  /// Creates a [DrawerPageItem] in a simple way.
  DrawerPageItem.simple(String title, IconData icon, Widget page, T selection)
      : this(
          title: Text(title),
          leading: Icon(icon),
          page: page,
          selection: selection,
        );

  /// The title widget of this item.
  final Widget title;

  /// The leading widget of this item.
  final Widget leading;

  /// The trailing widget of this item.
  final Widget trailing;

  /// The navigator destination page.
  final Widget page;

  /// The current page selection value, with [T] type.
  final T selection;

  /// The background color of this item.
  final Color backgroundColor;

  /// The highlight color of this item if selected.
  final Color highlightColor;

  /// The switcher to auto close the drawer when this item is tapped and the page is shown.
  final bool autoCloseWhenTapped;

  /// The switcher to auto close the drawer when this item is already selected.
  final bool autoCloseWhenAlreadySelected;
}

/// A [DrawerItem] which is used to invoke an action, this will be wrapped by [ListTile].
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

  /// Creates a [DrawerActionItem] in a simple way.
  DrawerActionItem.simple(String title, IconData icon, Function action)
      : this(
          title: Text(title),
          leading: Icon(icon),
          action: action,
        );

  /// The title widget of this item.
  final Widget title;

  /// The leading widget of this item.
  final Widget leading;

  /// The trailing widget of this item.
  final Widget trailing;

  /// The tap action of this item.
  final Function action;

  /// The long pressed action of this item.
  final Function longPressAction;

  /// The background color of this item.
  final Color backgroundColor;

  /// The switcher to auto close the drawer when this item is tapped.
  final bool autoCloseWhenTapped;

  /// The switcher to auto close the drawer when this item is long pressed.
  final bool autoCloseWhenLongPressed;
}

/// A [DrawerItem] which is used to show a widget.
class DrawerWidgetItem extends DrawerItem {
  const DrawerWidgetItem({
    @required this.child,
  })  : assert(child != null),
        super(type: _DrawerItemType.widget);

  /// Creates a [DrawerWidgetItem] in a simple way.
  DrawerWidgetItem.simple(Widget child) : this(child: child);

  /// The widget of this item.
  final Widget child;
}

// ==============
// DrawerListView
// ==============

/// A wrapped [Column] with a list of [DrawerItem], which can be used in [Drawer] and [ListView].
///
/// Example:
/// ```
/// enum DrawerSelection {...}
///
/// Drawer(
///   child: ListView(
///     padding: EdgeInsets.all(0),
///     children: [
///       DrawerHeader(...),
///       DrawerListView<DrawerSelection>(
///         items: [...],
///         currentSelection: ...,
///         onNavigatorTo: (t, v) {
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
    @required this.onNavigatorTo,
    this.currentSelection,
    this.enableHighlight = true,
  })  : assert(items != null),
        assert(onNavigatorTo != null),
        assert(enableHighlight != null),
        super(key: key);

  /// The list of [DrawerItem] to show.
  final List<DrawerItem> items;

  /// The navigateTo function used for [DrawerPageItem].
  final Function(T, Widget) onNavigatorTo;

  /// The current selected item used for [DrawerPageItem].
  final T currentSelection;

  /// The switcher to highlight the selected item used for [DrawerPageItem], defaults to true.
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
            ////////////////////////////////////////////////////////////////
            // page
            ////////////////////////////////////////////////////////////////
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
                        widget.onNavigatorTo?.call(page.selection, page.page);
                      } else if (page.autoCloseWhenAlreadySelected) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              );
            ////////////////////////////////////////////////////////////////
            // action
            ////////////////////////////////////////////////////////////////
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
            ////////////////////////////////////////////////////////////////
            // widget
            ////////////////////////////////////////////////////////////////
            case _DrawerItemType.widget:
              DrawerWidgetItem widget = item;
              return widget.child;
            ////////////////////////////////////////////////////////////////
            // unreachable
            ////////////////////////////////////////////////////////////////
            default:
              return Container(); // dummy
          }
        },
      ).toList(),
    );
  }
}
