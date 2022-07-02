import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class LocalOrCachedNetworkImageProviderPage extends StatefulWidget {
  const LocalOrCachedNetworkImageProviderPage({Key? key}) : super(key: key);

  @override
  _LocalOrCachedNetworkImageProviderPageState createState() => _LocalOrCachedNetworkImageProviderPageState();
}

// ignore_for_file: prefer_function_declarations_over_variables
class _LocalOrCachedNetworkImageProviderPageState extends State<LocalOrCachedNetworkImageProviderPage> {
  // https://github.com/Baseflow/flutter_cached_network_image/issues/468#issuecomment-789757758
  // var k1 = '';
  // var k2 = '';
  // https://github.com/Baseflow/flutter_cached_network_image/issues/468#issuecomment-1153510183
  final vn1 = ValueNotifier<String>('');
  final vn2 = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalOrCachedNetworkImageProvider Example'),
        actions: [
          IconButton(
            icon: const Text('Reload 1'),
            onPressed: () {
              print('Reload network image');
              // k1 = DateTime.now().microsecondsSinceEpoch.toString();
              // if (mounted) setState(() {});
              vn1.value = DateTime.now().microsecondsSinceEpoch.toString();
            },
          ),
          IconButton(
            icon: const Text('Reload 2'),
            onPressed: () {
              print('Reload local image');
              // k2 = DateTime.now().microsecondsSinceEpoch.toString();
              // if (mounted) setState(() {});
              vn2.value = DateTime.now().microsecondsSinceEpoch.toString();
            },
          ),
          IconButton(
            icon: const Text('setState'),
            onPressed: () {
              print('setState directly');
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: vn1,
                  builder: (_, k1, __) => Image(
                    key: ValueKey(k1),
                    image: LocalOrCachedNetworkImageProvider(
                      key: ValueKey(k1),
                      file: null,
                      url: 'https://neilpatel.com/wp-content/uploads/2017/08/colors.jpg',
                      onFileLoading: () => print('(url) onFileLoading'),
                      onFileLoaded: () => print('(url) onFileLoaded'),
                      onUrlLoading: () => print('(url) onUrlLoading'),
                      onUrlLoaded: () => print('(url) onUrlLoaded'),
                      onError: (_) => print('(url) onError'),
                    ),
                    errorBuilder: (_, e, __) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(e.toString()),
                        const Icon(Icons.error),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: vn2,
                  builder: (_, k2, __) => Image(
                    key: ValueKey(k2),
                    image: LocalOrCachedNetworkImageProvider(
                      key: ValueKey(k2),
                      file: File('/sdcard/DCIM/testx.jpg'),
                      url: null,
                      onFileLoading: () => print('(file) onFileLoading'),
                      onFileLoaded: () => print('(file) onFileLoaded'),
                      onUrlLoading: () => print('(file) onUrlLoading'),
                      onUrlLoaded: () => print('(file) onUrlLoaded'),
                      onError: (_) => print('(file) onError'),
                    ),
                    errorBuilder: (_, e, __) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(e.toString()),
                        const Icon(Icons.error),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
