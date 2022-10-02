import 'package:flutter/material.dart';

class PopupModalDialogPage extends StatefulWidget {
  const PopupModalDialogPage({Key? key}) : super(key: key);

  @override
  State<PopupModalDialogPage> createState() => _PopupModalDialogPageState();
}

class ChildLayoutDelegate extends SingleChildLayoutDelegate {
  const ChildLayoutDelegate({
    this.sizeGetter,
    this.constraintsGetter,
    this.positionGetter,
    this.relayoutChecker,
  });

  final Size Function(BoxConstraints constraints)? sizeGetter;
  final BoxConstraints Function(BoxConstraints constraints)? constraintsGetter;
  final Offset Function(Size size, Size childSize)? positionGetter;
  final bool Function()? relayoutChecker;

  @override
  Size getSize(BoxConstraints constraints) {
    return sizeGetter?.call(constraints) ?? constraints.biggest;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraintsGetter?.call(constraints) ?? constraints;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionGetter?.call(size, childSize) ?? Offset.zero;
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return relayoutChecker?.call() ?? true; // TODO
  }
}

class _PopupModalDialogPageState extends State<PopupModalDialogPage> {
  final _key = GlobalKey<State<StatefulWidget>>();

  Future<void> _showDialog({required Widget child}) {
    return Navigator.of(context).push(
      RawDialogRoute(
        barrierDismissible: true,
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 200),
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionBuilder: null,
        settings: null,
        pageBuilder: (c, _, __) {
          final renderBox = _key.currentContext!.findRenderObject()! as RenderBox;
          final itemRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
          return CustomSingleChildLayout(
            delegate: ChildLayoutDelegate(
              constraintsGetter: (constraints) => BoxConstraints(
                minWidth: 0.0,
                maxWidth: constraints.maxWidth,
                minHeight: 0.0,
                maxHeight: MediaQuery.of(context).size.height - (itemRect.bottom + 1),
              ),
              positionGetter: (size, childSize) => Offset(
                itemRect.left,
                itemRect.bottom + 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: child,
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: const Color(0x80000000 /* barrierColor */),
                    ),
                    onTap: () {
                      if (true /* barrierDismissible */) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopupModalDialog Example'),
      ),
      body: Column(
        children: [
          Container(
            key: _key,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Text('Dialog1'),
                    ),
                    onTap: () => _showDialog(
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pinkAccent, Colors.lightGreenAccent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: const Center(
                          child: Text('Dialog1'),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Text('Dialog2'),
                    ),
                    onTap: () => _showDialog(
                      child: Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.cyanAccent, Colors.orangeAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Text('Dialog2'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
}
