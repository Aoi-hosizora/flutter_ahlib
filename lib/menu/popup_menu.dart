import 'package:flutter/material.dart';
import 'package:flutter_ahlib/menu/icon_text.dart';

class PopupMenuItem {
  PopupMenuItem({
    @required this.text,
    @required this.icon,
    @required this.action,
  })  : assert(text != null),
        assert(icon != null),
        assert(action != null);

  String text;
  IconData icon;
  void Function() action;
}

void showPopupMenu({
  @required BuildContext context,
  @required Widget title,
  @required List<PopupMenuItem> items,
}) {
  showDialog(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => SimpleDialog(
        title: title,
        children: items
            .map(
              (i) => SimpleDialogOption(
                child: IconText(
                  icon: Icon(i.icon),
                  text: Text(i.text),
                ),
                onPressed: () {
                  Navigator.pop(c);
                  i.action();
                },
              ),
            )
            .toList(),
      ),
    ),
  );
}
