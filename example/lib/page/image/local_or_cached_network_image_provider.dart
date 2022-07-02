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
  // https://github.com/Baseflow/flutter_cached_network_image/issues/468#issuecomment-1153510183
  final _vn1 = ValueNotifier<String>('');
  final _vn2 = ValueNotifier<String>('');
  var _correctFile = false;

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
              _vn1.value = DateTime.now().microsecondsSinceEpoch.toString();
            },
          ),
          IconButton(
            icon: const Text('Reload 2'),
            onPressed: () {
              print('Reload local image');
              _vn2.value = DateTime.now().microsecondsSinceEpoch.toString();
            },
          ),
          IconButton(
            icon: const Text('setState'),
            onPressed: () {
              print('setState directly');
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () => _correctFile = !_correctFile,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: _vn1,
                  builder: (_, k, __) => Image(
                    key: ValueKey(k),
                    image: LocalOrCachedNetworkImageProvider(
                      key: ValueKey(k),
                      file: null,
                      url: 'https://neilpatel.com/wp-content/uploads/2017/08/colors.jpg',
                      onFileLoading: () => print('(url) onFileLoading'),
                      onFileLoaded: () => print('(url) onFileLoaded'),
                      onFileError: (_) => print('(url) onError'),
                      onUrlLoading: () => print('(url) onUrlLoading'),
                      onUrlError: (_) => print('(url) onError'),
                      onUrlLoaded: () => print('(url) onUrlLoaded'),
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
                  valueListenable: _vn2,
                  builder: (_, k, __) => Image(
                    key: ValueKey(k),
                    image: LocalOrCachedNetworkImageProvider(
                      key: ValueKey(k),
                      file: _correctFile ? File('/sdcard/DCIM/test.jpg') : File('/sdcard/DCIM/testx.jpg'),
                      url: null,
                      onFileLoading: () => print('(file) onFileLoading'),
                      onFileLoaded: () => print('(file) onFileLoaded'),
                      onFileError: (_) => print('(file) onError'),
                      onUrlLoading: () => print('(file) onUrlLoading'),
                      onUrlError: (_) => print('(file) onError'),
                      onUrlLoaded: () => print('(file) onUrlLoaded'),
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
