import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LocalOrCachedNetworkImageProviderPage extends StatefulWidget {
  const LocalOrCachedNetworkImageProviderPage({Key? key}) : super(key: key);

  @override
  _LocalOrCachedNetworkImageProviderPageState createState() => _LocalOrCachedNetworkImageProviderPageState();
}

class _LocalOrCachedNetworkImageProviderPageState extends State<LocalOrCachedNetworkImageProviderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalOrCachedNetworkImageProvider Example'),
        actions: [
          IconButton(
            icon: const Text('Future'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => Scaffold(
                  appBar: AppBar(
                    title: const Text('LocalOrCachedNetworkImageProvider.fromFutures Example'),
                  ),
                  body: const _TestPage(
                    useFuture: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: const _TestPage(
        useFuture: false,
      ),
    );
  }
}

class _TestPage extends StatefulWidget {
  const _TestPage({
    Key? key,
    required this.useFuture,
  }) : super(key: key);

  final bool useFuture;

  @override
  State<_TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<_TestPage> {
  // https://github.com/Baseflow/flutter_cached_network_image/issues/468#issuecomment-789757758
  // https://github.com/Baseflow/flutter_cached_network_image/issues/468#issuecomment-1153510183
  final _cache = DefaultCacheManager();
  final _vn1 = ValueNotifier<String>('');
  final _vn2 = ValueNotifier<String>('');
  var _correctFile = false;

  final _url = 'https://neilpatel.com/wp-content/uploads/2017/08/colors.jpg';
  final _urlKey = 'xxx';
  final _path1 = '/sdcard/DCIM/test.jpg';
  final _path2 = '/sdcard/DCIM/test_wrong.jpg';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Reload 1'),
              onPressed: () {
                printLog('Reload network image');
                _cache.removeFile(_urlKey);
                _vn1.value = DateTime.now().microsecondsSinceEpoch.toString();
              },
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              child: const Text('Reload 2'),
              onPressed: () {
                printLog('Reload local image');
                _vn2.value = DateTime.now().microsecondsSinceEpoch.toString();
              },
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              child: const Text('setState'),
              onPressed: () {
                printLog('setState directly');
                if (mounted) setState(() {});
              },
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              child: const Icon(Icons.redo),
              onPressed: () {
                // do not setState, please this will make the second LocalOrCachedNetworkImageProvider reload because different url
                _correctFile = !_correctFile;
              },
            ),
          ],
        ),
        Expanded(
          child: Center(
            child: ValueListenableBuilder(
              valueListenable: _vn1,
              builder: (_, k, __) => LocalOrCachedNetworkImage(
                key: ValueKey(k),
                provider: !widget.useFuture
                    ? LocalOrCachedNetworkImageProvider.fromNetwork(
                        key: ValueKey(k),
                        url: _url,
                        cacheManager: _cache,
                        cacheKey: _urlKey,
                        onUrlLoading: () => printLog('(first) onUrlLoading'),
                        onUrlLoaded: (e) => printLog('(first) onUrlLoaded $e'),
                      )
                    : LocalOrCachedNetworkImageProvider.fromFutures(
                        key: ValueKey(k),
                        fileFuture: Future<File?>.delayed(const Duration(milliseconds: 500), () => null),
                        urlFuture: Future<String?>.delayed(const Duration(milliseconds: 500), () => _url),
                        cacheManager: _cache,
                        cacheKey: _urlKey,
                        onFileLoading: () => printLog('(first future) onFileLoading'),
                        onFileLoaded: (e) => printLog('(first future) onFileLoaded $e'),
                        onUrlLoading: () => printLog('(first future) onUrlLoading'),
                        onUrlLoaded: (e) => printLog('(first future) onUrlLoaded $e'),
                      ),
                placeholderBuilder: (c) => const Center(
                  child: Icon(Icons.more_horiz),
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
              builder: (_, k, __) => LocalOrCachedNetworkImage(
                key: ValueKey(k),
                provider: !widget.useFuture
                    ? LocalOrCachedNetworkImageProvider.fromLocal(
                        key: ValueKey(k),
                        file: _correctFile ? File(_path1) : File(_path2),
                        fileMustExist: true,
                        onFileLoading: () => printLog('(second) onFileLoading'),
                        onFileLoaded: (e) => printLog('(second) onFileLoaded $e'),
                      )
                    : LocalOrCachedNetworkImageProvider.fromFutures(
                        key: ValueKey(k),
                        fileFuture: Future<File?>.delayed(const Duration(milliseconds: 500), () => _correctFile ? File(_path1) : File(_path2)),
                        urlFuture: Future<String?>.delayed(const Duration(milliseconds: 500), () => null),
                        fileMustExist: true,
                        onFileLoading: () => printLog('(second future) onFileLoading'),
                        onFileLoaded: (e) => printLog('(second future) onFileLoaded $e'),
                        onUrlLoading: () => printLog('(second future) onUrlLoading'),
                        onUrlLoaded: (e) => printLog('(second future) onUrlLoaded $e'),
                      ),
                placeholderBuilder: (c) => const Center(
                  child: Icon(Icons.more_horiz),
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
    );
  }
}
