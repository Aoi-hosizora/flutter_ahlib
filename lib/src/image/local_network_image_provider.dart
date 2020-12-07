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
    Function() onFile,
    Function() onNetwork,
  }) = image_provider.LocalOrNetworkImageProvider;

  /// The FILE getter function from which the image will be fetched.
  Future<io.File> Function() get file;

  /// The URL getter function from which the image will be fetched.
  Future<String> Function() get url;

  /// The scale to place in the [ImageInfo] object of the image.
  double get scale;

  /// The HTTP headers that will be used to fetch image from network.
  Map<String, String> get headers;

  /// Optional cache manager. If no cache manager is defined DefaultCacheManager() will be used.
  BaseCacheManager get cacheManager;

  /// The callback function when file loaded.
  Function() get onFile;

  /// The callback function when image downloaded.
  Function() get onNetwork;

  @override
  Future<LocalOrNetworkImageProvider> obtainKey(ImageConfiguration configuration);

  @override
  ImageStreamCompleter load(LocalOrNetworkImageProvider key, DecoderCallback decode);
}
