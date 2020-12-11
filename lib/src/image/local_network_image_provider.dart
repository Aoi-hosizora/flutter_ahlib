import 'dart:io' as io show File;

import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'local_network_image_provider_io.dart' as image_provider;

/// An [ImageProvider] for local file or cached network image,
/// if the file function or the url function are both provided, the file function will be used instead.
///
/// ATTENTION: url and file are all functions, so you must save the functions
/// before using this provider in order to reuse the ImageProvider from imageCache.
abstract class LocalOrNetworkImageProvider extends ImageProvider<LocalOrNetworkImageProvider> {
  const factory LocalOrNetworkImageProvider({
    Future<io.File> Function() file,
    Future<String> Function() url,
    double scale,
    Map<String, String> headers,
    BaseCacheManager cacheManager,
    Function() onStartLoadingFile,
    Function() onStartDownloadUrl,
    Function() onFileLoaded,
    Function() onUrlDownloaded,
  }) = image_provider.LocalOrNetworkImageProvider;

  /// The file getter function from which the image will be fetched.
  Future<io.File> Function() get file;

  /// The url getter function from which the image will be fetched.
  Future<String> Function() get url;

  /// The scale to place in the [ImageInfo] object of the image.
  double get scale;

  /// The HTTP headers that will be used to fetch image from network.
  Map<String, String> get headers;

  BaseCacheManager get cacheManager;

  /// The callback function when file start loading.
  Function() get onStartLoadingFile;

  /// The callback function when image start downloading.
  Function() get onStartDownloadUrl;

  /// The callback function when file loaded.
  Function() get onFileLoaded;

  /// The callback function when image downloaded.
  Function() get onUrlDownloaded;

  @override
  Future<LocalOrNetworkImageProvider> obtainKey(ImageConfiguration configuration);

  @override
  ImageStreamCompleter load(LocalOrNetworkImageProvider key, DecoderCallback decode);
}
