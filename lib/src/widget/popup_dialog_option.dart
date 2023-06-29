import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/icon_text.dart';
import 'package:flutter_ahlib/src/util/flutter_constants.dart';

/// The default padding for [TextDialogOption].
const kTextDialogOptionPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0); // same as SimpleDialog's titlePadding

/// The default padding for [IconTextDialogOption].
const kIconTextDialogOptionPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0);

/// The default space for [IconTextDialogOption].
const kIconTextDialogOptionSpace = 15.0;

/// The default icon color for [IconTextDialogOption].
const kIconTextDialogOptionIconColor = Color.fromRGBO(85, 85, 85, 1.0);

/// The default padding for [CircularProgressDialogOption].
const kCircularProgressDialogOptionPadding = EdgeInsets.symmetric(horizontal: 35.0, vertical: 24.0);

/// The default space for [CircularProgressDialogOption].
const kCircularProgressDialogOptionSpace = 32.0;

/// An option used in a [SimpleDialog], which wraps [text] with default padding and style.
class TextDialogOption extends StatelessWidget {
  const TextDialogOption({
    Key? key,
    required this.text,
    required this.onPressed,
    this.onLongPressed,
    this.padding = kTextDialogOptionPadding,
    this.predicateForPress,
    this.predicateForLongPress,
    this.popWhenPress,
    this.popWhenLongPress,
  }) : super(key: key);

  /// The text widget below this widget in the tree, typically a [Text] widget.
  final Widget text;

  /// The callback that is called when this option is tapped, note that you can set [predicateForPress]
  /// and [popWhenPress] for convenience, see these two fields to details.
  final void Function() onPressed;

  /// The callback that is called when this option is long pressed, note that you can set [predicateForLongPress]
  /// and [popWhenLongPress] for convenience, see these two fields to details.
  final void Function()? onLongPressed;

  /// The padding to surround the [text], defaults to `EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)`.
  final EdgeInsets padding;

  /// The predicate function for deciding whether to execute [onTap] callback or not, defaults to null, which
  /// means always to execute the [onPressed] callback when pressed.
  final Future<bool> Function()? predicateForPress;

  /// The predicate function for deciding whether to execute [onLongPress] callback or not, defaults to null,
  /// which means always to execute the [onLongPressed] callback when pressed.
  final Future<bool> Function()? predicateForLongPress;

  /// This is a convenient field only used in [showDialog]. If you set the this value to dialog's context,
  /// the specific dialog will be popped before [onPressed] is invoked.
  final BuildContext? popWhenPress;

  /// This is a convenient field only used in [showDialog]. If you set the this value to dialog's context,
  /// the specific dialog will be popped before [onLongPressed] is invoked.
  final BuildContext? popWhenLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (predicateForPress != null) {
          var ok = await predicateForPress?.call() ?? true;
          if (!ok) {
            return;
          }
        }
        if (popWhenPress != null) {
          Navigator.of(popWhenPress!).pop();
        }
        onPressed.call();
      },
      onLongPress: onLongPressed == null
          ? null
          : () async {
              if (predicateForLongPress != null) {
                var ok = await predicateForLongPress?.call() ?? true;
                if (!ok) {
                  return;
                }
              }
              if (popWhenLongPress != null) {
                Navigator.of(popWhenLongPress!).pop();
              }
              onLongPressed?.call();
            },
      child: Padding(
        padding: padding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: text,
        ),
      ),
    );
  }
}

/// An option used in a [SimpleDialog], which wraps [icon] and [text] with default padding and style.
class IconTextDialogOption extends StatelessWidget {
  const IconTextDialogOption({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.onLongPressed,
    this.padding = kIconTextDialogOptionPadding,
    this.space = kIconTextDialogOptionSpace,
    this.rtl = false,
    this.predicateForPress,
    this.predicateForLongPress,
    this.popWhenPress,
    this.popWhenLongPress,
  }) : super(key: key);

  /// The icon widget below this widget in the tree, typically is a [Icon] widget.
  final Widget icon;

  /// The text widget below this widget in the tree, typically is a [Text] widget.
  final Widget text;

  /// The callback that is called when this option is tapped, note that you can set [predicateForPress]
  /// and [popWhenPress] for convenience, see these two fields to details.
  final void Function() onPressed;

  /// The callback that is called when this option is long pressed, note that you can set [predicateForLongPress]
  /// and [popWhenLongPress] for convenience, see these two fields to details.
  final void Function()? onLongPressed;

  /// The padding to surround the [icon] and [text], defaults to `EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0)`.
  final EdgeInsets padding;

  /// The space between [icon] and [text], defaults to 15.0.
  final double space;

  /// The flag to display widget in `text | icon` order, defaults to false.
  final bool rtl;

  /// The predicate function for deciding whether to execute [onTap] callback or not, defaults to null, which
  /// means always to execute the [onPressed] callback when pressed.
  final Future<bool> Function()? predicateForPress;

  /// The predicate function for deciding whether to execute [onLongPress] callback or not, defaults to null,
  /// which means always to execute the [onLongPressed] callback when pressed.
  final Future<bool> Function()? predicateForLongPress;

  /// This is a convenient field only used in [showDialog]. If you set the this value to dialog's context,
  /// the specific dialog will be popped before [onPressed] is invoked.
  final BuildContext? popWhenPress;

  /// This is a convenient field only used in [showDialog]. If you set the this value to dialog's context,
  /// the specific dialog will be popped before [onLongPressed] is invoked.
  final BuildContext? popWhenLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (predicateForPress != null) {
          var ok = await predicateForPress?.call() ?? true;
          if (!ok) {
            return;
          }
        }
        if (popWhenPress != null) {
          Navigator.of(popWhenPress!).pop();
        }
        onPressed.call();
      },
      onLongPress: onLongPressed == null
          ? null
          : () async {
              if (predicateForLongPress != null) {
                var ok = await predicateForLongPress?.call() ?? true;
                if (!ok) {
                  return;
                }
              }
              if (popWhenLongPress != null) {
                Navigator.of(popWhenLongPress!).pop();
              }
              onLongPressed?.call();
            },
      child: Padding(
        padding: padding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: IconTheme(
            data: Theme.of(context).iconTheme.copyWith(color: kIconTextDialogOptionIconColor),
            child: IconText(
              icon: icon,
              text: !rtl ? text : Expanded(child: text),
              space: space,
              alignment: !rtl ? IconTextAlignment.l2r : IconTextAlignment.r2l,
            ),
          ),
        ),
      ),
    );
  }
}

/// An option used in a [AlertDialog], which wraps [progress] and [child] with default padding and style.
/// Note that you have to set [AlertDialog.contentPadding] to [EdgeInsets.zero] in order to show correctly.
class CircularProgressDialogOption extends StatelessWidget {
  const CircularProgressDialogOption({
    Key? key,
    required this.progress,
    required this.child,
    this.padding = kCircularProgressDialogOptionPadding,
    this.space = kCircularProgressDialogOptionSpace,
  }) : super(key: key);

  /// The icon widget below this widget in the tree, typically is a [CircularProgressIndicator] widget.
  final Widget progress;

  /// The icon widget below this widget in the tree, typically is a [Text] widget.
  final Widget child;

  /// The padding to surround the [progress] and [child], defaults to `EdgeInsets.zero`.
  final EdgeInsets padding;

  /// The space between [progress] and [child], defaults to 24.0.
  final double space;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle1!,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            progress,
            SizedBox(width: space),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// Calculates a width that can fill [AlertDialog] or [SimpleDialog] with the screen width.
double getDialogMaxWidth(BuildContext context) {
  var horizontalPadding = MediaQuery.of(context).padding + kDialogDefaultInsetPadding; // ignore content padding
  return MediaQuery.of(context).size.width - horizontalPadding.horizontal;
}

/// Calculates a content width that can fill [AlertDialog] with the screen width.
double getDialogContentMaxWidth(BuildContext context) {
  var horizontalPadding = MediaQuery.of(context).padding + kDialogDefaultInsetPadding + kAlertDialogDefaultContentPadding;
  return MediaQuery.of(context).size.width - horizontalPadding.horizontal;
}

/// This is a convenient function to show [AlertDialog] with given [title], [content] and two action buttons.
///
/// Note that you can set [yesText] or [noText] to null to hide the specific button. Also note that [yesOnPressed]
/// and [noOnPressed] can be used to override the default onPressed callback, but [Navigator.pop] must be called manually.
Future<bool?> showYesNoAlertDialog({
  required BuildContext context,
  required Widget? title,
  required Widget? content,
  required Widget? yesText,
  required Widget? noText,
  bool reverseYesNoOrder = false,
  // showDialog parameters
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  // AlertDialog parameters
  EdgeInsetsGeometry? titlePadding,
  TextStyle? titleTextStyle,
  EdgeInsetsGeometry contentPadding = kAlertDialogDefaultContentPadding,
  TextStyle? contentTextStyle,
  List<Widget>? actions,
  EdgeInsetsGeometry actionsPadding = EdgeInsets.zero,
  MainAxisAlignment? actionsAlignment,
  VerticalDirection? actionsOverflowDirection,
  double? actionsOverflowButtonSpacing,
  EdgeInsetsGeometry? buttonPadding,
  Color? backgroundColor,
  double? elevation,
  String? semanticLabel,
  EdgeInsets insetPadding = kDialogDefaultInsetPadding,
  Clip clipBehavior = Clip.none,
  ShapeBorder? shape,
  AlignmentGeometry? alignment,
  bool scrollable = false,
  // actions parameters
  void Function(BuildContext)? yesOnPressed,
  void Function(BuildContext)? yesOnLongPress,
  void Function(BuildContext, bool)? yesOnHover,
  void Function(BuildContext, bool)? yesOnFocusChange,
  ButtonStyle? yesStyle,
  FocusNode? yesFocusNode,
  bool yesAutoFocus = false,
  Clip yesClipBehavior = Clip.none,
  void Function(BuildContext)? noOnPressed,
  void Function(BuildContext)? noOnLongPress,
  void Function(BuildContext, bool)? noOnHover,
  void Function(BuildContext, bool)? noOnFocusChange,
  ButtonStyle? noStyle,
  FocusNode? noFocusNode,
  bool noAutoFocus = false,
  Clip noClipBehavior = Clip.none,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (c) {
      var actions = [
        if (yesText != null)
          TextButton(
            child: yesText,
            onPressed: yesOnPressed == null ? () => Navigator.of(c).pop(true) : () => yesOnPressed.call(c),
            onLongPress: yesOnLongPress == null ? null : () => yesOnLongPress.call(c),
            onHover: yesOnHover == null ? null : (v) => yesOnHover.call(c, v),
            onFocusChange: yesOnFocusChange == null ? null : (v) => yesOnFocusChange.call(c, v),
            style: yesStyle,
            focusNode: yesFocusNode,
            autofocus: yesAutoFocus,
            clipBehavior: yesClipBehavior,
          ),
        if (noText != null)
          TextButton(
            child: noText,
            onPressed: noOnPressed == null ? () => Navigator.of(c).pop(false) : () => noOnPressed.call(c),
            onLongPress: noOnLongPress == null ? null : () => noOnLongPress.call(c),
            onHover: noOnHover == null ? null : (v) => noOnHover.call(c, v),
            onFocusChange: noOnFocusChange == null ? null : (v) => noOnFocusChange.call(c, v),
            style: noStyle,
            focusNode: noFocusNode,
            autofocus: noAutoFocus,
            clipBehavior: noClipBehavior,
          ),
      ];
      if (reverseYesNoOrder) {
        actions = actions.reversed.toList();
      }
      return AlertDialog(
        title: title,
        content: content,
        actions: actions,
        // AlertDialog parameters
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle,
        contentPadding: contentPadding,
        contentTextStyle: contentTextStyle,
        actionsPadding: actionsPadding,
        actionsAlignment: actionsAlignment,
        actionsOverflowDirection: actionsOverflowDirection,
        actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
        buttonPadding: buttonPadding,
        backgroundColor: backgroundColor,
        elevation: elevation,
        semanticLabel: semanticLabel,
        insetPadding: insetPadding,
        clipBehavior: clipBehavior,
        shape: shape,
        alignment: alignment,
        scrollable: scrollable,
      );
    },
    // showDialog parameters
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

// Note: The following code is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// The following code in this file keeps the same as the following source code:
// - PopupMenuItem: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/popup_menu.dart

/// A long pressable [PopupMenuItem], which adds [onLongPressed] property.
class LongPressablePopupMenuItem<T> extends PopupMenuEntry<T> {
  const LongPressablePopupMenuItem({
    Key? key,
    this.value,
    this.onTap,
    this.onLongPressed,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    required this.child,
  }) : super(key: key);

  final T? value;
  final VoidCallback? onTap;
  final VoidCallback? onLongPressed; // <<< Added by AoiHosizora
  final bool enabled;
  @override
  final double height;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final MouseCursor? mouseCursor;
  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenuItemState<T, LongPressablePopupMenuItem<T>> createState() => PopupMenuItemState<T, LongPressablePopupMenuItem<T>>();
}

/// The [State] for [LongPressablePopupMenuItem] subclasses.
class PopupMenuItemState<T, W extends LongPressablePopupMenuItem<T>> extends State<W> {
  static const double _kMenuHorizontalPadding = 16.0;

  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {
    widget.onTap?.call();
    Navigator.pop<T>(context, widget.value);
  }

  // This method is added by AoiHosizora.
  void _handleLongPress() {
    widget.onLongPressed?.call();
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style = widget.textStyle ?? popupMenuTheme.textStyle ?? theme.textTheme.subtitle1!;

    if (!widget.enabled) {
      style = style.copyWith(color: theme.disabledColor);
    }

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }
    final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!widget.enabled) MaterialState.disabled,
      },
    );

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          onLongPress: widget.enabled ? _handleLongPress : null /* <<< Added by AoiHosizora */,
          canRequestFocus: widget.enabled,
          mouseCursor: effectiveMouseCursor,
          child: item,
        ),
      ),
    );
  }
}
