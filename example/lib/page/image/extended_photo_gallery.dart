import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

class ExtendedPhotoGalleryPage extends StatefulWidget {
  const ExtendedPhotoGalleryPage({Key? key}) : super(key: key);

  @override
  State<ExtendedPhotoGalleryPage> createState() => _ExtendedPhotoGalleryPageState();
}

class _ExtendedPhotoGalleryPageState extends State<ExtendedPhotoGalleryPage> {
  final _urls = [
    // 667x400
    'https://userxxx-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg', // xxx
    'https://user-images.githubusercontent.com/31433480/139594293-94643ffa-938f-41fa-b3bf-8dceafb1dc58.jpg',
    'https://user-images.githubusercontent.com/31433480/200110727-d9cbf051-04ac-47e1-b386-e5ebe8b66484.jpg',
    // origin
    'https://user-images.githubusercontent.com/31433480/200110620-94fd2709-d6f0-459d-b2e5-29ef7b592261.png',
    'https://user-images.githubusercontent.com/31433480/200110645-9320619c-f35a-4302-8f67-046b09f3bf20.png',
    'https://user-images.githubusercontent.com/31433480/200110659-4c5b8599-df6b-4b7d-b635-9a52752d4fcc.png',
  ];

  final _controller = PageController(viewportFraction: 1.08);
  final _key = GlobalKey<ExtendedPhotoGalleryState>();
  final CacheManager _cache = DefaultCacheManager();

  var _currentIndex = 0;
  var _correctUrl = false;
  var _preloadCount = 0;

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
          title: const Text('ReloadablePhotoViewGallery Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reload current page',
              onPressed: () async {
                await _cache.removeFile(_urls[_currentIndex]);
                _key.currentState?.reload(_currentIndex);
              },
            ),
            IconButton(
              icon: _correctUrl ? const Icon(Icons.check) : const Icon(Icons.close),
              tooltip: _correctUrl ? 'currently use correct url' : 'currently use wrong url',
              onPressed: () {
                _correctUrl = !_correctUrl;
                if (_correctUrl) {
                  _urls[0].replaceAll('userxxx-', 'user-');
                } else {
                  _urls[0].replaceAll('user-', 'userxxx-');
                }
              },
            ),
            IconButton(
              icon: Text('$_preloadCount'),
              tooltip: 'preload $_preloadCount pages',
              onPressed: () {
                _preloadCount = (_preloadCount == 0 ? 1 : (_preloadCount == 1 ? 2 : 0));
                if (mounted) setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.vertical_split),
              tooltip: 'Open advanced pace',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => const _AdvancedPage(),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              ExtendedPhotoGallery.builder(
                key: _key,
                pageCount: _urls.length,
                builder: (c, index) => ExtendedPhotoGalleryPageOptions(
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
                    key: key,
                    url: _urls[index],
                    cacheManager: _cache,
                    onUrlLoading: () => printLog('onUrlLoading ${index + 1}'),
                    onUrlError: (e) => printLog('onError ${index + 1}: $e'),
                    onUrlLoaded: () => printLog('onUrlLoaded ${index + 1}'),
                  ),
                  loadingBuilder: (_, ev) => Center(
                    child: CircularProgressIndicator(
                      value: (ev == null || ev.expectedTotalBytes == null) ? null : ev.cumulativeBytesLoaded / ev.expectedTotalBytes!,
                    ),
                  ),
                  errorBuilder: (_, __, ___) => Center(
                    child: ElevatedButton(
                      child: const Text('Reload'),
                      onPressed: () async {
                        await _cache.removeFile(_urls[index]);
                        _key.currentState?.reload(index);
                      },
                    ),
                  ),
                ),
                onPageChanged: (i) {
                  _currentIndex = i;
                  if (mounted) setState(() {});
                },
                fallbackOptions: PhotoViewOptions(
                  // following values are not used
                  backgroundDecoration: const BoxDecoration(color: Colors.white),
                  errorBuilder: (_, __, ___) => const Text('error'),
                  // following values are used
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained / 2,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  enableRotation: true,
                  wantKeepAlive: true,
                ),
                pageController: _controller,
                changePageWhenFinished: true,
                keepViewportMainAxisSize: true,
                preloadPagesCount: _preloadCount,
              ),
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${_currentIndex + 1} / ${_key.currentState?.pageCount ?? '?'}',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdvancedPage extends StatefulWidget {
  const _AdvancedPage({Key? key}) : super(key: key);

  @override
  State<_AdvancedPage> createState() => _AdvancedPageState();
}

class _AdvancedPageState extends State<_AdvancedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExtendedPhotoGallery.advanced Example'),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: ExtendedPhotoGallery.advanced(
          //     pageCount: pageCount,
          //     builder: builder,
          //     advancedBuilder: advancedBuilder,
          //   ),
          // ),
          // const Positioned(
          //   child: Text(''),
          // ),
        ],
      ),
    );
  }
}
