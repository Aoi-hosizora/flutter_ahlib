import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class ExtendedDropdownPage extends StatefulWidget {
  const ExtendedDropdownPage({Key? key}) : super(key: key);

  @override
  State<ExtendedDropdownPage> createState() => _ExtendedDropdownPageState();
}

class _ExtendedDropdownPageState extends State<ExtendedDropdownPage> {
  final _key = GlobalKey<ExtendedDropdownButtonState>();
  final _controller = TextEditingController();
  var _index1 = 0;
  var _index2 = 0;
  var _index3 = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExtendedDropdown Example'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3 * 2,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'click here to test',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      // ======================================
                      // default
                      const Divider(),
                      const Text('default'),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: DropdownButton<int>(
                          value: _index1.clamp(0, 2),
                          items: [
                            for (int i = 0; i < 2; i++) //
                              DropdownMenuItem(value: i, child: Text(i.toString()))
                          ],
                          onChanged: (i) {
                            _index1 = i ?? 0;
                            if (mounted) setState(() {});
                          },
                          isExpanded: true,
                          underline: null, // Container(height: 1.0, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),

                  // ======================================
                  // extended
                  Column(
                    children: [
                      const Divider(),
                      const Text('extended'),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: ExtendedDropdownButton<int>(
                          value: _index2.clamp(0, 2),
                          selectedItemBuilder: (c) => [
                            for (int i = 0; i < 2; i++) //
                              DropdownMenuItem(value: i, child: Text(i.toString()))
                          ],
                          items: [
                            for (int i = 0; i < 2; i++) //
                              DropdownMenuItem(
                                value: i,
                                child: Text(
                                  i.toString(),
                                  style: TextStyle(color: _index2 == i ? Theme.of(context).primaryColor : null), // <<<
                                ),
                              )
                          ],
                          onChanged: (i) {
                            _index2 = i ?? 0;
                            if (mounted) setState(() {});
                          },
                          isExpanded: true,
                          onTapBefore: () async {
                            printLog('onTapBefore: ${MediaQuery.of(context).viewInsets}'); // x
                          },
                          adjustRectToAvoidBottomInset: true,
                          bottomViewInsetGetter: (_) {
                            printLog('bottomViewInsetGetter: ${ViewInsetsData.of(context)}'); // <<<
                            return ViewInsetsData.of(context)?.bottom;
                          },
                          adjustButtonRect: null, // no scroll, use the default adjust strategy
                          useRootNavigator: false,
                          useSafeArea: false,
                          underlinePosition: const PositionArgument.fromLTRB(5, null, 5, 12),
                          underline: Container(
                            height: 1.0,
                            color: Theme.of(context).primaryColor, // <<<
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ======================================
                  // closed automatically
                  Column(
                    children: [
                      const Divider(),
                      const Text('closed automatically'),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: ExtendedDropdownButton<int>(
                          key: _key,
                          value: _index3.clamp(0, 5),
                          items: [
                            for (int i = 0; i < 5; i++) //
                              DropdownMenuItem(
                                value: i,
                                child: Text(i.toString()),
                              )
                          ],
                          onChanged: (i) {
                            _index3 = i ?? 0;
                            if (mounted) setState(() {});
                          },
                          isExpanded: true,
                          onTapBefore: () {
                            Future.microtask(
                              () async {
                                for (var i = 0; i < 3; i++) {
                                  printLog('wait ${i + 1}');
                                  await Future.delayed(const Duration(seconds: 1));
                                }
                                printLog('removeDropdownRoute');
                                _key.currentState?.removeDropdownRoute();
                              },
                            );
                          },
                          adjustRectToAvoidBottomInset: true,
                          bottomViewInsetGetter: (_) {
                            printLog('bottomViewInsetGetter: ${ViewInsetsData.of(context)}');
                            return ViewInsetsData.of(context)?.bottom;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
