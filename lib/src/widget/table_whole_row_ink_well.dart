import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/custom_ink_feature.dart';
import 'package:flutter_ahlib/src/widget/custom_ink_response.dart';
import 'package:flutter_ahlib/src/widget/new_button_style.dart';

/// A special ink well based on [CustomInkResponse], which will splash to the whole row
/// when tap [TableCell], is used in [TableCell] and to replace [TableRowInkWell].
class TableWholeRowInkWell extends CustomInkResponse {
  TableWholeRowInkWell({
    Key? key,
    required Widget child,
    EdgeInsets? padding,
    GestureTapCallback? onTap,
    GestureTapDownCallback? onTapDown,
    GestureTapCallback? onTapCancel,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    ValueChanged<bool>? onHighlightChanged,
    ValueChanged<bool>? onHover,
    MouseCursor? mouseCursor,
    bool containedInkWell = true,
    BoxShape highlightShape = BoxShape.rectangle,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    MaterialStateProperty<Color?>? overlayColor,
    Color? splashColor,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    ValueChanged<bool>? onFocusChange,
    bool autofocus = false,
    Duration? Function(HighlightType type)? highlightFadeDuration,
    // <<<
    CustomInkRippleSetting? rippleSetting,
    required double tableWidth,
    required double accumulativeWidthRatio,
  }) : super(
          key: key,
          child: padding == null
              ? child
              : Padding(
                  padding: padding,
                  child: child,
                ),
          onTap: onTap,
          onTapDown: onTapDown,
          onTapCancel: onTapCancel,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onHighlightChanged: onHighlightChanged,
          onHover: onHover,
          mouseCursor: mouseCursor,
          containedInkWell: containedInkWell,
          highlightShape: highlightShape,
          borderRadius: borderRadius,
          customBorder: customBorder,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          overlayColor: overlayColor,
          splashColor: splashColor,
          enableFeedback: enableFeedback,
          excludeFromSemantics: excludeFromSemantics,
          onFocusChange: onFocusChange,
          autofocus: autofocus,
          focusNode: focusNode,
          canRequestFocus: canRequestFocus,
          highlightFadeDuration: highlightFadeDuration,
          // <<<
          splashFactory: CustomInkRippleFactory(
            setting: (rippleSetting ?? CustomInkRippleSetting.defaultSetting).copyWith(
              radiusCanvasCenterFn: (box, _) => Offset(tableWidth / 2 - tableWidth * accumulativeWidthRatio, box.size.height / 2),
            ),
          ),
          getRadius: (box) => calcDiagonal(tableWidth, box.size.height) / 2,
          getRect: (box) => getTableRowRect(box),
        );

  /// The preferred [TableWholeRowInkWell] constructor by Aoi-hosizora :)
  TableWholeRowInkWell.preferred({
    Key? key,
    required Widget child,
    EdgeInsets? padding,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    required double tableWidth,
    required double accumulativeWidthRatio,
  }) : this(
          key: key,
          child: child,
          padding: padding,
          onTap: onTap,
          tableWidth: tableWidth,
          accumulativeWidthRatio: accumulativeWidthRatio,
          rippleSetting: CustomInkRippleSetting.preferredSetting,
          highlightColor: Colors.transparent,
          splashColor: Colors.black.withOpacity(preferredSplashColorOpacityForTable), // 0.16
        );
}

/// A helper class for [TableCell], and is used to decide which [TableCell] to fill
/// the whole [TableRow] in vertical direction, which is not implemented by flutter.
///
/// Example:
/// ```
/// // in State class
/// final _helper = TableCellHelper(9, 2); // 9x2
///
/// // 1. in initState and didUpdateWidget method
/// // 2. or in build method
/// // 3. or use StatefulWidgetWithCallback with postFrameCallbackForXXX
/// WidgetsBinding.instance!.addPostFrameCallback((_) {
///   if (_helper.searchForHighestCells()) {
///     if (mounted) setState(() {});
///   }
/// });
///
/// // Table constructor in build method
/// Table(
///   children: [
///     for (int i = 0; i &lt; 9; i++)
///       TableRow(
///         children: [
///           for (int j = 0; j &lt; 2; j++)
///             TableCell(
///               key: _helper.getCellKey(i, j)
///               verticalAlignment: _helper.determineCellAlignment(i, j, TableCellVerticalAlignment.top),
///               child: Text('item ($i, $j)'),
///             ),
///         ],
///       ),
///   ],
/// )
///
/// // for update Table content
/// _helper.reset(newRow, newHeight);
/// if (mounted) setState(() {});
/// ```
class TableCellHelper {
  TableCellHelper(this._rows, this._columns)
      : assert(_rows >= 0 && _columns >= 0),
        _keys = List.generate(_rows, (_) => List.generate(_columns, (_) => GlobalKey())),
        _highests = <int>[];

  int _rows;
  int _columns;
  List<List<GlobalKey>> _keys;
  List<int> _highests;

  /// Resets the [TableCellHelper] with new rows and columns, which should be used
  /// when [TableRow] count or [TableCell] content was changed, following [setState].
  void reset(int rows, int columns) {
    assert(_rows >= 0 && _columns >= 0);
    _rows = rows;
    _columns = columns;
    _keys = List.generate(_rows, (_) => List.generate(_columns, (_) => GlobalKey()));
    _highests = <int>[];
  }

  /// Returns the [TableCell]'s [GlobalKey] for given index.
  GlobalKey getCellKey(int i, int j) {
    assert(_rows > 0 && _columns > 0);
    assert(i < _rows && j < _columns);
    return _keys[i][j];
  }

  /// Determines the [TableCell]'s [TableCellVerticalAlignment] with given index.
  TableCellVerticalAlignment? determineCellAlignment(int i, int j, [TableCellVerticalAlignment? initialValue]) {
    assert(_rows > 0 && _columns > 0);
    assert(i < _rows && j < _columns);
    if (_highests.isEmpty) {
      return initialValue;
    }
    if (_highests[i] == j) {
      return TableCellVerticalAlignment.top; // highest -> top
    }
    return TableCellVerticalAlignment.fill; // others -> fill
  }

  /// Returns true if [searchForHighestCells] has already been invoked to search.
  bool hasSearched() => _highests.isNotEmpty;

  /// Searches the highest [TableCell] in multiple [TableRow] and this function
  /// returns true if the highests list is regenerated.
  bool searchForHighestCells() {
    if (_rows == 0 || _columns == 0) {
      return false; // there is no cell
    }
    if (_highests.isNotEmpty) {
      return false; // search has been already done
    }

    var newHighests = <int>[];
    for (int i = 0; i < _rows; i++) {
      var max = 0, maxHeight = -1.0;
      for (int j = 0; j < _columns; j++) {
        var curHeight = _keys[i][j].currentContext?.size?.height;
        if (curHeight == null) {
          return false; // there are some rendered cells
        }
        if (curHeight > maxHeight) {
          max = j;
          maxHeight = curHeight;
        }
      }
      newHighests.add(max);
    }

    _highests = newHighests;
    return true; // highests list is regenerated
  }
}

/// Returns the [Rect] of [TableRow] with given [RenderBox]. This is a helper
/// function for [CustomInkResponse.getRect], which is used to fix ink effect
/// bug of [TableRowInkWell].
Rect getTableRowRect(RenderBox referenceBox) {
  const helper = TableRowInkWell();
  var callback = helper.getRectCallback(referenceBox);
  return callback();
}

/// This function is the same as [math.sqrt].
num calcSqrt(num n) {
  return math.sqrt(n);
}

/// This function is used to calculate diagonal of given [Rect]'s width and height.
num calcDiagonal(num width, num height) {
  return math.sqrt(width * width + height * height);
}
