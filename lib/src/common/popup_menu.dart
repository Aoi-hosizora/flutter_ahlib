import 'package:flutter/material.dart';
import 'file:///F:/Projects/flutter_ahlib/lib/src/common/icon_text.dart';

/// Popup menu item used in [showPopupMenu].
class PopupActionItem {
  const PopupActionItem({
    @required this.text,
    @required this.icon,
    @required this.action,
  })  : assert(text != null),
        assert(icon != null),
        assert(action != null);

  /// Action text.
  final String text;

  /// Action icon.
  final IconData icon;

  /// Action function.
  final void Function() action;
}

/// Show popup menu of list of [PopupActionItem] with [IconText] in [SimpleDialog].
void showPopupMenu({
  @required BuildContext context,
  @required Widget title,
  @required List<PopupActionItem> items,
  bool popWhenPressed = true,
  bool barrierDismissible = true,
  Color barrierColor,
}) {
  assert(context != null);
  assert(title != null);
  assert(items != null);
  assert(popWhenPressed != null);
  assert(barrierDismissible != null);

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
                if (popWhenPressed) {
                  Navigator.pop(c);
                }
                i.action();
              },
            ),
          )
          .toList(),
    ),
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
  );
}
