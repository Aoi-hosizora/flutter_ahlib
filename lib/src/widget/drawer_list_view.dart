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

/// The default background color of [DrawerPageItem].
const _kDefaultBackgroundColor = Colors.transparent;

/// The default scroll offset of [DrawerPageItem] and [DrawerActionItem].
const _kDefaultHighlightColor = Color(0xFFE0E0E0);

// ==========
// DrawerItem
// ==========

/// An abstract drawer item used in [DrawerListView], implemented by [DrawerPageItem], [DrawerActionItem] and [DrawerWidgetItem].
/// This is not a [Widget], but just a data class to store options and used in [DrawerListView].
abstract class DrawerItem {
  const DrawerItem({required this.type});

  /// The derived class type in [_DrawerItemType] type.
  final _DrawerItemType type;
}

/// A [DrawerItem] which is used to navigate to a page, where [T] can be an enum type of page, this will be wrapped by [ListTile].
class DrawerPageItem<T> extends DrawerItem {
  const DrawerPageItem({
    required this.title,
    this.leading,
    this.trailing,
    required this.page, // TODO use builder
    required this.selection,
    this.backgroundColor = _kDefaultBackgroundColor,
    this.highlightColor = _kDefaultHighlightColor,
    this.autoCloseWhenTapped = true,
    this.autoCloseWhenAlreadySelected = false,
  }) : super(type: _DrawerItemType.page);

  /// Creates a [DrawerPageItem] in a simple way.
  DrawerPageItem.simple(
    String title,
    IconData? icon,
    Widget page,
    T selection, {
    Color backgroundColor = _kDefaultBackgroundColor,
    Color highlightColor = _kDefaultHighlightColor,
    bool autoCloseWhenTapped = true,
    bool autoCloseWhenAlreadySelected = false,
  }) : this(
          title: Text(title),
          leading: icon == null ? null : Icon(icon),
          page: page,
          selection: selection,
          backgroundColor: backgroundColor,
          highlightColor: highlightColor,
          autoCloseWhenTapped: autoCloseWhenTapped,
          autoCloseWhenAlreadySelected: autoCloseWhenAlreadySelected,
        );

  /// The title widget of this item.
  final Widget title;

  /// The leading widget of this item.
  final Widget? leading;

  /// The trailing widget of this item.
  final Widget? trailing;

  /// The navigator destination page.
  final Widget page;

  /// The current page selection value, with [T] type.
  final T selection;

  /// The background color of this item.
  final Color? backgroundColor;

  /// The highlight color of this item if selected.
  final Color? highlightColor;

  /// The switcher to auto close the drawer when this item is tapped and the page is shown, defaults to true.
  final bool? autoCloseWhenTapped;

  /// The switcher to auto close the drawer when this item is already selected, defaults to false.
  final bool? autoCloseWhenAlreadySelected;
}

/// A [DrawerItem] which is used to invoke an action, this will be wrapped by [ListTile].
class DrawerActionItem extends DrawerItem {
  const DrawerActionItem({
    required this.title,
    this.leading,
    this.trailing,
    required this.action,
    this.longPressAction,
    this.backgroundColor = _kDefaultBackgroundColor,
    this.autoCloseWhenTapped = true,
    this.autoCloseWhenLongPressed = false,
  }) : super(type: _DrawerItemType.action);

  /// Creates a [DrawerActionItem] in a simple way.
  DrawerActionItem.simple(
    String title,
    IconData? icon,
    Function action, {
    Function? longPressAction,
    Color backgroundColor = _kDefaultBackgroundColor,
    bool autoCloseWhenTapped = true,
    bool autoCloseWhenLongPressed = false,
  }) : this(
          title: Text(title),
          leading: icon == null ? null : Icon(icon),
          action: action,
          backgroundColor: backgroundColor,
          autoCloseWhenTapped: autoCloseWhenTapped,
          autoCloseWhenLongPressed: autoCloseWhenLongPressed,
        );

  /// The title widget of this item.
  final Widget title;

  /// The leading widget of this item.
  final Widget? leading;

  /// The trailing widget of this item.
  final Widget? trailing;

  /// The tap action of this item.
  final Function action;

  /// The long pressed action of this item.
  final Function? longPressAction;

  /// The background color of this item.
  final Color? backgroundColor;

  /// The switcher to auto close the drawer when this item is tapped, defaults to true.
  final bool? autoCloseWhenTapped;

  /// The switcher to auto close the drawer when this item is long pressed, defaults to false.
  final bool? autoCloseWhenLongPressed;
}

/// A [DrawerItem] which is used to show a widget.
class DrawerWidgetItem extends DrawerItem {
  const DrawerWidgetItem({
    required this.child,
  }) : super(type: _DrawerItemType.widget);

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
/// enum DrawerSelection { home, a, b }
///
/// Drawer(
///   child: ListView(
///     padding: EdgeInsets.all(0),
///     children: [
///       DrawerHeader(...),
///       DrawerListView<DrawerSelection>(
///         items: [
///           DrawerPageItem<DrawerSelection>.simple('Home', null, HomePage(), DrawerSelection.home),
///           DrawerWidgetItem.simple(Divider()),
///           DrawerPageItem<DrawerSelection>.simple('A', null, APage(), DrawerSelection.a),
///           DrawerPageItem<DrawerSelection>.simple('B', null, BPage(), DrawerSelection.b),
///         ],
///         currentSelection: ...,
///         onNavigatorTo: (t, page) {
///           if (t == DrawerSelection.home) {
///             Navigator.of(context).popUntil((route) => route.settings.name == 'HomePage');
///           } else {
///             Navigator.of(context).push(MaterialPageRoute(builder: (c) => page));
///           }
///         },
///       ),
///     ],
///   ),
/// );
/// ```
class DrawerListView<T> extends StatefulWidget {
  const DrawerListView({
    Key? key,
    required this.items,
    required this.onNavigatorTo,
    this.currentSelection,
    this.enableHighlight = true,
    // TODO add default options
  }) : super(key: key);

  /// The list of [DrawerItem] to show.
  final List<DrawerItem> items;

  /// The navigateTo function used for [DrawerPageItem].
  final Function(T?, Widget) onNavigatorTo;

  /// The current selected item used for [DrawerPageItem].
  final T? currentSelection;

  /// The switcher to highlight the selected item used for [DrawerPageItem], defaults to true.
  final bool? enableHighlight;

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
            // ====
            // page
            // ====
            case _DrawerItemType.page:
              var page = item as DrawerPageItem<T>;
              var selected = (widget.enableHighlight ?? true) && widget.currentSelection == page.selection;
              return Container(
                color: selected ? (page.highlightColor ?? _kDefaultHighlightColor) : (page.backgroundColor ?? _kDefaultBackgroundColor),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: page.title,
                    leading: page.leading,
                    trailing: page.trailing,
                    selected: selected,
                    onTap: () {
                      if (widget.currentSelection != page.selection) {
                        if (page.autoCloseWhenTapped ?? true) {
                          Navigator.pop(context);
                        }
                        widget.onNavigatorTo.call(page.selection, page.page);
                      } else if (page.autoCloseWhenAlreadySelected ?? false) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              );
            // ======
            // action
            // ======
            case _DrawerItemType.action:
              var action = item as DrawerActionItem;
              return Container(
                color: action.backgroundColor ?? _kDefaultBackgroundColor,
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: action.title,
                    leading: action.leading,
                    trailing: action.trailing,
                    onTap: () {
                      if (action.autoCloseWhenTapped ?? true) {
                        Navigator.pop(context);
                      }
                      action.action();
                    },
                    onLongPress: action.longPressAction == null
                        ? null
                        : () {
                            if (action.autoCloseWhenLongPressed ?? false) {
                              Navigator.pop(context);
                            }
                            action.longPressAction?.call();
                          },
                  ),
                ),
              );
            // ======
            // widget
            // ======
            case _DrawerItemType.widget:
              var widget = item as DrawerWidgetItem;
              return widget.child;
            // ===========
            // unreachable
            // ===========
            default:
              return const SizedBox(height: 0); // dummy
          }
        },
      ).toList(),
    );
  }
}
