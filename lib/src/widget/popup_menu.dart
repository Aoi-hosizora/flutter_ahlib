import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';

/// Icon popup menu item used in [showIconPopupMenu].
class IconPopupActionItem {
  const IconPopupActionItem({
    @required this.text,
    @required this.icon,
    @required this.action,
  })  : assert(text != null),
        assert(icon != null),
        assert(action != null);

  /// Action text.
  final Text text;

  /// Action icon.
  final Icon icon;

  /// Action function.
  final void Function() action;
}

/// Text popup menu item used in [showTextPopupMenu].
class TextPopupActionItem {
  const TextPopupActionItem({
    @required this.text,
    @required this.action,
  })  : assert(text != null),
        assert(action != null);

  /// Action text.
  final Text text;

  /// Action function.
  final void Function() action;
}

/// Show icon popup menu of list of [IconPopupActionItem] with [IconText] in [SimpleDialogOption] and [SimpleDialog].
void showIconPopupMenu({
  @required BuildContext context,
  @required Widget title,
  @required List<IconPopupActionItem> items,
  EdgeInsets optionPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
  bool popWhenPressed = true,
  bool barrierDismissible = true,
  Color barrierColor,
  double space = 15.0,
  IconTextAlignment alignment = IconTextAlignment.l2r,
}) {
  assert(context != null);
  assert(title != null);
  assert(items != null);
  assert(optionPadding != null);
  assert(popWhenPressed != null);
  assert(barrierDismissible != null);
  assert(space != null);
  assert(alignment != null);

  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    builder: (c) => SimpleDialog(
      title: title,
      children: items
          .map(
            (i) => SimpleDialogOption(
              child: IconText(
                icon: i.icon,
                text: i.text,
                space: space,
                alignment: alignment,
              ),
              onPressed: () {
                if (popWhenPressed) {
                  Navigator.pop(c);
                }
                i.action();
              },
              padding: optionPadding,
            ),
          )
          .toList(),
    ),
  );
}

/// Show text popup menu of list of [TextPopupActionItem] with [Text] in [SimpleDialogOption] and [SimpleDialog].
void showTextPopupMenu({
  @required BuildContext context,
  @required Widget title,
  @required List<TextPopupActionItem> items,
  EdgeInsets optionPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
  bool popWhenPressed = true,
  bool barrierDismissible = true,
  Color barrierColor,
}) {
  assert(context != null);
  assert(title != null);
  assert(items != null);
  assert(optionPadding != null);
  assert(popWhenPressed != null);
  assert(barrierDismissible != null);

  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    builder: (c) => SimpleDialog(
      title: title,
      children: items
          .map(
            (i) => SimpleDialogOption(
              child: i.text,
              onPressed: () {
                if (popWhenPressed) {
                  Navigator.pop(c);
                }
                i.action();
              },
              padding: optionPadding,
            ),
          )
          .toList(),
    ),
  );
}
