import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';

/// [MenuItem] is a replacement of [SimpleDialogOption] used in [showPopupListMenu]. This is not a [Widget],
/// but a data class to store option and used as a [SimpleDialogOption].
class MenuItem {
  const MenuItem({
    @required Widget child,
    @required this.action,
    this.padding,
    this.dismissBefore = true,
    this.dismissAfter = false,
  })  : assert(child != null),
        assert(action != null),
        assert(dismissBefore != null),
        assert(dismissAfter != null),
        assert(dismissBefore == false || dismissAfter == false, 'dismissBefore and dismissAfter could only have one is true'),
        _child = child;

  /// A child needs to rendered, see [child].
  final Widget _child;

  /// A function will be invoked when this item is tapped.
  final Function action;

  /// Padding for menu item.
  final EdgeInsets padding;

  /// A dialog option for dismiss before the action invoked.
  final bool dismissBefore;

  /// A dialog option for dismiss after the action invoked.
  final bool dismissAfter;

  /// A rendered child for menu item.
  Widget get child => _child;
}

/// A [MenuItem] with only a [Text], and has a default [padding].
class TextMenuItem extends MenuItem {
  const TextMenuItem({
    @required Text text,
    Function action,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
    bool dismissBefore,
    bool dismissAfter,
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
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    bool dismissBefore,
    bool dismissAfter,
  }) : super(
          child: iconText,
          action: action,
          padding: padding,
          dismissBefore: dismissBefore,
          dismissAfter: dismissAfter,
        );
}

/// Show [SimpleDialog] with a list of items, the items can be [MenuItem], [TextMenuItem], [IconTextMenuItem]
/// or your own defined [MenuItem].
Future<void> showPopupListMenu({
  @required BuildContext context,
  @required Widget title,
  @required List<MenuItem> items,
  bool barrierDismissible = true,
  Color barrierColor,
  bool useSafeArea = true,
}) {
  assert(context != null);
  assert(title != null);
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
