import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/page/index.dart';

void main() {
  runApp(const MyApp());
}

final _logger = ValueNotifier<String>('Logger:');
final _controller = ScrollController();

void printLog(Object? s, {bool alsoPrint = true, bool logPrefix = true}) {
  alsoPrint ? print(s) : null;
  Future.microtask(() {
    var text = s?.toString() ?? '<null>';
    _logger.value += (logPrefix ? '\n[log] ' : '\n') + text;
    WidgetsBinding.instance?.addPostFrameCallback((_) => _controller.scrollToBottom());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_ahlib example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ).withSplashFactory(CustomInkRipple.preferredSplashFactory),
      home: const IndexPage(),
      builder: (context, child) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ViewInsetsData(
                viewInsets: MediaQuery.of(context).viewInsets,
                child: child!,
              ),
            ),
            const Divider(height: 0, thickness: 1),
            SizedBox(
              height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical) / 5,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Scrollbar(
                    controller: _controller,
                    child: SingleChildScrollView(
                      controller: _controller,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ValueListenableBuilder<String>(
                          valueListenable: _logger,
                          builder: (_, logger, __) => Text(
                            logger,
                            style: const TextStyle(fontFamily: 'monospace'),
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
