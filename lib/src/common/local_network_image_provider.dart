import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'local_network_image_provider_io.dart' as image_provider;

/// `ImageProvider` for local file or network image cache
abstract class LocalOrNetworkImageProvider extends ImageProvider<LocalOrNetworkImageProvider> {
  const factory LocalOrNetworkImageProvider({
    Future<File> Function() file,
    Future<String> Function() url,
    Map<String, String> headers,
    Function() onFile,
    Function() onNetwork,
    DefaultCacheManager cacheManager,
  }) = image_provider.LocalOrNetworkImageProvider;

  Future<File> Function() get file;
  Future<String> Function() get url;
  Map<String, String> get headers;
  Function() get onFile;
  Function() get onNetwork;
  DefaultCacheManager get cacheManager;

  @override
  ImageStreamCompleter load(LocalOrNetworkImageProvider key, DecoderCallback decode);
}
