import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/flutter_extensions.dart';

/// An abstract text group item that represents [TextGroup]'s children, which must implement the [text], [style],
/// inherited by [NormalGroupText] and [LinkGroupText].
abstract class TextGroupChild {
  const TextGroupChild();

  /// The content of this item.
  String get text;

  /// The text style of this item.
  TextStyle get style;

  /// The boolean represents whether this child is a [LinkGroupText].
  bool get isLink => false;
}

/// A [TextGroupChild] that represents a normal text.
class NormalGroupText extends TextGroupChild {
  const NormalGroupText({
    @required this.text,
    this.style,
  })  : assert(text != null),
        super();

  /// The content of this item.
  final String text;

  /// The text style of this item.
  final TextStyle style;
}

/// A [TextGroupChild] that represents a linked text.
class LinkGroupText extends TextGroupChild {
  const LinkGroupText({
    @required this.text,
    this.style,
    this.pressedColor,
    @required this.onTap,
  })  : assert(text != null),
        assert(onTap != null),
        super();

  /// The content of this item.
  final String text;

  /// The text style of this item.
  final TextStyle style;

  /// The link color when this item pressed. If [TextGroup.linkPressedColor] and this property are both set, [TextGroup] will use this value first.
  final Color pressedColor;

  /// The behavior when the link is pressed.
  final Function() onTap;

  /// The boolean represents whether this child is a [LinkGroupText].
  bool get isLink => true;
}

/// A [RichText] or [SelectableText] wrapped widget with state, including a list of child in [TextGroupChild] type, which can be
/// [NormalGroupText] and [LinkGroupText].
class TextGroup extends StatefulWidget {
  const TextGroup({
    Key key,
    @required this.texts,
    this.selectable = false,
    this.style,
    this.linkPressedColor,
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
        super(key: key);

  /// The children of this widget.
  final List<TextGroupChild> texts;

  /// The switcher represents this widget can be selectable.
  final bool selectable;

  /// The text style of the outer [TextSpan].
  final TextStyle style;

  /// The text color when the link pressed, [TextGroup] will use [LinkGroupText.pressedColor] first.
  final Color linkPressedColor;

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

      if (!t.isLink) {
        // NormalGroupText
        var text = t as NormalGroupText;
        spans.add(
          TextSpan(text: text.text, style: text.style),
        );
      } else {
        // LinkGroupText
        var link = t as LinkGroupText;
        spans.add(
          TextSpan(
            text: t.text,
            style: (t.style ?? TextStyle()).copyWith(
              color: !_tapDowns[i] ? null : link.pressedColor ?? widget.linkPressedColor,
              decorationColor: !_tapDowns[i] ? null : link.pressedColor ?? widget.linkPressedColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = link.onTap
              ..onTapDown = ((_) => mountedSetState(() => _tapDowns[i] = true))
              ..onTapUp = ((_) => mountedSetState(() => _tapDowns[i] = false))
              ..onTapCancel = (() => mountedSetState(() => _tapDowns[i] = false)),
          ),
        );
      }
    }

    // outer textSpan
    var textSpan = TextSpan(
      text: '',
      style: widget.style ?? DefaultTextStyle.of(context),
      children: spans..add(TextSpan(text: ' ')),
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
        // showCursor: widget.showCursor,
        // autofocus: widget.autofocus,
        // minLines: widget.minLines,
        // enableInteractiveSelection: widget.enableInteractiveSelection,
        // selectionControls: widget.selectionControls,
        // onTap: widget.onTap,
        // scrollPhysics: widget.scrollPhysics,
        // onSelectionChanged: widget.onSelectionChanged,
      );
    }
  }
}
