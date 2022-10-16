import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ExtendedPhotoGalleryPage extends StatefulWidget {
  const ExtendedPhotoGalleryPage({Key? key}) : super(key: key);

  @override
  State<ExtendedPhotoGalleryPage> createState() => _ExtendedPhotoGalleryPageState();
}

class _ExtendedPhotoGalleryPageState extends State<ExtendedPhotoGalleryPage> {
  final _urls = [
    'https://userxxx-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg',
    'https://user-images.githubusercontent.com/31433480/139594293-94643ffa-938f-41fa-b3bf-8dceafb1dc58.jpg',
    'https://user-images.githubusercontent.com/31433480/139594294-3a87b6c3-1b93-4550-9fc8-6274a6d045c9.jpg',
    'https://neilpatel.com/wp-content/uploads/2017/08/colors.jpg',
    'https://99percentinvisible.org/app/uploads/2019/02/abstract-background-colors.jpg',
    'https://miuc.org/wp-content/uploads/2018/02/How-can-colours-help-you-in-your-everyday-life.jpg',
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
        for (var u in _urls) {
          await _cache.removeFile(u.replaceAll('userxxx', 'user'));
        }
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
              tooltip: 'Reload',
              onPressed: () async {
                // await _cache.emptyCache();
                await _cache.removeFile(_urls[_currentIndex]);
                // PaintingBinding.instance?.imageCache?.clear();
                _key.currentState?.reload(_currentIndex);
              },
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              tooltip: 'Update url',
              onPressed: () {
                _correctUrl = !_correctUrl;
                if (_correctUrl) {
                  _urls[0] = 'https://user-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg';
                } else {
                  _urls[0] = 'https://userxxx-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg';
                }
              },
            ),
            IconButton(
              icon: _preloadCount == 0
                  ? const Icon(Icons.close)
                  : _preloadCount == 1
                      ? const Icon(Icons.done)
                      : const Icon(Icons.done_all),
              tooltip: _preloadCount == 0
                  ? 'no preload'
                  : _preloadCount == 1
                      ? 'preload one page'
                      : 'preload two pages',
              onPressed: () {
                _preloadCount = _preloadCount == 0
                    ? 1
                    : _preloadCount == 1
                        ? 2
                        : 0;
                if (mounted) setState(() {});
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              ExtendedPhotoGallery.builder(
                key: _key,
                pageCount: 6,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                pageController: _controller,
                preloadPagesCount: _preloadCount,
                builder: (c, index) => ExtendedPhotoGalleryPageOptions(
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
                      onPressed: () {
                        _key.currentState?.reload(index);
                      },
                    ),
                  ),
                ),
                onPageChanged: (i) {
                  _currentIndex = i;
                  if (mounted) setState(() {});
                },
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
