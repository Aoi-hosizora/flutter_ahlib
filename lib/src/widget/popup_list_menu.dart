import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';

/// A menu item used in [showPopupListMenu], is a replacement of [SimpleDialogOption] used in [showPopupListMenu].
/// This is not a [Widget], but just a data class to store options and used as a [SimpleDialogOption].
class MenuItem {
  const MenuItem({
    @required Widget child,
    @required this.action,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    this.dismissBefore = true,
    this.dismissAfter = false,
  })  : assert(child != null),
        assert(action != null),
        assert(dismissBefore != null),
        assert(dismissAfter != null),
        assert(dismissBefore == false || dismissAfter == false, 'dismissBefore and dismissAfter could only have one is true'),
        _child = child;

  /// The child that needs to render, see [child].
  final Widget _child;

  /// The function that will be invoked when this item is tapped.
  final Function action;

  /// The padding of this item.
  final EdgeInsets padding;

  /// The switcher to dismiss before the action invoked.
  final bool dismissBefore;

  /// The switcher to dismiss after the action invoked.
  final bool dismissAfter;

  /// The rendered child of this item.
  Widget get child => _child;
}

/// A [MenuItem] with only a [Text], and has a default [padding].
class TextMenuItem extends MenuItem {
  const TextMenuItem({
    @required Text text,
    Function action,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 13), // text default padding
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
    @required IconText iconText,
    Function action,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 8), // iconText default padding
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
  assert(items != null && items.length > 0);
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
            child: item.child,
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
