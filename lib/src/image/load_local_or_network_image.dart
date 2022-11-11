import 'dart:async' show StreamController, scheduleMicrotask;
import 'dart:io' as io show File;
import 'dart:ui' as ui show Codec;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http show head;

class LoadImageOption {
  const LoadImageOption({
    this.file,
    this.url,
    this.fileFuture,
    this.urlFuture,
    this.scale = 1.0,
    this.fileMustExist = true,
    this.maxHeight,
    this.maxWidth,
    this.headers,
    this.cacheManager,
    this.cacheKey,
    this.asyncHeadFirst = false,
    this.onFileLoading,
    this.onUrlLoading,
    this.onFileLoaded,
    this.onUrlLoaded,
  });

  final io.File? file;
  final String? url;
  final Future<io.File?>? fileFuture;
  final Future<String?>? urlFuture;
  final double? scale;
  final bool fileMustExist;
  final int? maxHeight;
  final int? maxWidth;
  final bool asyncHeadFirst;
  final Map<String, String>? headers;
  final BaseCacheManager? cacheManager;
  final String? cacheKey;
  final Function()? onFileLoading;
  final Function()? onUrlLoading;
  final Function(Object? err)? onFileLoaded;
  final Function(Object? err)? onUrlLoaded;
}

Stream<ui.Codec> _loadAsync(
  // image_provider.LocalOrCachedNetworkImageProvider key,
  LoadImageOption option,
  StreamController<ImageChunkEvent> chunkEvents,
  DecoderCallback decode,
) async* {
  // assert(key == this);

  // 1. get file and url
  io.File? file;
  String? url;
  if (!(option.fileFuture != null || option.urlFuture != null)) {
    file = option.file;
    url = option.url;
  } else {
    assert(option.fileFuture != null && option.urlFuture != null);
    file = await option.fileFuture!;
    url = await option.urlFuture!;
  }
  assert(file != null || url != null);

  // 2. check file and url validity
  var useFile = false;
  var useUrl = false;
  if (file == null) {
    useUrl = true;
  } else {
    var existed = await file.exists();
    if (existed) {
      useFile = true;
    } else if (option.fileMustExist) {
      throw Exception('Image file "${file.path}" is not found.');
    } else if (url != null) {
      useUrl = true;
    } else {
      throw Exception('Image file "${file.path}" is not found and given url is null.');
    }
  }

  // load local image
  if (useFile) {
    option.onFileLoading?.call();
    yield* _loadLocalImageAsync(
      file!,
      chunkEvents,
      decode,
      option.onFileLoaded,
    );
  }

  // load cached network image
  if (useUrl) {
    option.onUrlLoading?.call();
    yield* _loadCachedNetworkImageAsync(
      url!,
      option.cacheKey,
      chunkEvents,
      decode,
      option.cacheManager ?? DefaultCacheManager(),
      option.maxHeight,
      option.maxWidth,
      option.asyncHeadFirst,
      option.headers,
      option.onUrlLoaded,
      () => PaintingBinding.instance?.imageCache?.evict(key),
    );
  }
}

Stream<ui.Codec> _loadLocalImageAsync(
  io.File file,
  StreamController<ImageChunkEvent> chunkEvents,
  DecoderCallback decode,
  Function(Object?)? onFinish,
) async* {
  try {
    var bytes = await file.readAsBytes();
    var decoded = await decode(bytes);
    yield decoded;
    onFinish?.call(null);
  } catch (e) {
    onFinish?.call(e);

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
  String? cacheKey,
  StreamController<ImageChunkEvent> chunkEvents,
  DecoderCallback decode,
  BaseCacheManager cacheManager,
  int? maxHeight,
  int? maxWidth,
  bool asyncHeadFirst,
  Map<String, String>? headers,
  Function(Object?)? onFinish,
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
            key: cacheKey,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            withProgress: true,
            headers: headers,
          ) // also download
        : cacheManager.getFileStream(
            url,
            key: cacheKey,
            withProgress: true,
            headers: headers,
          );

    // get real size from http head request
    int? imageSize;
    if (asyncHeadFirst) {
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
    onFinish?.call(null);
  } catch (e) {
    // Depending on where the exception was thrown, the image cache may not have had
    // a chance to track the key in the cache at all. Schedule a microtask to give
    // the cache a chance to add the key.
    scheduleMicrotask(() {
      evictImage();
    });

    onFinish?.call(e);
    // chunkEvents.addError(e);
    rethrow; // <<< use rethrow is better than chunkEvents.addError
  } finally {
    await chunkEvents.close();
  }
}
