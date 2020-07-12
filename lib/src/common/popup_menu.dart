import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/item/icon_text.dart';

/// item for `showPopupMenu`, mainly will be used in `IconText`
class PopupActionItem {
  const PopupActionItem({
    @required this.text,
    @required this.icon,
    @required this.action,
  })  : assert(text != null),
        assert(icon != null),
        assert(action != null);

  final String text;
  final IconData icon;
  final void Function() action;
}

/// show popup menu of `List<PopupActionItem` by `SimpleDialog`
void showPopupMenu({
  @required BuildContext context,
  @required Widget title,
  @required List<PopupActionItem> items,
}) {
  assert(context != null);
  assert(title != null);
  assert(items != null);

  showDialog(
    context: context,
    builder: (c) => SimpleDialog(
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
  );
}
