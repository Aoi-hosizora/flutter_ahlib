import 'package:flutter/material.dart';

/// A simplified [TextSelectionTheme] for the text selection configuration of [TextField]
/// or [TextFormField].
class TextSelectionConfig extends StatelessWidget {
  const TextSelectionConfig({
    Key? key,
    required this.child,
    this.cursorColor,
    this.selectionColor,
    this.selectionHandleColor,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// The color of the cursor in the text field.
  final Color? cursorColor;

  /// The background color of selected text.
  final Color? selectionColor;

  /// The color of the selection handle on the text field, which may have no effect in
  /// [TextSelectionTheme], please use [TextSelectionWithColorHandle] instead.
  final Color? selectionHandleColor;

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: cursorColor,
        selectionColor: selectionColor,
        selectionHandleColor: selectionHandleColor, // <<<
      ),
      child: child,
    );
  }
}

/// A [TextSelectionControls] which is inherited from [MaterialTextSelectionControls], is
/// used to change the color of the selection handle of [TextField] or [TextFormField] with
/// [handleColor], [TextField.selectionControls] or [TextFormField.selectionControls].
///
/// Visit https://github.com/flutter/flutter/issues/74890#issuecomment-901169865 for more
/// details.
class TextSelectionWithColorHandle extends MaterialTextSelectionControls {
  TextSelectionWithColorHandle(this.handleColor) : super();

  /// The color of the selection handle on the text field.
  final Color handleColor;

  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textHeight, [VoidCallback? onTap, double? startGlyphHeight, double? endGlyphHeight]) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionHandleColor: handleColor, // <<<
      ),
      child: Builder(
        // for Flutter 2
        // builder:  (context) => super.buildHandle(context, type, textHeight, onTap, startGlyphHeight, endGlyphHeight),
        // Note: actually, `startGlyphHeight` and `endGlyphHeight` are not be used, so pass them both as None.

        // for Flutter 3
        builder: (context) => super.buildHandle(context, type, textHeight, onTap),
      ),
    );
  }
}
