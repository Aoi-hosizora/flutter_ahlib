import 'package:flutter/material.dart';

/// A type that describes the kind of [DrawerItem].
enum DrawerItemType {
  page, // DrawerPage
  action, // DrawerAction
  divider, // DrawerDivider
}

/// Abstract drawer type used in [DrawerListView],
/// inherited by [DrawerPage], [DrawerAction] and [DrawerDivider].
abstract class DrawerItem {
  const DrawerItem({this.type});

  final DrawerItemType type;
}

/// A [DrawerItem] used to navigate to a page.
class DrawerPage<T> extends DrawerItem {
  const DrawerPage({
    @required this.title,
    @required this.icon,
    @required this.view,
    this.selection,
  })  : assert(title != null),
        assert(icon != null),
        assert(view != null),
        super(type: DrawerItemType.page);

  final String title;
  final IconData icon;
  final Widget view;
  final T selection;
}

/// A [DrawerItem] used to invoke an action.
class DrawerAction extends DrawerItem {
  const DrawerAction({
    @required this.title,
    @required this.icon,
    @required this.action,
  })  : assert(title != null),
        assert(icon != null),
        assert(action != null),
        super(type: DrawerItemType.action);

  final String title;
  final IconData icon;
  final void Function() action;
}

/// A [DrawerItem] used to show a divider.
class DrawerDivider extends DrawerItem {
  const DrawerDivider({
    @required this.divider,
  })  : assert(divider != null),
        super(type: DrawerItemType.divider);

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
///         items: [xxx],
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
    this.highlightColor,
    this.currentDrawerSelection,
    this.rootSelection,
  })  : assert(items != null),
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
            case DrawerItemType.page:
              DrawerPage<T> page = item;
              return Container(
                color: widget.currentDrawerSelection != page.selection ? Colors.transparent : widget.highlightColor ?? Colors.grey[200],
                child: ListTile(
                  leading: Icon(page.icon),
                  title: Text(page.title),
                  selected: widget.currentDrawerSelection == page.selection,
                  onTap: () => _goto(page),
                ),
              );
            case DrawerItemType.action:
              DrawerAction action = item;
              return ListTile(
                leading: Icon(action.icon),
                title: Text(action.title),
                onTap: () => action.action(),
              );
            case DrawerItemType.divider:
              return (item as DrawerDivider).divider;
            default:
              return SizedBox(height: 0);
          }
        },
      ).toList(),
    );
  }
}
