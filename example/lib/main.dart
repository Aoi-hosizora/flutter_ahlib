import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/page/index.dart';

void main() {
  runApp(const MyApp());
}

final _logger = ValueNotifier<String>('Logger:');
final _controller = ScrollController();

void printLog(Object? s) {
  print(s);
  Future.microtask(() {
    _logger.value += '\n[log] ' + (s?.toString() ?? '<null>');
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
        // pageTransitionsTheme: const PageTransitionsTheme(
        //   builders: {
        //     TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        //     // TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        //   },
        // ),
      ).withSplashFactory(CustomInkRipple.preferredSplashFactory),
      home: const IndexPage(),
      builder: (context, child) => Scaffold(
        body: Column(
          children: [
            Expanded(child: child!),
            const Divider(height: 0, thickness: 1),
            Container(
              height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical) / 5,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        controller: _controller,
                        child: ValueListenableBuilder<String>(
                          valueListenable: _logger,
                          builder: (_, v, __) => Text(v),
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
