import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class CustomSingleChildLayoutPage extends StatefulWidget {
  const CustomSingleChildLayoutPage({Key? key}) : super(key: key);

  @override
  State<CustomSingleChildLayoutPage> createState() => _CustomSingleChildLayoutPageState();
}

class _CustomSingleChildLayoutPageState extends State<CustomSingleChildLayoutPage> {
  Future<void> _showDialogWithCustomSingleChildLayout({required bool customizable}) async {
    var w = 0.0;
    var h = 0.0;
    var x = 0.0;
    var y = 0.0;
    var bl = 0.0;
    var br = 0.0;
    var bt = 0.0;
    var bb = 0.0;
    var wCtrl = TextEditingController()..text;
    var hCtrl = TextEditingController()..text;
    var xCtrl = TextEditingController()..text;
    var yCtrl = TextEditingController()..text;
    var blCtrl = TextEditingController()..text;
    var brCtrl = TextEditingController()..text;
    var btCtrl = TextEditingController()..text;
    var bbCtrl = TextEditingController()..text;

    void restore() {
      w = MediaQuery.of(context).size.width;
      h = MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight);
      x = 0;
      y = MediaQuery.of(context).padding.top + kToolbarHeight;
      bl = 0;
      br = 0;
      bt = 0;
      bb = 0;
      wCtrl.text = w.toString();
      hCtrl.text = h.toString();
      xCtrl.text = x.toString();
      yCtrl.text = y.toString();
      blCtrl.text = bl.toString();
      brCtrl.text = br.toString();
      btCtrl.text = bt.toString();
      bbCtrl.text = bb.toString();
    }

    restore();

    Widget textLabel(String text) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Text(text),
      );
    }

    Widget textField(TextEditingController controller) {
      return Expanded(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(isDense: true),
        ),
      );
    }

    var result = await showGeneralDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (c, _, __) => StatefulBuilder(
        builder: (_, _setState) => CustomSingleChildLayout(
          delegate: CustomSingleChildLayoutDelegate(
            sizeGetter: (constraints) => constraints.biggest,
            constraintsGetter: (constraints) => BoxConstraints(minWidth: 0, minHeight: 0, maxWidth: w, maxHeight: h),
            positionGetter: (size, childSize) => Offset(x, y),
            relayoutChecker: () => customizable,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: Colors.yellow,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('General Dialog'),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop('dismiss'),
                        child: const Text('dismiss'),
                      ),
                      if (customizable) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [textLabel('width'), textField(wCtrl), textLabel('height'), textField(hCtrl), const SizedBox(width: 10)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [textLabel('left'), textField(xCtrl), textLabel('top'), textField(yCtrl), const SizedBox(width: 10)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...[textLabel('barrier:'), textLabel('L'), textField(blCtrl), textLabel('R'), textField(brCtrl)],
                            ...[textLabel('T'), textField(btCtrl), textLabel('B'), textField(bbCtrl), const SizedBox(width: 10)],
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                w = double.tryParse(wCtrl.text) ?? w;
                                h = double.tryParse(hCtrl.text) ?? h;
                                x = double.tryParse(xCtrl.text) ?? x;
                                y = double.tryParse(yCtrl.text) ?? y;
                                bl = double.tryParse(blCtrl.text) ?? bl;
                                br = double.tryParse(brCtrl.text) ?? br;
                                bt = double.tryParse(btCtrl.text) ?? bt;
                                bb = double.tryParse(bbCtrl.text) ?? bb;
                                _setState(() {});
                              },
                              child: const Text('Apply'),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () {
                                restore();
                                _setState(() {});
                              },
                              child: const Text('Restore'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    color: const Color(0x80000000),
                    margin: EdgeInsets.fromLTRB(bl, bt, br, bb),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ),
      ),
    );
    printLog('$result, from showGeneralDialog - CustomSingleChildLayout');
  }

  Future<void> _showDialogWithStack() async {
    var result = await showGeneralDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (c, _, __) => Stack(
        children: [
          Positioned(
            left: 0,
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              child: Container(
                color: const Color(0x80000000),
              ),
              onTap: () => Navigator.of(context).pop(null),
            ),
          ),
          Positioned(
            left: 0,
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.yellow,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('General Dialog'),
                    const SizedBox(height: 5),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop('dismiss'),
                      child: const Text('dismiss'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    printLog('$result - from showGeneralDialog - Stack');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomSingleChildLayout Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('showGeneralDialog - CustomSingleChildLayout'),
              onPressed: () => _showDialogWithCustomSingleChildLayout(customizable: false),
            ),
            OutlinedButton(
              child: const Text('showGeneralDialog - customizable CustomSingleChildLayout'),
              onPressed: () => _showDialogWithCustomSingleChildLayout(customizable: true),
            ),
            OutlinedButton(
              child: const Text('showGeneralDialog - Stack'),
              onPressed: () => _showDialogWithStack(),
            ),
          ],
        ),
      ),
    );
  }
}
