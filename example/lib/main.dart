import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/page/index.dart';

void main() {
  runApp(const MyApp());
}

final _logger = ValueNotifier<String>('Logger:');
final _controller = ScrollController();

void printLog(Object? s, {bool alsoPrint = true, bool logPrefix = true}) {
  if (alsoPrint) {
    print(s);
  }
  Future.microtask(() {
    var text = s?.toString() ?? '<null>';
    if (logPrefix) {
      _logger.value += '\n[log] ' + text;
    } else {
      _logger.value += '\n' + text;
    }
    WidgetsBinding.instance?.addPostFrameCallback((_) => _controller.scrollToBottom());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_ahlib_example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ).withSplashFactory(CustomInkRipple.preferredSplashFactory),
      home: const IndexPage(),
      builder: (context, child) => Scaffold(
        body: Column(
          children: [
            Expanded(child: child!),
            const Divider(height: 0, thickness: 1),
            SizedBox(
              height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical) / 5,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Scrollbar(
                      controller: _controller,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        controller: _controller,
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ValueListenableBuilder<String>(
                            valueListenable: _logger,
                            builder: (_, v, __) => Text(
                              v,
                              style: const TextStyle(
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _logger.value = 'Logger:',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
