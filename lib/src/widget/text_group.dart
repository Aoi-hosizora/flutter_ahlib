import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// An abstract text group item used for [TextGroup], which is inherited by builtin
/// [SpanItem], [PlainTextItem] and [LinkTextItem].
abstract class TextGroupItem {
  const TextGroupItem();

  /// Builds [InlineSpan] for [TextGroupItem], which must be implemented by the subclasses
  /// of [TextGroupItem].
  InlineSpan buildSpan(BuildContext context);
}

/// A kind of [TextGroupItem], which uses given [InlineSpan] (including [TextSpan] and
/// [WidgetSpan]) as [TextGroup]'s texts.
class SpanItem extends TextGroupItem {
  const SpanItem({
    required this.span,
  });

  /// The span content of this item.
  final InlineSpan span;

  /// Builds [InlineSpan] for [SpanItem].
  @override
  InlineSpan buildSpan(BuildContext context) => span;
}

/// A kind of [TextGroupItem], which wraps given plain text and style to [TextSpan], and
/// uses it as [TextGroup]'s texts.
class PlainTextItem extends TextGroupItem {
  const PlainTextItem({
    required this.text,
    this.style,
  });

  /// The text content of this item.
  final String text;

  /// The text style of this item.
  final TextStyle? style;

  /// Builds [InlineSpan], or said [TextSpan], for [PlainTextItem].
  @override
  InlineSpan buildSpan(BuildContext context) => TextSpan(
        text: text,
        style: style,
      );
}

/// A kind of [TextGroupItem], which wraps given text and link style to [TextSpan] or
/// [WidgetSpan], and uses it as [TextGroup]'s texts.
class LinkTextItem extends TextGroupItem {
  const LinkTextItem({
    required this.text,
    required this.onTap,
    this.basicStyle,
    this.normalColor,
    this.pressedColor,
    this.showUnderline = true,
    this.wrapperBuilder,
  })  : normalStyle = null,
        pressedStyle = null;

  const LinkTextItem.style({
    required this.text,
    required this.onTap,
    this.normalStyle,
    this.pressedStyle,
    this.wrapperBuilder,
  })  : basicStyle = null,
        normalColor = null,
        pressedColor = null,
        showUnderline = null;

  /// The link content of this item.
  final String text;

  /// The behavior when the link is pressed.
  final Function() onTap;

  /// The link basic style of this item. Note that this value will have no effect when
  /// [normalStyle] or [pressedStyle] is not null.
  final TextStyle? basicStyle;

  /// The link color when this item is not pressed. Note that this value will have no
  /// effect when [normalStyle] or [pressedStyle] is not null.
  final Color? normalColor;

  /// The link color when this item is pressed down. Note that this value will have no
  /// effect when [normalStyle] or [pressedStyle] is not null.
  final Color? pressedColor;

  /// The switcher to show link underline, defaults to true. Note that this value will
  /// have no effect when [normalStyle] or [pressedStyle] is not null.
  final bool? showUnderline;

  /// The text style when this item is not pressed.
  final TextStyle? normalStyle;

  /// The text style when this item is pressed down.
  final TextStyle? pressedStyle;

  /// The [WidgetSpan] wrapper builder. If this value is set, than returned [WidgetSpan]
  /// will be used as [TextGroup]'s texts.
  final WidgetSpan Function(BuildContext context, Widget t, bool tapped)? wrapperBuilder;

  /// Builds [InlineSpan] for [LinkTextItem], but actually this function is just a
  /// dummy. [buildSpanForLinkText] should be used for building [InlineSpan].
  @override
  InlineSpan buildSpan(BuildContext context) => const TextSpan();

  /// Builds [InlineSpan], or said [TextSpan] or [WidgetSpan], for [LinkTextItem].
  InlineSpan buildSpanForLinkText(BuildContext context, bool Function() tappedGetter, Function(bool) tappedSetter) {
    TextStyle? textStyle;
    if (normalStyle != null || pressedStyle != null) {
      textStyle = !tappedGetter() ? normalStyle : pressedStyle;
    } else {
      var textColor = !tappedGetter() ? normalColor : pressedColor;
      textStyle = basicStyle ?? const TextStyle();
      textStyle = !(showUnderline ?? true)
          ? textStyle.copyWith(
              color: textColor,
              decoration: TextDecoration.none,
            )
          : textStyle.copyWith(
              color: Colors.transparent,
              decoration: TextDecoration.underline,
              decorationColor: textColor ?? Colors.black, // colorized underline
              shadows: [
                Shadow(
                  offset: const Offset(0, -1), // text offset
                  color: textColor ?? Colors.black,
                ),
              ],
            );
    }
    var recognizer = TapGestureRecognizer()
      ..onTap = onTap
      ..onTapDown = ((_) => tappedSetter(true))
      ..onTapUp = ((_) => tappedSetter(false))
      ..onTapCancel = (() => tappedSetter(false));

    if (wrapperBuilder == null) {
      return TextSpan(
        text: text,
        style: textStyle,
        recognizer: recognizer,
      );
    }
    return wrapperBuilder!(
      context,
      GestureDetector(
        child: Text(text, style: textStyle),
        onTap: recognizer.onTap,
        onTapDown: recognizer.onTapDown,
        onTapUp: recognizer.onTapUp,
        onTapCancel: recognizer.onTapCancel,
      ),
      tappedGetter(),
    );
  }
}

/// A [RichText] or [SelectableText] wrapper with states, including a list of [TextGroupItem]
/// child, which can be [SpanItem], [PlainTextItem] or [LinkTextItem].
class TextGroup extends StatefulWidget {
  /// Creates a [TextGroup] which wraps [RichText] to show [TextGroupItem] list.
  const TextGroup({
    Key? key,
    required this.texts,
    required this.selectable,
    this.style,
    this.outerSpanBuilder,
    // both
    this.maxLines,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor,
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

  /// Creates a [TextGroup] which wraps [RichText] to show [TextGroupItem] list.
  const TextGroup.normal({
    Key? key,
    required this.texts,
    this.style,
    this.outerSpanBuilder,
    // both
    this.maxLines,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    // RichText only
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.locale,
  })  : assert(texts.length > 0),
        assert(maxLines == null || maxLines > 0),
        selectable = false,
        // SelectableText only
        focusNode = null,
        showCursor = null,
        autofocus = null,
        enableInteractiveSelection = null,
        toolbarOptions = null,
        cursorWidth = null,
        cursorHeight = null,
        cursorRadius = null,
        cursorColor = null,
        dragStartBehavior = null,
        minLines = null,
        super(key: key);

  /// Creates a [TextGroup] which wraps [SelectableText] to show [TextGroupItem] list.
  const TextGroup.selectable({
    Key? key,
    required this.texts,
    this.style,
    this.outerSpanBuilder,
    // both
    this.maxLines,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
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
        selectable = true,
        // RichText only
        softWrap = null,
        overflow = null,
        locale = null,
        super(key: key);

  /// The children of this widget.
  final List<TextGroupItem> texts;

  /// The switcher represents this widget can be selectable, defaults to false.
  final bool? selectable;

  /// The text style of the outer [TextSpan].
  final TextStyle? style;

  /// The outer [TextSpan] builder， defaults to add empty [TextSpan] span list.
  final TextSpan Function(BuildContext context, List<InlineSpan> spans, TextStyle? style)? outerSpanBuilder;

  // both

  /// The max lines of [RichText] and [SelectableText].
  final int? maxLines;

  /// The strutStyle of [RichText] and [SelectableText].
  final StrutStyle? strutStyle;

  /// The textAlign of [RichText] and [SelectableText], defaults to [TextAlign.start].
  final TextAlign? textAlign;

  /// The textDirection of [RichText] and [SelectableText].
  final TextDirection? textDirection;

  /// The textScaleFactor of [RichText] and [SelectableText], defaults to [MediaQuery.of(context).textScaleFactor].
  final double? textScaleFactor;

  /// The textWidthBasis of [RichText] and [SelectableText], defaults to
  /// [TextWidthBasis.parent].
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

  /// The enableInteractiveSelection of [SelectableText] when [selectable] is true, defaults
  /// to true.
  final bool? enableInteractiveSelection;

  /// The toolbarOptions of [SelectableText] when [selectable] is true, defaults to
  /// [ToolbarOptions(selectAll: true, copy: true)].
  final ToolbarOptions? toolbarOptions;

  /// The cursorWidth of [SelectableText] when [selectable] is true, defaults to 2.0.
  final double? cursorWidth;

  /// The cursorHeight of [SelectableText] when [selectable] is true.
  final double? cursorHeight;

  /// The cursorRadius of [SelectableText] when [selectable] is true.
  final Radius? cursorRadius;

  /// The cursorColor of [SelectableText] when [selectable] is true.
  final Color? cursorColor;

  /// The dragStartBehavior of [SelectableText] when [selectable] is true, defaults to
  /// [DragStartBehavior.start].
  final DragStartBehavior? dragStartBehavior;

  /// The minLines of [SelectableText] when [selectable] is true.
  final int? minLines;

  @override
  _TextGroupState createState() => _TextGroupState();
}

class _TextGroupState extends State<TextGroup> {
  var _tapped = <bool>[]; // tap down indicator list

  @override
  void initState() {
    super.initState();
    _tapped = List.generate(widget.texts.length, (_) => false);
  }

  @override
  void didUpdateWidget(covariant TextGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tapped = List.generate(widget.texts.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    // inner InlineSpan-s
    var spans = <InlineSpan>[];
    for (var i = 0; i < widget.texts.length; i++) {
      var t = widget.texts[i];
      if (t is SpanItem) {
        spans.add(t.buildSpan(context));
      } else if (t is PlainTextItem) {
        spans.add(t.buildSpan(context));
      } else if (t is LinkTextItem) {
        spans.add(t.buildSpanForLinkText(context, () => _tapped[i], (t) {
          _tapped[i] = t;
          if (mounted) setState(() {});
        }));
      } else {
        spans.add(t.buildSpan(context));
      }
    }

    // outer TextSpan
    var textSpan = widget.outerSpanBuilder?.call(context, spans, widget.style) ??
        TextSpan(
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
        textScaleFactor: widget.textScaleFactor ?? MediaQuery.of(context).textScaleFactor,
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
        textScaleFactor: widget.textScaleFactor ?? MediaQuery.of(context).textScaleFactor,
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
