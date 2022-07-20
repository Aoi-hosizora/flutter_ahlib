import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class TableRelatedPage extends StatefulWidget {
  const TableRelatedPage({Key? key}) : super(key: key);

  @override
  State<TableRelatedPage> createState() => _TableRelatedPageState();
}

class _TableRelatedPageState extends State<TableRelatedPage> {
  final _key = GlobalKey();
  var rowCount = 9;
  final _helper = TableCellHelper(9, 3);

  // ink response
  var containedInkWell = true;
  var rectangleHighlight = true;
  var showHighlightEffect = true;
  var showRippleEffect = true;

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
    var rippleSetting = CustomInkRippleSetting.preferredSetting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TableRelated Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _checkBox('containedInkWell', () => containedInkWell, (v) => containedInkWell = v),
          _checkBox('rectangleHighlight', () => rectangleHighlight, (v) => rectangleHighlight = v),
          _checkBox('showHighlightEffect', () => showHighlightEffect, (v) => showHighlightEffect = v),
          _checkBox('showRippleEffect', () => showRippleEffect, (v) => showRippleEffect = v),
          const Divider(),
          StatefulWidgetWithCallback(
            // postFrameCallbackForInitState: () {
            //   printLog('postFrameCallbackForInitState');
            //   if (_helper.searchForHighestCells()) {
            //     printLog('postFrameCallbackForInitState setState');
            //     if (mounted) setState(() {});
            //   }
            // },
            // postFrameCallbackForDidUpdateWidget: () {
            //   printLog('postFrameCallbackForDidUpdateWidget');
            //   if (_helper.searchForHighestCells()) {
            //     printLog('postFrameCallbackForDidUpdateWidget setState');
            //     if (mounted) setState(() {});
            //   }
            // },
            postFrameCallbackForBuild: _helper.hasSearched()
                ? null
                : () {
                    printLog('postFrameCallbackForBuild');
                    if (_helper.searchForHighestCells()) {
                      printLog('postFrameCallbackForBuild setState');
                      if (mounted) setState(() {});
                    }
                  },
            child: Table(
              key: _key,
              columnWidths: const {
                0: FractionColumnWidth(0.08),
                1: FractionColumnWidth(0.3),
              },
              border: const TableBorder(
                horizontalInside: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid),
              ),
              children: [
                TableRow(
                  children: [
                    Padding(padding: padding, child: const Text('#', style: TextStyle(color: Colors.grey))),
                    Padding(padding: padding, child: const Text('Key', style: TextStyle(color: Colors.grey))),
                    Padding(padding: padding, child: const Text('Value', style: TextStyle(color: Colors.grey))),
                  ],
                ),
                for (int i = 0; i < rowCount; i++)
                  TableRow(
                    children: [
                      TableCell(
                        key: _helper.getCellKey(i, 0),
                        verticalAlignment: _helper.determineCellAlignment(i, 0, TableCellVerticalAlignment.middle), // middle -> top
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.grey),
                            ),
                          ),
                          child: CustomInkWell(
                            child: Padding(padding: padding.copyWith(left: 7), child: Text('$i', textAlign: TextAlign.center)),
                            onTap: () {},
                            splashFactory: CustomInkRippleFactory(
                              setting: CustomInkRippleSetting.preferredSetting.copyWith(
                                radiusCanvasCenterFn: (box, _) => Offset(tableWidth / 2, box.size.height / 2),
                              ),
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.black.withOpacity(preferredSplashColorOpacityForTable),
                            getRadius: (box) => calcDiagonal(tableWidth, box.size.height) / 2,
                            getRect: (box) => getTableRowRect(box),
                          ),
                        ),
                      ),
                      TableCell(
                        key: _helper.getCellKey(i, 1),
                        verticalAlignment: _helper.determineCellAlignment(i, 1, TableCellVerticalAlignment.top),
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
                          onTap: () => printLog('onTap, tableWidth = $tableWidth <-> ${_key.currentContext?.size?.width}'),
                          containedInkWell: containedInkWell,
                          highlightShape: rectangleHighlight ? BoxShape.rectangle : BoxShape.circle,
                          highlightColor: showHighlightEffect ? null : Colors.transparent,
                          splashColor: showRippleEffect ? null : Colors.transparent,
                          splashFactory: CustomInkRippleFactory(
                            setting: rippleSetting.copyWith(
                              radiusCanvasCenterFn: (box, _) => Offset(tableWidth / 2 - tableWidth * 0.08, box.size.height / 2),
                            ),
                          ),
                          getRadius: (box) => calcDiagonal(tableWidth, box.size.height) / 2,
                          getRect: (box) => getTableRowRect(box),
                        ),
                      ),
                      TableCell(
                        key: _helper.getCellKey(i, 2),
                        verticalAlignment: _helper.determineCellAlignment(i, 2, TableCellVerticalAlignment.top),
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
                          onTap: () => printLog('onTap, tableWidth = $tableWidth <-> ${_key.currentContext?.size?.width}'),
                          containedInkWell: containedInkWell,
                          highlightShape: rectangleHighlight ? BoxShape.rectangle : BoxShape.circle,
                          highlightColor: showHighlightEffect ? null : Colors.transparent,
                          splashColor: showRippleEffect ? null : Colors.transparent,
                          splashFactory: CustomInkRippleFactory(
                            setting: rippleSetting.copyWith(
                              radiusCanvasCenterFn: (box, _) => Offset(tableWidth / 2 - tableWidth * (0.08 + 0.3), box.size.height / 2),
                            ),
                          ),
                          getRadius: (box) => calcDiagonal(tableWidth, box.size.height) / 2,
                          getRect: (box) => getTableRowRect(box),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              rowCount += 9;
              _helper.reset(rowCount, 3);
              if (mounted) setState(() {});
            },
            heroTag: null,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              if (rowCount > 9) {
                rowCount -= 9;
                _helper.reset(rowCount, 3);
                if (mounted) setState(() {});
              }
            },
            heroTag: null,
          ),
        ],
      ),
    );
  }
}
