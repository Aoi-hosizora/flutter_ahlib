import 'dart:async' show StreamController, scheduleMicrotask;
import 'dart:io' as io show File;
import 'dart:ui' as ui show Codec;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/image/load_local_or_network_image.dart';
import 'package:flutter_ahlib/src/image/multi_image_stream_completer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Note: The file is based on Baseflow/flutter_cached_network_image, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - CachedNetworkImageProvider: https://github.com/Baseflow/flutter_cached_network_image/blob/v3.1.0/cached_network_image/lib/src/image_provider/cached_network_image_provider.dart
// - ImageLoader: https://github.com/Baseflow/flutter_cached_network_image/blob/v3.1.0/cached_network_image/lib/src/image_provider/_image_loader.dart

/// An [ImageProvider] for loading image from local file or network using a cache.
///
/// Some tips of parameters:
/// 1. At lease one of [file] and [url] (or result of [fileFuture] and [urlFuture]) must be non-null value.
/// 2. If given [file] (or result of [fileFuture]) is not null and exists, this provider will load image from this file.
/// 3. If given [file] is not null but does not exist, behavior will depend on [fileMustExist]. An exception will be thrown if true, otherwise [url] will be used as fallback.
/// 4. If given [file] is null while given [url] is not null, this provider will load image from this web url.
/// 5. Only [file] (or [fileFuture]), [url] (or [urlFuture]), [scale], [maxWidth], [maxHeight] will be used to determine whether it represents the same image.
class LocalOrCachedNetworkImageProvider extends ImageProvider<LocalOrCachedNetworkImageProvider> {
  /// Creates [LocalOrCachedNetworkImageProvider] with nullable [file] and [url].
  const LocalOrCachedNetworkImageProvider({
    // general
    this.key,
    required this.file,
    required this.url,
    this.scale = 1.0,
    // local
    this.fileMustExist = true,
    // network
    this.maxWidth,
    this.maxHeight,
    this.headers,
    this.cacheManager,
    this.cacheKey,
    this.asyncHeadFirst = false,
    // callback
    this.onFileLoading,
    this.onUrlLoading,
    this.onFileLoaded,
    this.onUrlLoaded,
  })  : // general
        _useFuture = false,
        fileFuture = null,
        urlFuture = null,
        assert(file != null || url != null);

  /// Creates [LocalOrCachedNetworkImageProvider] with non-null [file] only.
  const LocalOrCachedNetworkImageProvider.fromLocal({
    // general
    this.key,
    required io.File this.file,
    this.scale = 1.0,
    // local
    this.fileMustExist = true,
    // callback
    this.onFileLoading,
    this.onFileLoaded,
  })  : // general
        _useFuture = false,
        url = null,
        fileFuture = null,
        urlFuture = null,
        // network
        maxWidth = null,
        maxHeight = null,
        asyncHeadFirst = false,
        headers = null,
        cacheManager = null,
        cacheKey = null,
        // callback
        onUrlLoading = null,
        onUrlLoaded = null;

  /// Creates [LocalOrCachedNetworkImageProvider] with non-null [url] only.
  const LocalOrCachedNetworkImageProvider.fromNetwork({
    // general
    this.key,
    required String this.url,
    this.scale = 1.0,
    // network
    this.maxWidth,
    this.maxHeight,
    this.headers,
    this.cacheManager,
    this.cacheKey,
    this.asyncHeadFirst = false,
    // callback
    this.onUrlLoading,
    this.onUrlLoaded,
  })  : // general
        _useFuture = false,
        file = null,
        fileFuture = null,
        urlFuture = null,
        // local
        fileMustExist = true,
        // callback
        onFileLoading = null,
        onFileLoaded = null;

  /// Creates [LocalOrCachedNetworkImageProvider] with non-null [fileFuture] and [urlFuture].
  const LocalOrCachedNetworkImageProvider.fromFutures({
    // general
    this.key,
    required Future<io.File?> this.fileFuture,
    required Future<String?> this.urlFuture,
    this.scale = 1.0,
    // local
    this.fileMustExist = true,
    // network
    this.maxWidth,
    this.maxHeight,
    this.headers,
    this.cacheManager,
    this.cacheKey,
    this.asyncHeadFirst = false,
    // callbacks
    this.onFileLoading,
    this.onUrlLoading,
    this.onFileLoaded,
    this.onUrlLoaded,
  })  : // general
        _useFuture = true,
        file = null,
        url = null;

  // =======
  // general
  // =======

  /// The key that can be used to reload the image in force when different [Key] passed.
  final Key? key;

  // The flag that describes if xxxFuture parameters used or not.
  final bool _useFuture;

  /// The local file of the image to load.
  final io.File? file;

  /// The web url of the image to load.
  final String? url;

  /// The local file future of the image to load.
  final Future<io.File?>? fileFuture;

  /// The web url future of the image to load.
  final Future<String?>? urlFuture;

  /// The scale of the image, defaults to 1.0.
  final double? scale;

  // =========
  // for local
  // =========

  /// The flag for deciding whether to throw exception or use [url] as fallback, when given
  /// [file] does not exist, defaults to true.
  final bool fileMustExist;

  // ===========
  // for network
  // ===========

  /// If this value is not null and [ImageCacheManager] is used, the image will be resized on
  /// disk to fit the width. This value will be ignored if a normal [cacheManager] is used.
  final int? maxWidth;

  /// If this value is not null and [ImageCacheManager] is used, the image will be resized on
  /// disk to fit the height. This value will be ignored if a normal [cacheManager] is used.
  final int? maxHeight;

  /// The flag for checking whether need to send HEAD request asynchronously to get network
  /// image's real size, defaults to false.
  final bool asyncHeadFirst;

  /// The headers for requesting network image, such as "Authorization" and "Referer".
  final Map<String, String>? headers;

  /// The cache manager which is used to check whether network image has already been loaded.
  final BaseCacheManager? cacheManager;

  /// The cache key for network image and will be stored in [cacheManager], defaults to [url]
  /// or [urlFuture] itself.
  final String? cacheKey;

  // =========
  // callbacks
  // =========

  /// The callback function to be called when the local image starts to load.
  final void Function()? onFileLoading;

  /// The callback function to be called when the network image starts to load.
  final void Function()? onUrlLoading;

  /// The callback function to be called when the local image finished loading. Here null
  /// [err] represents it succeeded, otherwise represents it failed.
  final void Function(Object? err)? onFileLoaded;

  /// The callback function to be called when the network image finished loading. Here null
  /// [err] represents it succeeded, otherwise represents it failed.
  final void Function(Object? err)? onUrlLoaded;

  @override
  Future<LocalOrCachedNetworkImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LocalOrCachedNetworkImageProvider>(this);
  }

  @override
  ImageStreamCompleter load(LocalOrCachedNetworkImageProvider key, DecoderCallback decode) {
    assert(key == this);
    final chunkEvents = StreamController<ImageChunkEvent>();
    Stream<ui.Codec> stream = loadLocalOrNetworkImageCodec(
      options: LoadImageOption(
        file: file,
        url: url,
        fileFuture: fileFuture,
        urlFuture: urlFuture,
        scale: scale,
        fileMustExist: fileMustExist,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        asyncHeadFirst: asyncHeadFirst,
        headers: headers,
        cacheManager: cacheManager,
        cacheKey: cacheKey,
        onFileLoading: onFileLoading,
        onUrlLoading: onUrlLoading,
        onFileLoaded: onFileLoaded,
        onUrlLoaded: onUrlLoaded,
      ),
      decode: decode,
      chunkEvents: chunkEvents,
      evictImageAsync: () => scheduleMicrotask(() {
        // Depending on where the exception was thrown, the image cache may not have had
        // a chance to track the key in the cache at all. Schedule a microtask to give
        // the cache a chance to add the key.
        PaintingBinding.instance?.imageCache?.evict(key);
      }),
    );
    return MultiImageStreamCompleter(
      codec: stream,
      chunkEvents: chunkEvents.stream,
      scale: key.scale ?? 1.0,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>(
          'Image provider: $this \n Image key: $key',
          this,
          style: DiagnosticsTreeStyle.errorProperty,
        );
      },
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other is LocalOrCachedNetworkImageProvider) {
      if (!(key == other.key && _useFuture == other._useFuture && scale == other.scale && maxWidth == other.maxWidth && maxHeight == other.maxHeight)) {
        return false;
      }

      if (_useFuture) {
        // ATTENTION: fileFuture and urlFuture are both futures, so for the same image,
        // you must use the previous used fileFuture and urlFuture (you have to save
        // these these future values first), to avoid ImageProvider's '==' operator
        // returning false and load the image incorrectly.
        return fileFuture == other.fileFuture && urlFuture == other.urlFuture;
      }

      return (file == other.file || (file != null && other.file != null && file!.path == other.file!.path)) && url == other.url;
    }
    return false;
  }

  @override
  int get hashCode {
    if (_useFuture) {
      return hashValues(key, fileFuture, urlFuture, scale, maxWidth, maxHeight);
    }
    return hashValues(key, file, url, scale, maxWidth, maxHeight);
  }

  @override
  String toString() {
    if (_useFuture) {
      return '$runtimeType(fileFuture: <future>, urlFuture: <future>, scale: $scale, ...)';
    }
    var path = file?.path == null ? 'null' : '"${file?.path ?? '?'}"';
    var url = this.url != null ? 'null' : '"${this.url ?? '?'}"';
    return '$runtimeType(file: $path, url: $url, scale: $scale, ...)';
  }
}
