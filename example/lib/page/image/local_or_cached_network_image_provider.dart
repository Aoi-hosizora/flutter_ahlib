import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

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
              printLog('Reload network image');
              _vn1.value = DateTime.now().microsecondsSinceEpoch.toString();
            },
          ),
          IconButton(
            icon: const Text('Reload 2'),
            onPressed: () {
              printLog('Reload local image');
              _vn2.value = DateTime.now().microsecondsSinceEpoch.toString();
            },
          ),
          IconButton(
            icon: const Text('setState'),
            onPressed: () {
              printLog('setState directly');
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
                      onFileLoading: () => printLog('(url) onFileLoading'),
                      onFileLoaded: () => printLog('(url) onFileLoaded'),
                      onFileError: (_) => printLog('(url) onError'),
                      onUrlLoading: () => printLog('(url) onUrlLoading'),
                      onUrlError: (_) => printLog('(url) onError'),
                      onUrlLoaded: () => printLog('(url) onUrlLoaded'),
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
                      onFileLoading: () => printLog('(file) onFileLoading'),
                      onFileLoaded: () => printLog('(file) onFileLoaded'),
                      onFileError: (_) => printLog('(file) onError'),
                      onUrlLoading: () => printLog('(file) onUrlLoading'),
                      onUrlError: (_) => printLog('(file) onError'),
                      onUrlLoaded: () => printLog('(file) onUrlLoaded'),
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
