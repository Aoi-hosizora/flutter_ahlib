import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';

/// The default padding of [MenuItem].
const _kDefaultMenuItemPadding = EdgeInsets.symmetric(vertical: 8, horizontal: 24);

/// The default padding of [TextMenuItem].
const _kDefaultTextMenuItemPadding = EdgeInsets.symmetric(horizontal: 28, vertical: 16);

/// The default padding of [IconTextMenuItem].
const _kDefaultIconTextMenuItemPadding = EdgeInsets.symmetric(horizontal: 23, vertical: 10);

/// An enum type for [MenuItem] and [TextMenuItem], used to specify dialog's dismiss behavior.
enum DismissBehavior {
  /// Never to dismiss the dialog when doing action.
  never,

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
  Color? barrierColor = Colors.black54,
  bool? useSafeArea = true,
  // TODO add default options (DismissBehavior)
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    barrierColor: barrierColor ?? Colors.black54,
    useSafeArea: useSafeArea ?? true,
    builder: (c) => SimpleDialog(
      title: title,
      children: [
        for (var item in items)
          SimpleDialogOption(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.subtitle1!, // TODO custom-able
              child: item.child,
            ),
            padding: item.padding ?? _kDefaultMenuItemPadding,
            onPressed: () {
              var dismissBehavior = item.dismissBehavior ?? DismissBehavior.before;
              if (dismissBehavior == DismissBehavior.before) {
                Navigator.of(c).pop();
              }
              item.action();
              if (dismissBehavior == DismissBehavior.after) {
                Navigator.of(c).pop();
              }
            },
          ),
      ],
    ),
  );
}

/// A custom [SingleChildLayoutDelegate] which is used by [CustomSingleChildLayout] or [RenderCustomSingleChildLayoutBox],
/// the custom delegate uses function parameters as override methods.
class CustomSingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  const CustomSingleChildLayoutDelegate({
    this.sizeGetter,
    this.constraintsGetter,
    this.positionGetter,
    this.relayoutChecker,
  });

  /// The size of this object given the incoming constraints.
  final Size Function(BoxConstraints constraints)? sizeGetter;

  /// The constraints for the child given the incoming constraints.
  final BoxConstraints Function(BoxConstraints constraints)? constraintsGetter;

  /// The position where the child should be placed.
  final Offset Function(Size size, Size childSize)? positionGetter;

  /// The flag which represents new new instance is different with the old one.
  final bool Function()? relayoutChecker;

  @override
  Size getSize(BoxConstraints constraints) {
    return sizeGetter?.call(constraints) ?? constraints.biggest;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraintsGetter?.call(constraints) ?? constraints;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionGetter?.call(size, childSize) ?? Offset.zero;
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return relayoutChecker?.call() ?? true;
  }
}
