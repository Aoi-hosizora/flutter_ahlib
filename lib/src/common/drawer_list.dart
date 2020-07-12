import 'package:flutter/material.dart';

enum DrawerItemType { page, action, divider }

/// abstract type for deawer item
abstract class DrawerItem {
  const DrawerItem({this.type});

  final DrawerItemType type;
}

/// `DrawerItem` used for navigator a page (`Widget view`)
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

/// `DrawerItem` used to invoke an action (`void Function() action`)
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

/// `DrawerItem` used to show a divider (`Divider divider`)
class DrawerDivider extends DrawerItem {
  const DrawerDivider({
    @required this.divider,
  })  : assert(divider != null),
        super(type: DrawerItemType.divider);

  final Divider divider;
}

/// A wrapped `Column` for `Drawer`
/// Demo:
/// 
/// ```
/// 
/// enum DrawerSelection { none, home, favorite, download, search, history }
/// 
/// Drawer(
///   child: ListView(
///     padding: WdgeInsets.all(0),
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

  final List<DrawerItem> items;
  final Color highlightColor;
  final T currentDrawerSelection;
  final T rootSelection;

  @override
  _DrawerListViewState<T> createState() => _DrawerListViewState<T>();
}

class _DrawerListViewState<T> extends State<DrawerListView<T>> {
  void goto(DrawerPage<T> page) {
    if (widget.currentDrawerSelection == page.selection) {
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
                color: widget.currentDrawerSelection != page.selection
                    ? Colors.transparent
                    : widget.highlightColor ?? Colors.grey[200],
                child: ListTile(
                  leading: Icon(page.icon),
                  title: Text(page.title),
                  selected: widget.currentDrawerSelection == page.selection,
                  onTap: () => goto(page),
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
