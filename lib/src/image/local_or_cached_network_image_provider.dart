import 'dart:async' show Future, StreamController, scheduleMicrotask;
import 'dart:io' as io show File;
import 'dart:ui' as ui show Codec;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'local_or_cached_network_image_provider.dart' as image_provider;
import 'multi_image_stream_completer.dart';
import 'package:http/http.dart' as http show head;

// Refers to:
// https://github.com/Baseflow/flutter_cached_network_image/blob/v3.1.0/cached_network_image/lib/src/image_provider/cached_network_image_provider.dart
// https://github.com/Baseflow/flutter_cached_network_image/blob/v3.1.0/cached_network_image/lib/src/image_provider/_image_loader.dart

/// An [ImageProvider] for loading image from local file or network using a cache.
///
/// If given [file] function returns a not-null File, than this provider will load
/// image from given file, whether the file exists or not, otherwise this provider
/// will load image from the returned not-null url from given [url] function.
class LocalOrCachedNetworkImageProvider extends ImageProvider<image_provider.LocalOrCachedNetworkImageProvider> {
  const LocalOrCachedNetworkImageProvider({
    this.key,
    required this.file,
    required this.url,
    this.scale = 1.0,
    this.maxHeight,
    this.maxWidth,
    this.headFirst,
    this.headers,
    this.cacheManager,
    this.onError,
    this.onFileLoading,
    this.onUrlLoading,
    this.onFileLoaded,
    this.onUrlLoaded,
  })  : _useFn = false,
        fileFn = null,
        urlFn = null,
        assert(file != null || url != null);

  LocalOrCachedNetworkImageProvider.fn({
    this.key,
    required Future<io.File?> Function() fileFn,
    required Future<String?> Function() urlFn,
    this.scale = 1.0,
    this.maxHeight,
    this.maxWidth,
    this.headFirst,
    this.headers,
    this.cacheManager,
    this.onError,
    this.onFileLoading,
    this.onUrlLoading,
    this.onFileLoaded,
    this.onUrlLoaded,
  })  : _useFn = true,
        // ignore: prefer_initializing_formals
        fileFn = fileFn,
        // ignore: prefer_initializing_formals
        urlFn = urlFn,
        file = null,
        url = null;

  /// The key that can be used to reload the image in force.
  final Key? key;

  /// The flag that describes if fn parameters used or not.
  final bool _useFn;

  /// The local file of the image to load.
  final io.File? file;

  /// The web url of the image to load.
  final String? url;

  /// The local file function of the image to load.
  final Future<io.File?> Function()? fileFn;

  /// The web url function of the image to load.
  final Future<String?> Function()? urlFn;

  /// The scale of the image.
  final double scale;

  /// The maximum height of the loaded image. If not null and using an
  /// [ImageCacheManager] the image is resized on disk to fit the height.
  final int? maxHeight;

  /// The maximum width of the loaded image. If not null and using an
  /// [ImageCacheManager] the image is resized on disk to fit the width.
  final int? maxWidth;

  /// The flag for loading image from network, is used to check if need to
  /// send head request to get its real size.
  final bool? headFirst;

  /// The headers for the image provider, for example for authentication.
  final Map<String, String>? headers;

  /// The cache manager from which the image files are loaded.
  final BaseCacheManager? cacheManager;

  /// The callback function to be called when images fails to load.
  final void Function(dynamic)? onError;

  /// The callback function to be called when the local image starts to
  /// load.
  final Function()? onFileLoading;

  /// The callback function to be called when the network image starts to
  /// load or download.
  final Function()? onUrlLoading;

  /// The callback function to be called when the local image finished
  /// loading.
  final Function()? onFileLoaded;

  /// The callback function to be called when the network image finished
  /// loading or downloading.
  final Function()? onUrlLoaded;

  @override
  Future<LocalOrCachedNetworkImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LocalOrCachedNetworkImageProvider>(this);
  }

  @override
  ImageStreamCompleter load(image_provider.LocalOrCachedNetworkImageProvider key, DecoderCallback decode) {
    final chunkEvents = StreamController<ImageChunkEvent>();
    return MultiImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>(
          'Image provider: $this \n Image key: $key',
          this,
          style: DiagnosticsTreeStyle.errorProperty,
        );
      },
    );
  }

  Stream<ui.Codec> _loadAsync(
    image_provider.LocalOrCachedNetworkImageProvider key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
  ) async* {
    assert(key == this);

    io.File? file;
    String? url;
    if (!_useFn) {
      file = this.file;
      url = this.url;
    } else {
      assert(fileFn != null && urlFn != null);
      file = await fileFn!();
      url = await urlFn!();
      assert(file != null || url != null);
    }

    // load local image
    if (file != null) {
      onFileLoading?.call();
      yield* _loadLocalImageAsync(
        file,
        chunkEvents,
        decode,
        onError,
      );
      onFileLoaded?.call();
    }

    // load cached network image
    if (url != null) {
      onUrlLoading?.call();
      yield* _loadCachedNetworkImageAsync(
        url,
        chunkEvents,
        decode,
        cacheManager ?? DefaultCacheManager(),
        maxHeight,
        maxWidth,
        headFirst,
        headers,
        onError,
        () => PaintingBinding.instance?.imageCache?.evict(key),
      );
      onUrlLoaded?.call();
    }
  }

  Stream<ui.Codec> _loadLocalImageAsync(
    io.File file,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
    Function(dynamic)? onError,
  ) async* {
    try {
      if (!await file.exists()) {
        throw Exception('Image file "${file.path}" is not found.');
      }

      var bytes = await file.readAsBytes();
      var decoded = await decode(bytes);
      yield decoded;
    } catch (e) {
      onError?.call(e);

      // chunkEvents.addError(e);
      // =>
      // ══╡ EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE ╞════════════════════════════════════════════════════
      // The following _Exception was thrown loading an image:
      // Exception: Image file "/sdcard/DCIM/testx.jpg" is not found.
      //
      // When the exception was thrown, this was the stack:
      //
      // Image provider: LocalOrCachedNetworkImageProvider(...)
      //  Image key: LocalOrCachedNetworkImageProvider(...):
      //   LocalOrCachedNetworkImageProvider(...)
      // ════════════════════════════════════════════════════════════════════════════════════════════════════

      rethrow; // <<< use rethrow is better than chunkEvents.addError
      // =>
      // ══╡ EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE ╞════════════════════════════════════════════════════
      // The following _Exception was thrown resolving an image codec:
      // Exception: Image file "/sdcard/DCIM/testx.jpg" is not found.
      //
      // When the exception was thrown, this was the stack:
      // #0      LocalOrCachedNetworkImageProvider._loadLocalImageAsync
      // (package:flutter_ahlib/src/image/local_or_cached_network_image_provider.dart:157:9)
      // <asynchronous suspension>
      //
      // Image provider: LocalOrCachedNetworkImageProvider(...)
      //  Image key: LocalOrCachedNetworkImageProvider(...):
      //   LocalOrCachedNetworkImageProvider(...)
      // ════════════════════════════════════════════════════════════════════════════════════════════════════
    } finally {
      await chunkEvents.close();
    }
  }

  Stream<ui.Codec> _loadCachedNetworkImageAsync(
    String url,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
    BaseCacheManager cacheManager,
    int? maxHeight,
    int? maxWidth,
    bool? headFirst,
    Map<String, String>? headers,
    Function(dynamic)? onError,
    Function() evictImage,
  ) async* {
    try {
      assert(
          cacheManager is ImageCacheManager || (maxWidth == null && maxHeight == null),
          'To resize the image with a CacheManager the '
          'CacheManager needs to be an ImageCacheManager. maxWidth and '
          'maxHeight will be ignored when a normal CacheManager is used.');

      var stream = cacheManager is ImageCacheManager
          ? cacheManager.getImageFile(
              url,
              maxHeight: maxHeight,
              maxWidth: maxWidth,
              withProgress: true,
              headers: headers,
            )
          : cacheManager.getFileStream(
              url,
              withProgress: true,
              headers: headers,
            );

      // get real size from http head request
      int? imageSize;
      if (headFirst ?? false) {
        var uriUrl = Uri.parse(url);
        http.head(uriUrl, headers: {
          'Accept': '*/*',
          ...(headers ?? {}),
        }).then((data) {
          imageSize = int.tryParse(data.headers['content-length'] ?? '');
        }).catchError((_) {
          // ignore any error
        });
      }

      // await stream info
      await for (var result in stream) {
        if (result is DownloadProgress) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: result.downloaded,
            expectedTotalBytes: result.totalSize ?? imageSize,
          ));
        }
        if (result is FileInfo) {
          var file = result.file;
          var bytes = await file.readAsBytes();
          var decoded = await decode(bytes);
          yield decoded;
        }
      }
    } catch (e) {
      // Depending on where the exception was thrown, the image cache may not
      // have had a chance to track the key in the cache at all.
      // Schedule a microtask to give the cache a chance to add the key.
      scheduleMicrotask(() {
        evictImage();
      });

      onError?.call(e);
      // chunkEvents.addError(e);
      rethrow; // <<< use rethrow is better than chunkEvents.addError
    } finally {
      await chunkEvents.close();
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (other is LocalOrCachedNetworkImageProvider) {
      if (!(key == other.key && scale == other.scale && maxHeight == other.maxHeight && maxWidth == other.maxWidth)) {
        return false;
      }

      if (_useFn) {
        // ATTENTION: fileFn and urlFn are both functions, so for the same image,
        // you must use the previous fileFn and urlFn (you have to save these two
        // parameters first), to avoid ImageProvider's '==' operator returning
        // false and reload the image incorrectly.
        return fileFn == other.fileFn && urlFn == other.urlFn;
      }

      return (file == other.file || (file != null && other.file != null && file!.path == other.file!.path)) && url == other.url;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(key, file, url, scale, maxHeight, maxWidth);

  @override
  String toString() => 'LocalOrCachedNetworkImageProvider(...)';
}
