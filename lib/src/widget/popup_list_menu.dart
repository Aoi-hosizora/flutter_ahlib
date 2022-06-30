import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';

/// The default padding of [MenuItem].
const _kDefaultMenuItemPadding = EdgeInsets.symmetric(vertical: 8, horizontal: 24);

/// The default padding of [TextMenuItem].
const _kDefaultTextMenuItemPadding = EdgeInsets.symmetric(horizontal: 28, vertical: 16);

/// The default padding of [IconTextMenuItem].
const _kDefaultIconTextMenuItemPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 10);

/// An enum type for [MenuItem] and [TextMenuItem], used to specify dialog's dismiss behavior.
enum DismissBehavior {
  /// Not to dismiss the dialog.
  no,

  /// Dismisses the dialog before doing action.
  before,

  /// Dismisses the dialog after doing action.
  after,
}

/// A menu item used in [showPopupListMenu], is a replacement of [SimpleDialogOption] used in [showDialog].
/// This is not a [Widget], but just a data class to store options and used as a [SimpleDialogOption].
class MenuItem {
  const MenuItem({
    required this.child,
    required this.action,
    this.padding = _kDefaultMenuItemPadding,
    this.dismissBehavior = DismissBehavior.before,
  });

  /// The child of this item.
  final Widget child;

  /// The function that will be invoked when this item is tapped.
  final Function action;

  /// The padding of this item, defaults to EdgeInsets.symmetric(vertical: 8, horizontal: 24).
  final EdgeInsets? padding;

  /// The behavior enum used to specify dialog's dismiss behavior, defaults to [DismissBehavior.before].
  final DismissBehavior? dismissBehavior;
}

/// A [MenuItem] with only a [Text], and has a default padding EdgeInsets.symmetric(horizontal: 28, vertical: 16)
/// and subtitle1 text style.
class TextMenuItem extends MenuItem {
  const TextMenuItem({
    required Widget text,
    required Function action,
    EdgeInsets? padding = _kDefaultTextMenuItemPadding,
    DismissBehavior? dismissBehavior = DismissBehavior.before,
  }) : super(
          child: text,
          action: action,
          padding: padding ?? _kDefaultTextMenuItemPadding,
          dismissBehavior: dismissBehavior,
        );
}

/// A [MenuItem] with only a [IconText], and has a default padding EdgeInsets.symmetric(horizontal: 18, vertical: 10)
/// and subtitle1 text style.
class IconTextMenuItem extends MenuItem {
  const IconTextMenuItem({
    required Widget iconText,
    required Function action,
    EdgeInsets? padding = _kDefaultIconTextMenuItemPadding,
    DismissBehavior? dismissBehavior = DismissBehavior.before,
  }) : super(
          child: iconText,
          action: action,
          padding: padding ?? _kDefaultIconTextMenuItemPadding,
          dismissBehavior: dismissBehavior,
        );
}

/// Shows [SimpleDialog] with a list of items, the items can be [MenuItem], [TextMenuItem] and [IconTextMenuItem].
Future<void> showPopupListMenu({
  required BuildContext context,
  Widget? title,
  required List<MenuItem> items,
  bool? barrierDismissible = true,
  Color? barrierColor,
  bool? useSafeArea = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    barrierColor: barrierColor,
    useSafeArea: useSafeArea ?? true,
    builder: (c) => SimpleDialog(
      title: title,
      children: [
        for (var item in items)
          SimpleDialogOption(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.subtitle1!,
              child: item.child,
            ),
            padding: item.padding ?? _kDefaultMenuItemPadding,
            onPressed: () {
              if ((item.dismissBehavior ?? DismissBehavior.before) == DismissBehavior.before) {
                Navigator.of(c).pop();
              }
              item.action();
              if (item.dismissBehavior == DismissBehavior.after) {
                Navigator.of(c).pop();
              }
            },
          ),
      ],
    ),
  );
}
