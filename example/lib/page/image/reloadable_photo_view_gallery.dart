import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ReloadablePhotoViewGalleryPage extends StatefulWidget {
  const ReloadablePhotoViewGalleryPage({Key? key}) : super(key: key);

  @override
  State<ReloadablePhotoViewGalleryPage> createState() => _ReloadablePhotoViewGalleryPageState();
}

class _ReloadablePhotoViewGalleryPageState extends State<ReloadablePhotoViewGalleryPage> {
  final _urls = [
    'https://userxxx-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg',
    'https://user-images.githubusercontent.com/31433480/139594293-94643ffa-938f-41fa-b3bf-8dceafb1dc58.jpg',
    'https://user-images.githubusercontent.com/31433480/139594294-3a87b6c3-1b93-4550-9fc8-6274a6d045c9.jpg',
    'https://neilpatel.com/wp-content/uploads/2017/08/colors.jpg',
    'https://99percentinvisible.org/app/uploads/2019/02/abstract-background-colors.jpg',
    'https://miuc.org/wp-content/uploads/2018/02/How-can-colours-help-you-in-your-everyday-life.jpg',
  ];
  final _key = GlobalKey<ReloadablePhotoViewGalleryState>();
  final _cache = CacheManager(Config(DateTime.now().toString()));
  var _currentIndex = 0;
  var _correctUrl = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReloadablePhotoViewGallery Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // TODO
              // await _cache.emptyCache();
              await _cache.removeFile(_urls[_currentIndex]);
              // PaintingBinding.instance?.imageCache?.clear();
              _key.currentState?.reload(_currentIndex);
            },
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () {
              _correctUrl = !_correctUrl;
              if (_correctUrl) {
                _urls[0] = 'https://user-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg';
              } else {
                _urls[0] = 'https://userxxx-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg';
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            ReloadablePhotoViewGallery.builder(
              key: _key,
              itemCount: 6,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              builder: (c, index) => ReloadablePhotoViewGalleryPageOptions(
                imageProviderBuilder: (key) => LocalOrCachedNetworkImageProvider.fromNetwork(
                  key: key,
                  url: _urls[index],
                  cacheManager: _cache,
                  onUrlLoading: () => print('onUrlLoading $index'),
                  onUrlError: (e) => print('onError $index: $e'),
                  onUrlLoaded: () => print('onUrlLoaded $index'),
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
                  '${_currentIndex + 1} / ${_key.currentState?.itemCount ?? '?'}',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
