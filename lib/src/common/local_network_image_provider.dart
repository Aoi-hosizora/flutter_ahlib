import 'dart:io';

import 'package:flutter/painting.dart';
import '_local_network_image_provider_io.dart' as image_provider;

/// `ImageProvider` for local file or network image cache
abstract class LocalOrNetworkImageProvider extends ImageProvider<LocalOrNetworkImageProvider> {
  const factory LocalOrNetworkImageProvider({
    Future<File> Function() file,
    Future<String> Function() url,
    Map<String, String> headers,
    Function() onFile,
    Function() onNetwork,
  }) = image_provider.LocalOrNetworkImageProvider;

  Future<File> Function() get file;
  Future<String> Function() get url;
  Map<String, String> get headers;
  Function() get onFile;
  Function() get onNetwork;

  @override
  ImageStreamCompleter load(LocalOrNetworkImageProvider key, DecoderCallback decode);
}
