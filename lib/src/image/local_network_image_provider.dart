import 'dart:io' as io show File;

import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'local_network_image_provider_io.dart' as image_provider;

/// An [ImageProvider] for local file or network image with cache.
abstract class LocalOrNetworkImageProvider extends ImageProvider<LocalOrNetworkImageProvider> {
  const factory LocalOrNetworkImageProvider({
    Future<io.File> Function() file,
    Future<String> Function() url,
    double scale,
    Map<String, String> headers,
    BaseCacheManager cacheManager,
    Function() onFileLoading,
    Function() onNetworkLoading,
    Function() onFileLoaded,
    Function() onNetworkLoaded,
  }) = image_provider.LocalOrNetworkImageProvider;

  /// The file of the image to load.
  Future<io.File> Function() get file;

  /// The web url of the image to load.
  Future<String> Function() get url;

  /// The scale of the image.
  double get scale;

  /// The headers of the request used to fetch the network image.
  Map<String, String> get headers;

  /// The cache manager, uses [DefaultCacheManager] if null.
  BaseCacheManager get cacheManager;

  /// The callback function invoked when the local file starts to loading.
  Function() get onFileLoading;

  /// The callback function invoked when the network image start to download.
  Function() get onNetworkLoading;

  /// The callback function invoked when the local file loaded.
  Function() get onFileLoaded;

  /// The callback function invoked when the network image downloaded.
  Function() get onNetworkLoaded;

  @override
  Future<LocalOrNetworkImageProvider> obtainKey(ImageConfiguration configuration);

  @override
  ImageStreamCompleter load(LocalOrNetworkImageProvider key, DecoderCallback decode);
}
