import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';

/// A menu item used in [showPopupListMenu], is a replacement of [SimpleDialogOption] used in [showPopupListMenu].
/// This is not a [Widget], but just a data class to store options and used as a [SimpleDialogOption].
class MenuItem {
  const MenuItem({
    @required this.child,
    @required this.action,
    this.padding = const EdgeInsets.symmetric(horizontal: 27, vertical: 16),
    this.dismissBefore = true,
    this.dismissAfter = false,
  })  : assert(child != null),
        assert(action != null),
        assert(dismissBefore != null),
        assert(dismissAfter != null),
        assert(dismissBefore == false || dismissAfter == false, 'dismissBefore and dismissAfter could only have one is true');

  /// The child of this item, see [child].
  final Widget child;

  /// The function that will be invoked when this item is tapped.
  final Function action;

  /// The padding of this item.
  final EdgeInsets padding;

  /// The switcher to dismiss before the action invoked.
  final bool dismissBefore;

  /// The switcher to dismiss after the action invoked.
  final bool dismissAfter;
}

/// A [MenuItem] with only a [Text], and has a default [padding].
class TextMenuItem extends MenuItem {
  const TextMenuItem({
    @required Widget text,
    @required Function action,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 27, vertical: 16), // different default padding
    bool dismissBefore = true,
    bool dismissAfter = false,
  }) : super(
          child: text,
          action: action,
          padding: padding,
          dismissBefore: dismissBefore,
          dismissAfter: dismissAfter,
        );
}

/// A [MenuItem] with only a [IconText], and has a default [padding].
class IconTextMenuItem extends MenuItem {
  const IconTextMenuItem({
    @required Widget iconText,
    @required Function action,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 10), // different default padding
    bool dismissBefore = true,
    bool dismissAfter = false,
  }) : super(
          child: iconText,
          action: action,
          padding: padding,
          dismissBefore: dismissBefore,
          dismissAfter: dismissAfter,
        );
}

/// Shows [SimpleDialog] with a list of items, the items can be [MenuItem], [TextMenuItem] and [IconTextMenuItem].
Future<void> showPopupListMenu({
  @required BuildContext context,
  Widget title,
  @required List<MenuItem> items,
  bool barrierDismissible = true,
  Color barrierColor,
  bool useSafeArea = true,
}) {
  assert(context != null);
  assert(items != null);
  assert(barrierDismissible != null);
  assert(useSafeArea != null);

  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useSafeArea: useSafeArea,
    builder: (c) => SimpleDialog(
      title: title,
      children: [
        for (var item in items)
          SimpleDialogOption(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.subtitle1,
              child: item.child,
            ),
            padding: item.padding,
            onPressed: () {
              if (item.dismissBefore) {
                Navigator.of(c).pop();
              }
              item.action();
              if (item.dismissAfter) {
                Navigator.of(c).pop();
              }
            },
          ),
      ],
    ),
  );
}
