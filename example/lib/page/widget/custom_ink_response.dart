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

  // 1 ink feature & ink highlight
  var rippleLongDuration = false;
  var noFadeOutDuration = false;

  // 2 ink response
  var containedInkWell = true;
  var rectangleHighlight = true;
  var showHighlightEffect = true;
  var showRippleEffect = true;

  // 3 custom ink response
  var nullCanvasCenter = false;
  var nullRadius = false;
  var nullRect = false;

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
        unconfirmedRippleDuration: const Duration(milliseconds: 1000),
        confirmedRippleDuration: const Duration(milliseconds: 1000),
      );
    }
    if (noFadeOutDuration) {
      rippleSetting = rippleSetting.copyWith(
        canceledFadeOutDuration: const Duration(milliseconds: 0),
        confirmedFadeOutDuration: const Duration(milliseconds: 0),
        confirmedFadeOutInterval: const Duration(milliseconds: 0),
        confirmedFadeOutWaitForForwarding: false,
      );
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
          _checkBox('noFadeOutDuration', () => noFadeOutDuration, (v) => noFadeOutDuration = v),
          const Divider(),
          _checkBox('containedInkWell', () => containedInkWell, (v) => containedInkWell = v),
          _checkBox('rectangleHighlight', () => rectangleHighlight, (v) => rectangleHighlight = v),
          _checkBox('showHighlightEffect', () => showHighlightEffect, (v) => showHighlightEffect = v),
          _checkBox('showRippleEffect', () => showRippleEffect, (v) => showRippleEffect = v),
          const Divider(),
          _checkBox('nullCanvasCenter', () => nullCanvasCenter, (v) => nullCanvasCenter = v),
          _checkBox('nullRadius', () => nullRadius, (v) => nullRadius = v),
          _checkBox('nullRect', () => nullRect, (v) => nullRect = v),
          const Divider(),
          Table(
            key: _key,
            columnWidths: const {0: FractionColumnWidth(0.3)},
            border: const TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.grey)),
            children: [
              TableRow(
                children: [
                  Padding(padding: padding, child: const Text('Key', style: TextStyle(color: Colors.grey))),
                  Padding(padding: padding, child: const Text('Value', style: TextStyle(color: Colors.grey))),
                ],
              ),
              for (int i = 0; i < 8; i++)
                TableRow(
                  children: [
                    CustomInkResponse(
                      child: Padding(padding: padding, child: Text('Key $i')),
                      onTap: () => printLog('onTap, tableWidth = $tableWidth <-> ${_key.currentContext?.size?.width}'),
                      containedInkWell: containedInkWell,
                      highlightShape: rectangleHighlight ? BoxShape.rectangle : BoxShape.circle,
                      highlightColor: showHighlightEffect ? null : Colors.transparent,
                      splashColor: showRippleEffect ? null : Colors.transparent,
                      highlightFadeDuration: highlightFadeDuration,
                      splashFactory: CustomInkRippleFactory(
                        setting: rippleSetting.copyWith(
                          radiusCanvasCenterFn: nullCanvasCenter ? null : (box, _) => Offset(tableWidth / 2, box.size.height / 2),
                        ),
                      ),
                      getRadius: (box) {
                        printLog('getRadius, box size = ${box.size}');
                        return nullRadius ? null : calcDiagonal(tableWidth, box.size.height) / 2;
                      },
                      getRect: (box) {
                        final rect = getTableRowRect(box);
                        // printLog('getRect, row rect size = ${rect.size}'); // ??? assertion was thrown while dispatching notifications for ValueNotifier<String>
                        return nullRect ? null : rect;
                      },
                    ),
                    CustomInkResponse(
                      child: Padding(padding: padding, child: Text('Value $i')),
                      onTap: () => printLog('onTap, tableWidth = $tableWidth <-> ${_key.currentContext?.size?.width}'),
                      containedInkWell: containedInkWell,
                      highlightShape: rectangleHighlight ? BoxShape.rectangle : BoxShape.circle,
                      highlightColor: showHighlightEffect ? null : Colors.transparent,
                      splashColor: showRippleEffect ? null : Colors.transparent,
                      highlightFadeDuration: highlightFadeDuration,
                      splashFactory: CustomInkRippleFactory(
                        setting: rippleSetting.copyWith(
                          radiusCanvasCenterFn: nullCanvasCenter ? null : (box, _) => Offset(tableWidth / 2 - tableWidth * 0.3, box.size.height / 2),
                        ),
                      ),
                      getRadius: (box) {
                        printLog('getRadius, box size = ${box.size}');
                        return nullRadius ? null : calcDiagonal(tableWidth, box.size.height) / 2;
                      },
                      getRect: (box) {
                        final rect = getTableRowRect(box);
                        // printLog('getRect, row rect size = ${rect.size}');
                        return nullRect ? null : rect;
                      },
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
