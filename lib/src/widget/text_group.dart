import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/flutter_extension.dart';

/// An abstract text group item that represents [TextGroup]'s children, inherited by [NormalGroupText] and [LinkGroupText].
abstract class TextGroupItem {
  const TextGroupItem();

  /// The content of this item.
  String get text;
}

/// A [TextGroupItem] that represents a normal text. This is not a [Widget], but just a data class to store options and used in [TextGroup].
class NormalGroupText extends TextGroupItem {
  const NormalGroupText({
    @required this.text,
    this.style,
  })  : assert(text != null),
        super();

  /// The content of this item.
  @override
  final String text;

  /// The text style of this item.
  final TextStyle style;
}

/// A [TextGroupItem] that represents a linked text. This is not a [Widget], but just a data class to store options and used in [TextGroup].
class LinkGroupText extends TextGroupItem {
  const LinkGroupText({
    @required this.text,
    this.styleFn,
    this.normalColor,
    this.pressedColor,
    this.showUnderline = true,
    @required this.onTap,
  })  : assert(text != null),
        assert(showUnderline != null),
        assert(onTap != null),
        super();

  /// The content of this item.
  @override
  final String text;

  /// The text style function of this item.
  final TextStyle Function(bool pressed) styleFn;

  /// The link color when this item not pressed.
  final Color normalColor;

  /// The link color when this item pressed.
  final Color pressedColor;

  /// The switcher to show link underline.
  final bool showUnderline;

  /// The behavior when the link is pressed.
  final Function() onTap;
}

/// A [RichText] or [SelectableText] wrapped widget with state, including a list of child in [TextGroupItem] type, which can be
/// [NormalGroupText] and [LinkGroupText].
class TextGroup extends StatefulWidget {
  const TextGroup({
    Key key,
    @required this.texts,
    this.selectable = false,
    this.style,
    // RichText and SelectableText
    this.maxLines,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor = 1.0,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    // RichText
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    // SelectableText
    this.focusNode,
    this.toolbarOptions,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.minLines,
  })  : assert(texts != null && texts.length > 0),
        assert(selectable != null),
        // RichText and SelectableText
        assert(maxLines == null || maxLines > 0),
        assert(textAlign != null),
        assert(textScaleFactor != null),
        assert(textWidthBasis != null),
        // RichText
        assert(softWrap != null),
        assert(overflow != null),
        // SelectableText
        assert(dragStartBehavior != null),
        assert(minLines == null || minLines > 0),
        super(key: key);

  /// The children of this widget.
  final List<TextGroupItem> texts;

  /// The switcher represents this widget can be selectable.
  final bool selectable;

  /// The text style of the outer [TextSpan].
  final TextStyle style;

  // RichText and SelectableText

  /// The max lines of [RichText] and [SelectableText].
  final int maxLines;

  /// The strutStyle of [RichText] and [SelectableText].
  final StrutStyle strutStyle;

  /// The textAlign of [RichText] and [SelectableText].
  final TextAlign textAlign;

  /// The textDirection of [RichText] and [SelectableText].
  final TextDirection textDirection;

  /// The textScaleFactor of [RichText] and [SelectableText].
  final double textScaleFactor;

  /// The textWidthBasis of [RichText] and [SelectableText].
  final TextWidthBasis textWidthBasis;

  /// The textHeightBehavior of [RichText] and [SelectableText].
  final TextHeightBehavior textHeightBehavior;

  // RichText

  /// The softWrap of [RichText] when [selectable] is false.
  final bool softWrap;

  /// The overflow of [RichText] when [selectable] is false.
  final TextOverflow overflow;

  // SelectableText

  /// The focusNode of [SelectableText] when [selectable] is true.
  final FocusNode focusNode;

  /// The toolbarOptions of [SelectableText] when [selectable] is true.
  final ToolbarOptions toolbarOptions;

  /// The cursorWidth of [SelectableText] when [selectable] is true.
  final double cursorWidth;

  /// The cursorHeight of [SelectableText] when [selectable] is true.
  final double cursorHeight;

  /// The cursorRadius of [SelectableText] when [selectable] is true.
  final Radius cursorRadius;

  /// The cursorColor of [SelectableText] when [selectable] is true.
  final Color cursorColor;

  /// The dragStartBehavior of [SelectableText] when [selectable] is true.
  final DragStartBehavior dragStartBehavior;

  /// The minLines of [SelectableText] when [selectable] is true.
  final int minLines;

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
  Widget build(BuildContext context) {
    // inner textSpan-s
    var spans = <TextSpan>[];
    for (var i = 0; i < widget.texts.length; i++) {
      var t = widget.texts[i];
      assert(t != null);

      if (t is NormalGroupText) {
        spans.add(
          TextSpan(text: t.text, style: t.style),
        );
      } else if (t is LinkGroupText) {
        var textColor = !_tapDowns[i] ? t.normalColor : t.pressedColor;
        var textStyle = t.styleFn?.call(_tapDowns[i]) ??
            (!t.showUnderline
                ? TextStyle(color: textColor, decoration: TextDecoration.none)
                : TextStyle(
                    color: Colors.transparent,
                    shadows: [Shadow(color: textColor ?? Colors.black, offset: Offset(0, -1))], // offset -1
                    decoration: TextDecoration.underline,
                    decorationColor: textColor ?? Colors.black,
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
      } else {
        spans.add(
          TextSpan(text: t.text), // custom TextSpan
        ); // custom TextGroupItem
      }
    }

    // outer textSpan
    var textSpan = TextSpan(
      text: '',
      style: widget.style ?? DefaultTextStyle.of(context).style,
      children: spans..add(TextSpan(text: ' ')), // final textSpan
    );

    if (!widget.selectable) {
      // RichText
      return RichText(
        text: textSpan,
        // both
        maxLines: widget.maxLines,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        textScaleFactor: widget.textScaleFactor,
        textWidthBasis: widget.textWidthBasis,
        textHeightBehavior: widget.textHeightBehavior,
        // only
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        // locale: widget.locale,
      );
    } else {
      // SelectableText
      return SelectableText.rich(
        textSpan,
        // both
        maxLines: widget.maxLines,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        textScaleFactor: widget.textScaleFactor,
        textWidthBasis: widget.textWidthBasis,
        textHeightBehavior: widget.textHeightBehavior,
        // only
        focusNode: widget.focusNode,
        toolbarOptions: widget.toolbarOptions ?? ToolbarOptions(selectAll: true, copy: true),
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        dragStartBehavior: widget.dragStartBehavior,
        minLines: widget.minLines,
        // showCursor: widget.showCursor,
        // autofocus: widget.autofocus,
        // enableInteractiveSelection: widget.enableInteractiveSelection,
        // selectionControls: widget.selectionControls,
        // onTap: widget.onTap,
        // scrollPhysics: widget.scrollPhysics,
        // onSelectionChanged: widget.onSelectionChanged,
      );
    }
  }
}
