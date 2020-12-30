import 'package:flutter/material.dart';

/// A type that describes the kind of [DrawerItem].
enum _DrawerItemType {
  /// Type for [DrawerPage].
  page,

  /// Type for [DrawerAction].
  action,

  /// Type for [DrawerDivider].
  divider,
}

/// Abstract drawer type used in [DrawerListView],
/// inherited by [DrawerPage], [DrawerAction] and [DrawerDivider].
abstract class DrawerItem {
  const DrawerItem({this.type});

  final _DrawerItemType type;
}

/// A [DrawerItem] is used to navigate to a page, where [T] can be an enum type for pages.
class DrawerPage<T> extends DrawerItem {
  const DrawerPage({
    @required this.title,
    @required this.icon,
    @required this.view,
    this.selection,
  })  : assert(title != null),
        assert(icon != null),
        assert(view != null),
        super(type: _DrawerItemType.page);

  /// A simple constructor to create a default [DrawerPage].
  DrawerPage.simple(String title, IconData icon, Widget view, T selection)
      : this(
          title: Text(title),
          icon: Icon(icon),
          view: view,
          selection: selection,
        );

  final Widget title;
  final Widget icon;
  final Widget view;
  final T selection;
}

/// A [DrawerItem] is used to invoke an action.
class DrawerAction extends DrawerItem {
  const DrawerAction({
    @required this.title,
    @required this.icon,
    @required this.action,
  })  : assert(title != null),
        assert(icon != null),
        assert(action != null),
        super(type: _DrawerItemType.action);

  /// A simple constructor to create a default [DrawerAction].
  DrawerAction.simple(String title, IconData icon, Function action)
      : this(
          title: Text(title),
          icon: Icon(icon),
          action: action,
        );

  final Widget title;
  final Widget icon;
  final Function action;
}

/// A [DrawerItem] is used to show a divider.
class DrawerDivider extends DrawerItem {
  const DrawerDivider(this.divider)
      : assert(divider != null),
        super(type: _DrawerItemType.divider);

  final Divider divider;
}

/// A wrapped [Column] with [DrawerItem] used in [ListView] with [Drawer].
/// Demo:
/// ```
/// enum DrawerSelection { home }
/// Drawer(
///   child: ListView(
///     padding: EdgeInsets.all(0),
///     children: [
///       DrawerHeader(),
///       DrawerListView<DrawerSelection>(
///         items: [ xxx ],
///         highlightColor: Colors.grey[200],
///         currentDrawerSelection: widget.currentDrawerSelection,
///         rootSelection: DrawerSelection.home,
///       ),
///     ],
///   ),
/// )
/// ```
class DrawerListView<T> extends StatefulWidget {
  const DrawerListView({
    Key key,
    @required this.items,
    this.highlightColor = const Color(0xFFEEEEEE),
    this.currentDrawerSelection,
    this.rootSelection,
  })  : assert(items != null),
        assert(highlightColor != null),
        super(key: key);

  /// A list of [DrawerItem].
  final List<DrawerItem> items;

  /// Highlight color for current selected item.
  final Color highlightColor;

  /// Current selected item, used a enum [T].
  final T currentDrawerSelection;

  /// The root item, used a enum [T].
  final T rootSelection;

  @override
  _DrawerListViewState<T> createState() => _DrawerListViewState<T>();
}

class _DrawerListViewState<T> extends State<DrawerListView<T>> {
  /// Navigate to the specific page by [DrawerPage].
  void _goto(DrawerPage<T> page) {
    if (page.selection == widget.currentDrawerSelection) {
      return;
    }
    Navigator.pop(context);

    if (page.selection == widget.rootSelection) {
      Navigator.popUntil(context, (r) => r.isFirst);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => page.view,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map(
        (item) {
          switch (item.type) {
            case _DrawerItemType.page:
              DrawerPage<T> page = item;
              return Container(
                color: widget.currentDrawerSelection != page.selection ? Colors.transparent : widget.highlightColor,
                child: ListTile(
                  leading: page.icon,
                  title: page.title,
                  selected: widget.currentDrawerSelection == page.selection,
                  onTap: () => _goto(page),
                ),
              );
            case _DrawerItemType.action:
              DrawerAction action = item;
              return ListTile(
                leading: action.icon,
                title: action.title,
                onTap: () => action.action(),
              );
            case _DrawerItemType.divider:
              DrawerDivider divider = item;
              return divider.divider;
            default:
              return Container();
          }
        },
      ).toList(),
    );
  }
}
