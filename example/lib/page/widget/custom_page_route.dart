import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class CustomPageRoutePage extends StatefulWidget {
  const CustomPageRoutePage({Key? key}) : super(key: key);

  @override
  State<CustomPageRoutePage> createState() => _CustomPageRoutePageState();
}

class _CustomPageRoutePageState extends State<CustomPageRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPageRoute Example'),
      ),
      body: Center(
        child: OutlinedButton(
          child: const Text('Test'),
          onPressed: () => Navigator.of(context).push(
            CustomPageRoute(
              context: context,
              builder: (c) => Scaffold(
                body: Center(
                  child: OutlinedButton(
                    child: const Text('Test'),
                    onPressed: () => Navigator.of(context).push(
                      CustomPageRoute(
                        context: context,
                        builder: (c) => const Scaffold(body: Center(child: Text('x'))),
                        transitionDuration: const Duration(milliseconds: 1000),
                        reverseTransitionDuration: const Duration(milliseconds: 2000),
                        transitionsBuilder: const NoPopGestureCupertinoPageTransitionsBuilder(),
                      ),
                    ),
                  ),
                ),
              ),
              transitionDuration: const Duration(milliseconds: 1000),
              reverseTransitionDuration: const Duration(milliseconds: 2000),
              transitionsBuilder: const NoPopGestureCupertinoPageTransitionsBuilder(),
            ),
          ),
        ),
      ),
    );
  }
}
