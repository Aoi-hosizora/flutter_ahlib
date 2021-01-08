import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/flutter_extensions.dart';

/// [_TextGroupChild] is an abstract of the type of [TextGroup]'s children,
/// which must implement the [text], [style], including [NormalGroupText] and [LinkGroupText].
abstract class _TextGroupChild {
  const _TextGroupChild();

  /// Represents the content to show.
  String get text;

  /// Represents the text style to show.
  TextStyle get style;

  /// Represents which this child is a [LinkGroupText].
  bool get isLink => false;

// bool get isXXX => false;
}

/// [NormalGroupText] is a kind of [TextGroup]'s children, represents a normal text,
/// including [text] and [style].
class NormalGroupText extends _TextGroupChild {
  const NormalGroupText({
    @required this.text,
    this.style,
  })  : assert(text != null),
        super();

  /// Represents the content to show.
  final String text;

  /// Represents the text style to show.
  final TextStyle style;
}

/// [LinkGroupText] is a kind of [TextGroup]'s children, represents a text with link,
/// including [text], [style], [pressedColor] and [onTap].
class LinkGroupText extends _TextGroupChild {
  const LinkGroupText({
    @required this.text,
    this.style,
    this.pressedColor,
    @required this.onTap,
  })  : assert(text != null),
        assert(onTap != null),
        super();

  /// Represents the content to show.
  final String text;

  /// Represents the text style to show.
  final TextStyle style;

  /// Represents the link color when pressed. When the [TextGroup.linkPressedColor] and
  /// this property are set at the same time, [TextGroup] will use this value.
  final Color pressedColor;

  /// Represents the behavior when the link are pressed.
  final Function() onTap;

  /// Represents this is a [LinkGroupText].
  bool get isLink => true;
}

/// [TextGroup] is a [RichText] or [SelectableText] wrapped widget with state, including a list of
/// child with [_TextGroupChild] type, which including [NormalGroupText] and [LinkGroupText].
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

  /// Represents the children of [TextGroup].
  final List<_TextGroupChild> texts;

  /// Represents this [RichText] can be selected or not.
  final bool selectable;

  /// Represents the text style of the upper [TextSpan].
  final TextStyle style;

  /// Represents the text color when link pressed, [TextGroup] will use the value of
  /// [LinkGroupText.pressedColor] first.
  final Color linkPressedColor;

  // RichText and SelectableText

  /// Represents the max lines for text.
  final int maxLines;

  /// The strutStyle for [RichText] and [SelectableText].
  final StrutStyle strutStyle;

  /// The textAlign for [RichText] and [SelectableText].
  final TextAlign textAlign;

  /// The textDirection for [RichText] and [SelectableText].
  final TextDirection textDirection;

  /// The textScaleFactor for [RichText] and [SelectableText].
  final double textScaleFactor;

  /// The textWidthBasis for [RichText] and [SelectableText].
  final TextWidthBasis textWidthBasis;

  /// The textHeightBehavior for [RichText] and [SelectableText].
  final TextHeightBehavior textHeightBehavior;

  // RichText

  /// The softWrap for [RichText] when [selectable] is false.
  final bool softWrap;

  /// The overflow for [RichText] when [selectable] is false.
  final TextOverflow overflow;

  // SelectableText

  /// The focusNode for [SelectableText] when [selectable] is true.
  final FocusNode focusNode;

  /// The toolbarOptions for [SelectableText] when [selectable] is true.
  final ToolbarOptions toolbarOptions;

  /// The cursorWidth for [SelectableText] when [selectable] is true.
  final double cursorWidth;

  /// The cursorHeight for [SelectableText] when [selectable] is true.
  final double cursorHeight;

  /// The cursorRadius for [SelectableText] when [selectable] is true.
  final Radius cursorRadius;

  /// The cursorColor for [SelectableText] when [selectable] is true.
  final Color cursorColor;

  /// The dragStartBehavior for [SelectableText] when [selectable] is true.
  final DragStartBehavior dragStartBehavior;

  @override
  _TextGroupState createState() => _TextGroupState();
}

class _TextGroupState extends State<TextGroup> {
  /// The tap down indicators list.
  var _tapDowns = <bool>[];

  @override
  void initState() {
    _tapDowns = List.generate(widget.texts.length, (_) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        // <<<
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
        // <<<
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
