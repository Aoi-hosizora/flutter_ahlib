import 'package:flutter/material.dart';

enum DrawerItemType { action, divider }

abstract class DrawerItem {
  const DrawerItem({this.type});

  final DrawerItemType type;
}

class DrawerAction<T> extends DrawerItem {
  const DrawerAction({
    @required this.title,
    @required this.icon,
    this.trailing,
    @required this.action,
    @required this.selection,
  })  : assert(title != null),
        assert(icon != null),
        assert(action != null),
        assert(selection != null),
        super(type: DrawerItemType.action);

  final String title;
  final IconData icon;
  final Widget trailing;
  final void Function() action;
  final T selection;
}

class DrawerDivider extends DrawerItem {
  const DrawerDivider({
    @required this.divider,
  })  : assert(divider != null),
        super(type: DrawerItemType.divider);

  final Divider divider;
}

class DrawerListView<T> extends StatefulWidget {
  const DrawerListView({
    Key key,
    @required this.items,
    this.highlightColor,
    this.currentDrawerSelection,
  })  : assert(items != null),
        super(key: key);

  final List<DrawerItem> items;
  final Color highlightColor;
  final T currentDrawerSelection;

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
            case DrawerItemType.action:
              DrawerAction<T> page = item;
              return Container(
                color: widget.currentDrawerSelection != page.selection
                    ? Colors.transparent
                    : widget.highlightColor ?? Colors.grey[200],
                child: ListTile(
                  leading: Icon(page.icon),
                  title: Text(page.title),
                  trailing: page.trailing,
                  selected: widget.currentDrawerSelection == page.selection,
                  onTap: () => page.action(),
                ),
              );
            case DrawerItemType.divider:
              return (item as DrawerDivider).divider;
          }
        },
      ).toList(),
    );
  }
}
