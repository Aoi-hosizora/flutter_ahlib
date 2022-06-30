import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/flutter_extension.dart';

/// An abstract text group item that represents [TextGroup]'s children, inherited by [NormalGroupText] and [LinkGroupText].
abstract class TextGroupItem {
  const TextGroupItem();

  /// The content of this item.
  String get text;

  /// The custom [TextSpan] builder.
  TextSpan Function(String text)? get textSpanBuilder;
}

/// A [TextGroupItem] that represents a normal text. This is not a [Widget], but just a data class to store options and used in
/// [TextGroup].
class NormalGroupText extends TextGroupItem {
  const NormalGroupText({
    required this.text,
    this.style,
  });

  /// The content of this item.
  @override
  final String text;

  /// The text style of this item.
  final TextStyle? style;

  /// The custom [TextSpan] builder, which is null for [NormalGroupText].
  @override
  TextSpan Function(String text)? get textSpanBuilder => null;
}

/// A [TextGroupItem] that represents a linked text. This is not a [Widget], but just a data class to store options and used in
/// [TextGroup].
class LinkGroupText extends TextGroupItem {
  const LinkGroupText({
    required this.text,
    this.normalStyle,
    this.pressedStyle,
    this.normalColor,
    this.pressedColor,
    this.showUnderline = true,
    required this.onTap,
  });

  /// The content of this item.
  @override
  final String text;

  /// The text style when this item is not pressed.
  final TextStyle? normalStyle;

  /// The text style when this item is pressed down.
  final TextStyle? pressedStyle;

  /// The link color when this item is not pressed.
  final Color? normalColor;

  /// The link color when this item is pressed down.
  final Color? pressedColor;

  /// The switcher to show link underline, defaults to true. Note that this option
  /// will not be used when [normalStyle] or [pressedStyle] is not null.
  final bool? showUnderline;

  /// The behavior when the link is pressed.
  final Function() onTap;

  /// The custom [TextSpan] builder, which is null for [LinkGroupText].
  @override
  TextSpan Function(String text)? get textSpanBuilder => null;
}

/// A [RichText] or [SelectableText] wrapped widget with state, including a list of child in [TextGroupItem] type, which can be
/// [NormalGroupText] and [LinkGroupText].
class TextGroup extends StatefulWidget {
  const TextGroup({
    Key? key,
    required this.texts,
    this.selectable = false,
    this.style,
    // both RichText and SelectableText
    this.maxLines,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor = 1.0,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    // RichText only
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.locale,
    // SelectableText only
    this.focusNode,
    this.showCursor = false,
    this.autofocus = false,
    this.enableInteractiveSelection = true,
    this.toolbarOptions = const ToolbarOptions(selectAll: true, copy: true),
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.minLines,
  })  : assert(texts.length > 0),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        super(key: key);

  /// The children of this widget.
  final List<TextGroupItem> texts;

  /// The switcher represents this widget can be selectable, defaults to false.
  final bool? selectable;

  /// The text style of the outer [TextSpan].
  final TextStyle? style;

  // both RichText and SelectableText

  /// The max lines of [RichText] and [SelectableText].
  final int? maxLines;

  /// The strutStyle of [RichText] and [SelectableText].
  final StrutStyle? strutStyle;

  /// The textAlign of [RichText] and [SelectableText], defaults to [TextAlign.start].
  final TextAlign? textAlign;

  /// The textDirection of [RichText] and [SelectableText].
  final TextDirection? textDirection;

  /// The textScaleFactor of [RichText] and [SelectableText], defaults to 1.0.
  final double? textScaleFactor;

  /// The textWidthBasis of [RichText] and [SelectableText], defaults to [TextWidthBasis.parent].
  final TextWidthBasis? textWidthBasis;

  /// The textHeightBehavior of [RichText] and [SelectableText].
  final TextHeightBehavior? textHeightBehavior;

  // RichText only

  /// The softWrap of [RichText] when [selectable] is false, defaults to true.
  final bool? softWrap;

  /// The overflow of [RichText] when [selectable] is false, defaults to [TextOverflow.clip].
  final TextOverflow? overflow;

  /// The locale of [RichText] when [selectable] is false.
  final Locale? locale;

  // SelectableText only

  /// The focusNode of [SelectableText] when [selectable] is true.
  final FocusNode? focusNode;

  /// The showCursor of [SelectableText] when [selectable] is true, defaults to false.
  final bool? showCursor;

  /// The autofocus of [SelectableText] when [selectable] is true, defaults to false.
  final bool? autofocus;

  /// The enableInteractiveSelection of [SelectableText] when [selectable] is true, defaults to true.
  final bool? enableInteractiveSelection;

  /// The toolbarOptions of [SelectableText] when [selectable] is true, defaults to [ToolbarOptions(selectAll: true, copy: true)].
  final ToolbarOptions? toolbarOptions;

  /// The cursorWidth of [SelectableText] when [selectable] is true, defaults to 2.0.
  final double? cursorWidth;

  /// The cursorHeight of [SelectableText] when [selectable] is true.
  final double? cursorHeight;

  /// The cursorRadius of [SelectableText] when [selectable] is true.
  final Radius? cursorRadius;

  /// The cursorColor of [SelectableText] when [selectable] is true.
  final Color? cursorColor;

  /// The dragStartBehavior of [SelectableText] when [selectable] is true, defaults to [DragStartBehavior.start].
  final DragStartBehavior? dragStartBehavior;

  /// The minLines of [SelectableText] when [selectable] is true.
  final int? minLines;

  @override
  _TextGroupState createState() => _TextGroupState();
}

class _TextGroupState extends State<TextGroup> {
  var _tapDowns = <bool>[]; // tap down indicator list

  @override
  void initState() {
    _tapDowns = List.generate(widget.texts.length, (_) => false);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TextGroup oldWidget) {
    _tapDowns = List.generate(widget.texts.length, (_) => false);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // inner TextSpan-s
    var spans = <TextSpan>[];
    for (var i = 0; i < widget.texts.length; i++) {
      var t = widget.texts[i];

      if (t is NormalGroupText) {
        spans.add(
          TextSpan(
            text: t.text,
            style: t.style,
          ),
        );
      } else if (t is LinkGroupText) {
        var textColor = !_tapDowns[i] ? t.normalColor : t.pressedColor;
        var textStyle = (!_tapDowns[i] ? t.normalStyle : t.pressedStyle) ??
            (!(t.showUnderline ?? true)
                ? TextStyle(
                    color: textColor,
                    decoration: TextDecoration.none,
                  )
                : TextStyle(
                    color: Colors.transparent,
                    decoration: TextDecoration.underline,
                    decorationColor: textColor ?? Colors.black, // colorized underline
                    shadows: [
                      Shadow(
                        offset: const Offset(0, -1), // text offset
                        color: textColor ?? Colors.black,
                      ),
                    ],
                  ));
        spans.add(
          TextSpan(
            text: t.text,
            style: textStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = t.onTap
              ..onTapDown = ((_) => mountedSetState(() => _tapDowns[i] = true))
              ..onTapUp = ((_) => mountedSetState(() => _tapDowns[i] = false))
              ..onTapCancel = (() => mountedSetState(() => _tapDowns[i] = false)),
          ),
        );
      } else if (t.textSpanBuilder != null) {
        // custom TextGroupItem with textSpanBuilder
        spans.add(
          t.textSpanBuilder!(t.text),
        );
      } else {
        // custom TextGroupItem without textSpanBuilder
        spans.add(
          TextSpan(text: t.text),
        );
      }
    }

    // outer TextSpan
    var textSpan = TextSpan(
      text: '',
      style: widget.style ?? DefaultTextStyle.of(context).style,
      children: spans..add(const TextSpan(text: ' ')), // final empty TextSpan
    );

    // RichText or SelectedText
    if (!(widget.selectable ?? false)) {
      return RichText(
        text: textSpan,
        // both
        maxLines: widget.maxLines,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        textScaleFactor: widget.textScaleFactor ?? 1.0,
        textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
        textHeightBehavior: widget.textHeightBehavior,
        // only
        softWrap: widget.softWrap ?? true,
        overflow: widget.overflow ?? TextOverflow.clip,
        locale: widget.locale,
      );
    } else {
      return SelectableText.rich(
        textSpan,
        // both
        maxLines: widget.maxLines,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        textScaleFactor: widget.textScaleFactor ?? 1.0,
        textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
        textHeightBehavior: widget.textHeightBehavior,
        // only
        focusNode: widget.focusNode,
        showCursor: widget.showCursor ?? false,
        autofocus: widget.autofocus ?? false,
        enableInteractiveSelection: widget.enableInteractiveSelection ?? true,
        toolbarOptions: widget.toolbarOptions ?? const ToolbarOptions(selectAll: true, copy: true),
        minLines: widget.minLines,
        cursorWidth: widget.cursorWidth ?? 2.0,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        dragStartBehavior: widget.dragStartBehavior ?? DragStartBehavior.start,
        // do not used => style, selectionControls, onTap, scrollPhysics, onSelectionChanged, semanticsLabel
      );
    }
  }
}
