import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

class ReloadablePhotoViewPage extends StatefulWidget {
  const ReloadablePhotoViewPage({Key? key}) : super(key: key);

  @override
  State<ReloadablePhotoViewPage> createState() => _ReloadablePhotoViewPageState();
}

class _ReloadablePhotoViewPageState extends State<ReloadablePhotoViewPage> {
  final _urls = [
    'https://user-images.githubusercontent.com/31433480/200110620-94fd2709-d6f0-459d-b2e5-29ef7b592261.png',
    'https://user-images.githubusercontent.com/31433480/200110645-9320619c-f35a-4302-8f67-046b09f3bf20.png',
    'https://user-images.githubusercontent.com/31433480/200110659-4c5b8599-df6b-4b7d-b635-9a52752d4fcc.png',
  ];

  final _keys = List.generate(3, (_) => GlobalKey<ReloadablePhotoViewState>());
  final CacheManager _cache = DefaultCacheManager();

  PhotoViewScaleState _customScaleStateCycle(PhotoViewScaleState actual) {
    switch (actual) {
      case PhotoViewScaleState.initial:
        return PhotoViewScaleState.covering;
      case PhotoViewScaleState.covering:
      case PhotoViewScaleState.originalSize:
      case PhotoViewScaleState.zoomedIn:
      case PhotoViewScaleState.zoomedOut:
        return PhotoViewScaleState.initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _cache.emptyCache();
        PaintingBinding.instance?.imageCache?.clear();
        printLog('emptyCache');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ReloadablePhotoView Example'),
          actions: [
            IconButton(
              icon: const Text('0'),
              onPressed: () async {
                await _cache.removeFile(_urls[0]);
                _keys[0].currentState?.reload();
              },
            ),
            IconButton(
              icon: const Text('1'),
              onPressed: () async {
                await _cache.removeFile(_urls[1]);
                _keys[1].currentState?.reload();
              },
            ),
            IconButton(
              icon: const Text('2'),
              onPressed: () async {
                await _cache.removeFile(_urls[2]);
                _keys[2].currentState?.reload();
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            // 0
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: Text('initialScale: covered, minScale: 0, maxScale: inf, custom loadingBuilder, custom errorBuilder'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: ReloadablePhotoView(
                key: _keys[0],
                imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
                  key: key,
                  url: _urls[0],
                  cacheManager: _cache,
                ),
                //
                initialScale: PhotoViewComputedScale.covered,
                minScale: null, // 0
                maxScale: null, // inf
                backgroundDecoration: null,
                filterQuality: FilterQuality.high,
                onTapDown: (_, d, __) => print('onTapDown 0 ${d.globalPosition}'),
                onTapUp: (_, d, __) => print('onTapUp 0 ${d.globalPosition}'),
                loadingBuilder: (_, ev) => Center(
                  child: Text(
                    '${ev?.cumulativeBytesLoaded}/${ev?.expectedTotalBytes}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                errorBuilder: (_, err, __) => Center(
                  child: Text(
                    err.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                //
                basePosition: null,
                enablePanAlways: null,
                enableRotation: null,
                scaleStateCycle: null,
              ),
            ),

            //
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: Text('initialScale: contained, minScale: contained / 2, maxScale: covered * 2, custom backgroundDecoration, enableRotation'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: ReloadablePhotoView(
                key: _keys[1],
                imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
                  key: key,
                  url: _urls[1],
                  cacheManager: _cache,
                ),
                //
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained / 2,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: BoxDecoration(color: Colors.grey[800]!),
                filterQuality: FilterQuality.high,
                onTapDown: (_, d, __) => print('onTapDown 1 ${d.globalPosition}'),
                onTapUp: (_, d, __) => print('onTapUp 1 ${d.globalPosition}'),
                loadingBuilder: null,
                errorBuilder: null,
                //
                basePosition: null,
                enablePanAlways: null,
                enableRotation: true,
                scaleStateCycle: null,
              ),
            ),

            //
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: Text('initialScale: covered, maxScale: 1.0, filterQuality: none, basePosition: topCenter, enablePanAlways, custom scaleStateCycle'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: ReloadablePhotoView(
                key: _keys[2],
                imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
                  key: key,
                  url: _urls[2],
                  cacheManager: _cache,
                ),
                //
                initialScale: PhotoViewComputedScale.covered,
                minScale: null,
                maxScale: 1.0,
                backgroundDecoration: null,
                filterQuality: FilterQuality.none,
                onTapDown: (_, d, __) => print('onTapDown 2 ${d.globalPosition}'),
                onTapUp: (_, d, __) => print('onTapUp 2 ${d.globalPosition}'),
                loadingBuilder: null,
                errorBuilder: null,
                //
                basePosition: Alignment.topCenter,
                enablePanAlways: true,
                enableRotation: true,
                scaleStateCycle: _customScaleStateCycle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
