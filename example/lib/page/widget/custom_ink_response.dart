import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class CustomInkResponsePage extends StatefulWidget {
  const CustomInkResponsePage({Key? key}) : super(key: key);

  @override
  State<CustomInkResponsePage> createState() => _CustomInkResponsePageState();
}

class _CustomInkResponsePageState extends State<CustomInkResponsePage> {
  final _key = GlobalKey();
  final _helper = TableCellHelper(9, 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _helper.searchHighestTableCells();
      if (mounted) setState(() {});
    });
  }

  // 1 ink feature & ink highlight
  var rippleLongDuration = true;
  var rippleNoFadeOut = true;
  var highlightNoFadeOut = true;
  var rippleZeroRadius = false;

  // 2 ink response
  var showHighlightEffect = true;
  var showRippleEffect = true;
  var containedInkWell = false;
  var rectangleHighlight = false;

  // 3 custom ink response
  var defaultCanvasCenter = false;
  var defaultRadius = false;
  var defaultRect = false;

  Widget _checkBox(String title, bool Function() getter, void Function(bool) setter) {
    return CheckboxListTile(
      title: Text(title),
      value: getter(),
      onChanged: (v) {
        setter(v ?? false);
        if (mounted) setState(() {});
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    var tableWidth = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.horizontal - 20;
    var padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
    Duration Function(HighlightType)? highlightFadeDuration;
    var rippleSetting = CustomInkRippleSetting.preferredSetting;
    if (rippleLongDuration) {
      rippleSetting = rippleSetting.copyWith(
        unconfirmedRippleDuration: const Duration(milliseconds: 1500),
        confirmedRippleDuration: const Duration(milliseconds: 1500),
      );
    }
    if (rippleNoFadeOut) {
      rippleSetting = rippleSetting.copyWith(
        canceledFadeOutDuration: const Duration(milliseconds: 0),
        confirmedFadeOutDuration: const Duration(milliseconds: 0),
        confirmedFadeOutInterval: const Duration(milliseconds: 0),
        confirmedFadeOutWaitForForwarding: false,
      );
    }
    if (rippleZeroRadius) {
      rippleSetting = rippleSetting.copyWith(
        radiusAnimationBeginFn: (r) => 0,
        radiusAnimationEndFn: (r) => r,
      );
    }
    if (highlightNoFadeOut) {
      highlightFadeDuration = (_) => const Duration(milliseconds: 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomInkResponse Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _checkBox('rippleLongDuration', () => rippleLongDuration, (v) => rippleLongDuration = v),
          _checkBox('rippleNoFadeOut', () => rippleNoFadeOut, (v) => rippleNoFadeOut = v),
          _checkBox('highlightNoFadeOut', () => highlightNoFadeOut, (v) => highlightNoFadeOut = v),
          _checkBox('rippleZeroRadius', () => rippleZeroRadius, (v) => rippleZeroRadius = v),
          const Divider(),
          _checkBox('showHighlightEffect', () => showHighlightEffect, (v) => showHighlightEffect = v),
          _checkBox('showRippleEffect', () => showRippleEffect, (v) => showRippleEffect = v),
          _checkBox('containedInkWell', () => containedInkWell, (v) => containedInkWell = v),
          _checkBox('rectangleHighlight', () => rectangleHighlight, (v) => rectangleHighlight = v),
          const Divider(),
          _checkBox('defaultCanvasCenter', () => defaultCanvasCenter, (v) => defaultCanvasCenter = v),
          _checkBox('defaultRadius', () => defaultRadius, (v) => defaultRadius = v),
          _checkBox('defaultRect', () => defaultRect, (v) => defaultRect = v),
          const Divider(),
          Table(
            key: _key,
            columnWidths: const {0: FractionColumnWidth(0.3)},
            border: const TableBorder(
              horizontalInside: BorderSide(width: 1, color: Colors.grey),
            ),
            children: [
              TableRow(
                children: [
                  Padding(padding: padding, child: const Text('Key', style: TextStyle(color: Colors.grey))),
                  Padding(padding: padding, child: const Text('Value', style: TextStyle(color: Colors.grey))),
                ],
              ),
              for (int i = 0; i < 9; i++)
                TableRow(
                  children: [
                    TableCell(
                      key: _helper.getCellKey(i, 0),
                      verticalAlignment: _helper.determineAlignment(i, 0, TableCellVerticalAlignment.top),
                      child: CustomInkResponse(
                        child: Padding(
                          padding: padding,
                          child: Text(
                            i % 9 == 0 || i % 9 == 1 || i % 9 == 2
                                ? 'ABC'
                                : i % 9 == 3 || i % 9 == 4 || i % 9 == 5
                                    ? 'ABC\nDEF'
                                    : 'ABC\nDEF\nGHI',
                          ),
                        ),
                        onTap: () {
                          printLog('onTap, tableWidth = $tableWidth <-> ${_key.currentContext?.size?.width}');
                        },
                        containedInkWell: containedInkWell,
                        highlightShape: rectangleHighlight ? BoxShape.rectangle : BoxShape.circle,
                        highlightColor: showHighlightEffect ? null : Colors.transparent,
                        splashColor: showRippleEffect ? null : Colors.transparent,
                        highlightFadeDuration: highlightFadeDuration,
                        splashFactory: CustomInkRippleFactory(
                          setting: rippleSetting.copyWith(
                            radiusCanvasCenterFn: defaultCanvasCenter ? null : (box, _) => Offset(tableWidth / 2, box.size.height / 2),
                          ),
                        ),
                        getRadius: (box) {
                          printLog('getRadius, box size = ${box.size}');
                          return defaultRadius ? null : math.sqrt(tableWidth * tableWidth + box.size.height * box.size.height) / 2;
                        },
                        getRect: (box) {
                          final rect = getTableRowRect(box);
                          // printLog('getRect, row rect size = ${rect.size}'); // ???
                          // The following assertion was thrown while dispatching notifications for ValueNotifier<String>:
                          // Build scheduled during frame.
                          // While the widget tree was being built, laid out, and painted, a new frame was scheduled to rebuild
                          // the widget tree.
                          return defaultRect ? null : rect;
                        },
                      ),
                    ),
                    TableCell(
                      key: _helper.getCellKey(i, 1),
                      verticalAlignment: _helper.determineAlignment(i, 1, TableCellVerticalAlignment.top),
                      child: CustomInkResponse(
                        child: Padding(
                          padding: padding,
                          child: Text(
                            i % 9 == 0 || i % 9 == 3 || i % 9 == 6
                                ? 'abcdefg'
                                : i % 9 == 1 || i % 9 == 4 || i % 9 == 7
                                    ? 'abcdefg\nhijklmn'
                                    : 'abcdefg\nhijklmn\nopqrstu',
                          ),
                        ),
                        onTap: () {
                          printLog('onTap, tableWidth = $tableWidth <-> ${_key.currentContext?.size?.width}');
                        },
                        containedInkWell: containedInkWell,
                        highlightShape: rectangleHighlight ? BoxShape.rectangle : BoxShape.circle,
                        highlightColor: showHighlightEffect ? null : Colors.transparent,
                        splashColor: showRippleEffect ? null : Colors.transparent,
                        highlightFadeDuration: highlightFadeDuration,
                        splashFactory: CustomInkRippleFactory(
                          setting: rippleSetting.copyWith(
                            radiusCanvasCenterFn: defaultCanvasCenter ? null : (box, _) => Offset(tableWidth / 2 - tableWidth * 0.3, box.size.height / 2),
                          ),
                        ),
                        getRadius: (box) {
                          printLog('getRadius, box size = ${box.size}');
                          return defaultRadius ? null : math.sqrt(tableWidth * tableWidth + box.size.height * box.size.height) / 2;
                        },
                        getRect: (box) {
                          final rect = getTableRowRect(box);
                          // printLog('getRect, row rect size = ${rect.size}');
                          return defaultRect ? null : rect;
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
