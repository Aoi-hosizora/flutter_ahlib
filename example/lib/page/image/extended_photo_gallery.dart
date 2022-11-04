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
  final _galleryKey = GlobalKey<ExtendedPhotoGalleryState>();
  final CacheManager _cache = DefaultCacheManager();

  var _currentIndex = 0;
  var _correctUrl = false;
  var _preloadCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
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
          title: const Text('ReloadablePhotoViewGallery Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reload current page',
              onPressed: () async {
                await _cache.removeFile(_urls[_currentIndex]);
                _galleryKey.currentState?.reloadPhoto(_currentIndex);
              },
            ),
            IconButton(
              icon: _correctUrl ? const Icon(Icons.check) : const Icon(Icons.close),
              tooltip: _correctUrl ? 'currently use correct url' : 'currently use wrong url',
              onPressed: () {
                _correctUrl = !_correctUrl;
                if (mounted) setState(() {});
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  // setState will make the first ImageProvider reload image because different url, so here use addPostFrameCallback
                  if (_correctUrl) {
                    _urls[0] = _urls[0].replaceAll('userxxx-', 'user-');
                  } else {
                    _urls[0] = _urls[0].replaceAll('user-', 'userxxx-');
                  }
                });
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
              onPressed: () async {
                await _cache.emptyCache();
                PaintingBinding.instance?.imageCache?.clear();
                printLog('emptyCache');
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => const _AdvancedPage(),
                  ),
                );
                await _cache.emptyCache();
                PaintingBinding.instance?.imageCache?.clear();
                printLog('emptyCache');
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              ExtendedPhotoGallery.builder(
                key: _galleryKey,
                pageCount: _urls.length,
                builder: (c, index) => ExtendedPhotoGalleryPageOptions(
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
                    key: key,
                    url: _urls[index],
                    cacheManager: _cache,
                    onUrlLoading: () => printLog('onUrlLoading ${index + 1}'),
                    onUrlLoaded: (e) => printLog('onUrlLoaded ${index + 1} $e'),
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
                        _galleryKey.currentState?.reloadPhoto(index);
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
                  errorBuilder: (_, __, ___) => const Text('error', style: TextStyle(color: Colors.white)),
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
                    '${_currentIndex + 1} / ${_galleryKey.currentState?.pageCount ?? '?'}',
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
  final _urls = [
    // 667x400
    'https://user-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg',
    'https://user-images.githubusercontent.com/31433480/139594293-94643ffa-938f-41fa-b3bf-8dceafb1dc58.jpg',
    'https://user-images.githubusercontent.com/31433480/200110727-d9cbf051-04ac-47e1-b386-e5ebe8b66484.jpg',
    // origin
    'https://user-images.githubusercontent.com/31433480/200110620-94fd2709-d6f0-459d-b2e5-29ef7b592261.png',
    'https://user-images.githubusercontent.com/31433480/200110645-9320619c-f35a-4302-8f67-046b09f3bf20.png',
    'https://user-images.githubusercontent.com/31433480/200110659-4c5b8599-df6b-4b7d-b635-9a52752d4fcc.png',
  ];

  var _controller = PageController(viewportFraction: 1.0, initialPage: 0);
  final _galleryKey = GlobalKey<ExtendedPhotoGalleryState>();
  final CacheManager _cache = DefaultCacheManager();

  var _containsSpacer = false;
  var _keepViewportMainAxisSize = true;
  var _changePageWhenFinished = true;
  var _currentPageIndex = 0;
  var _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExtendedPhotoGallery.advanced Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              printLog('reload image ${_currentImageIndex + 1}');
              await _cache.removeFile(_urls[_currentImageIndex]);
              _galleryKey.currentState?.reloadPhoto(_currentImageIndex); // <<<
            },
          ),
          IconButton(
            icon: Text(_containsSpacer ? 'Spacer' : 'No spacer'),
            tooltip: (_containsSpacer ? 'Have spacer' : 'No spacer') + ' between pages',
            onPressed: () async {
              _containsSpacer = !_containsSpacer;
              if (mounted) setState(() {});
              var oldController = _controller;
              _controller = PageController(viewportFraction: _containsSpacer ? 1.08 : 1.0, initialPage: _currentPageIndex);
              WidgetsBinding.instance?.addPostFrameCallback((_) => oldController.dispose());
            },
          ),
          IconButton(
            icon: Text(_keepViewportMainAxisSize ? 'Keep' : 'Not keep'),
            tooltip: (_keepViewportMainAxisSize ? 'Keep' : 'Not keep') + ' viewport size at main axis',
            onPressed: () async {
              _keepViewportMainAxisSize = !_keepViewportMainAxisSize;
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: Text(_changePageWhenFinished ? 'Finish' : 'Middle'),
            tooltip: 'Call onPageChanged when ' + (_changePageWhenFinished ? 'page changing is finished' : 'round value of page offset changed'),
            onPressed: () async {
              _changePageWhenFinished = !_changePageWhenFinished;
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: ExtendedPhotoGallery.advanced(
                key: _galleryKey,
                pageCount: _urls.length + 4,
                builder: (c, index) => ExtendedPhotoGalleryPageOptions(
                  imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
                    key: key,
                    url: _urls[index],
                    cacheManager: _cache,
                    onUrlLoading: () => printLog('onUrlLoading ${index + 1}'),
                    onUrlLoaded: (e) => printLog('onUrlLoaded ${index + 1} $e'),
                  ),
                ),
                advancedBuilder: (c, index, builder) {
                  // 0, 1 => pre
                  // 2 ~ l+1 => image 0 ~ l-1
                  // l+2, l+3 => post
                  if (index == 0 || index == _urls.length + 3) {
                    return Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Center(
                        child: Text('index: $index'),
                      ),
                    );
                  }
                  if (index == 1 || index == _urls.length + 2) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Text('index: $index'),
                      ),
                    );
                  }

                  final imageIndex = index - 2;
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (c) => SimpleDialog(
                          title: Text('Page ${imageIndex + 1}'),
                          children: [
                            IconTextDialogOption(
                              icon: const Icon(Icons.refresh),
                              text: const Text('Reload this page'),
                              onPressed: () async {
                                printLog('reload image ${imageIndex + 1}');
                                await _cache.removeFile(_urls[imageIndex]);
                                _galleryKey.currentState?.reloadPhoto(imageIndex); // <<<
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: builder.call(c, imageIndex), // <<<
                  );
                },
                fallbackOptions: PhotoViewOptions(
                  loadingBuilder: (_, ev) => Center(
                    child: Text(
                      '${_currentImageIndex + 1} >>> ${ev?.cumulativeBytesLoaded}/${ev?.expectedTotalBytes}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  errorBuilder: (_, err, __) => Center(
                    child: Text(
                      '${_currentImageIndex + 1} >>> $err',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onPageChanged: (i) {
                  _currentPageIndex = i;
                  _currentImageIndex = (i - 2).clamp(0, _urls.length - 1);
                  if (mounted) setState(() {});
                },
                pageController: _controller,
                changePageWhenFinished: _changePageWhenFinished,
                keepViewportMainAxisSize: _keepViewportMainAxisSize,
                fractionWidthFactor: null,
                fractionHeightFactor: null,
                preloadPagesCount: 0,
              ),
            ),
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Page: ${_currentPageIndex + 1} / ${_galleryKey.currentState?.pageCount ?? '?'}\n' // no setState, so it will show ? when built firstly
                  'Image: ${_currentImageIndex + 1} / ${_urls.length}',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
