import 'dart:async' show StreamController;
import 'dart:io' as io show File;
import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http show head;

/// A data class for [loadLocalOrNetworkImageBytes] and [loadLocalOrNetworkImageCodec], which is
/// used to describe some options, and has almost the same fields as [LocalOrCachedNetworkImageProvider].
class LoadImageOption {
  const LoadImageOption({
    this.file,
    this.url,
    this.fileFuture,
    this.urlFuture,
    this.scale = 1.0,
    this.fileMustExist = true,
    this.headers,
    this.cacheManager,
    this.cacheKey,
    this.maxWidth,
    this.maxHeight,
    this.asyncHeadFirst = false,
    this.networkTimeout,
    this.onFileLoading,
    this.onUrlLoading,
    this.onFileLoaded,
    this.onUrlLoaded,
  });

  bool get _useFuture => fileFuture != null || urlFuture != null;

  final io.File? file;
  final String? url;
  final Future<io.File?>? fileFuture;
  final Future<String?>? urlFuture;
  final double? scale;
  final bool fileMustExist;
  final Map<String, String>? headers;
  final BaseCacheManager? cacheManager;
  final String? cacheKey;
  final int? maxWidth;
  final int? maxHeight;
  final bool asyncHeadFirst;
  final Duration? networkTimeout;
  final void Function()? onFileLoading;
  final void Function()? onUrlLoading;
  final void Function(Object? err)? onFileLoaded;
  final void Function(Object? err)? onUrlLoaded;
}

/// Loads local image bytes or cached network image bytes, using given [option] and [chunkEvents].
/// If the image is downloaded, it will also be recorded to given [CacheManager].
Stream<Uint8List> loadLocalOrNetworkImageBytes({
  required LoadImageOption option,
  StreamController<ImageChunkEvent>? chunkEvents,
  void Function()? evictImageAsync,
}) async* {
  // 0. check option
  if (!option._useFuture && (option.file == null && option.url == null)) {
    throw ArgumentError('At most one of option.file and option.url can be null if not to use future.');
  }
  if (option._useFuture && (option.fileFuture == null || option.urlFuture == null)) {
    throw ArgumentError('Both of option.fileFuture and option.urlFuture can not be null if using future.');
  }

  // 1. get file and url
  io.File? file;
  String? url;
  if (!option._useFuture) {
    file = option.file;
    url = option.url;
  } else {
    file = await option.fileFuture!;
    url = await option.urlFuture!;
  }
  if (file == null && url == null) {
    throw ArgumentError('At most one of file and url can be null.');
  }

  // 2. check file and url validity
  var useFile = false;
  var useUrl = false;
  if (file == null) {
    useUrl = true;
  } else {
    var existed = false;
    try {
      existed = await file.exists();
    } catch (_) {
      if (option.fileMustExist) {
        rethrow; // throw exceptions if fileMustExist flag is true
      }
    }
    if (existed) {
      useFile = true;
    } else if (option.fileMustExist) {
      var ex = Exception('Image file "${file.path}" is not found.');
      option.onFileLoading?.call();
      option.onFileLoaded?.call(ex);
      throw ex;
    } else if (url != null) {
      useUrl = true;
    } else {
      var ex = Exception('Image file "${file.path}" is not found while given url is null.');
      option.onFileLoading?.call();
      option.onFileLoaded?.call(ex);
      throw ex;
    }
  }

  // load local image
  if (useFile) {
    option.onFileLoading?.call();
    yield* _loadLocalImageBytes(
      file: file!,
      chunkEvents: chunkEvents,
      evictImageAsync: evictImageAsync,
      onLoaded: option.onFileLoaded,
    );
  }

  // load cached network image
  if (useUrl) {
    option.onUrlLoading?.call();
    yield* _loadCachedNetworkImageBytes(
      url: url!,
      chunkEvents: chunkEvents,
      evictImageAsync: evictImageAsync,
      headers: option.headers,
      cacheManager: option.cacheManager,
      cacheKey: option.cacheKey,
      maxWidth: option.maxWidth,
      maxHeight: option.maxHeight,
      asyncHeadFirst: option.asyncHeadFirst,
      networkTimeout: option.networkTimeout,
      onLoaded: option.onUrlLoaded,
    );
  }
}

/// Loads local image codec or cached network image codec, using given [option] and [chunkEvents],
/// which is used by [LocalOrCachedNetworkImageProvider]. If the image is downloaded, it will also
/// be recorded to given [CacheManager].
Stream<ui.Codec> loadLocalOrNetworkImageCodec({
  required LoadImageOption options,
  required DecoderCallback decode,
  StreamController<ImageChunkEvent>? chunkEvents,
  void Function()? evictImageAsync,
}) async* {
  var stream = loadLocalOrNetworkImageBytes(
    option: options,
    chunkEvents: chunkEvents,
    evictImageAsync: evictImageAsync,
  );
  await for (var bytes in stream) {
    yield await decode(bytes);
  }
}

// load local image
Stream<Uint8List> _loadLocalImageBytes({
  required io.File file,
  StreamController<ImageChunkEvent>? chunkEvents,
  void Function()? evictImageAsync,
  required void Function(Object?)? onLoaded,
}) async* {
  try {
    yield await file.readAsBytes();
    onLoaded?.call(null);
  } catch (e) {
    evictImageAsync?.call();
    onLoaded?.call(e);
    rethrow; // <<< rethrow is better than chunkEvents.addError
  } finally {
    await chunkEvents?.close();
  }
}

// load cached network image
Stream<Uint8List> _loadCachedNetworkImageBytes({
  required String url,
  StreamController<ImageChunkEvent>? chunkEvents,
  void Function()? evictImageAsync,
  required Map<String, String>? headers,
  required BaseCacheManager? cacheManager,
  required String? cacheKey,
  required int? maxWidth,
  required int? maxHeight,
  required bool asyncHeadFirst,
  required Duration? networkTimeout,
  required void Function(Object?)? onLoaded,
}) async* {
  cacheManager ??= DefaultCacheManager();
  if ((maxWidth != null || maxHeight != null) && cacheManager is! ImageCacheManager) {
    throw ArgumentError('option.cacheManager must be an ImageCacheManager if want to resize the image.');
  }

  try {
    // get real size from http HEAD request asynchronously
    int? imageSize;
    if (asyncHeadFirst) {
      Future.microtask(() async {
        try {
          var response = await http.head(
            Uri.parse(url),
            headers: {'Accept': '*/*', ...(headers ?? {})},
          );
          var contentLength = response.headers['content-length'];
          if (contentLength != null) {
            imageSize = int.tryParse(contentLength);
          }
        } catch (_) {
          // ignore any error
        }
        if (imageSize == 0) {
          imageSize = null;
        }
      });
    }

    // get and await response stream
    Stream<FileResponse> stream = cacheManager is ImageCacheManager // (such as DefaultCacheManager)
        ? cacheManager.getImageFile(url, key: cacheKey, withProgress: true, headers: headers, maxWidth: maxWidth, maxHeight: maxHeight)
        : cacheManager.getFileStream(url, key: cacheKey, withProgress: true, headers: headers);
    if (networkTimeout != null) {
      stream = stream.timeout(networkTimeout);
    }
    await for (var result in stream) {
      if (result is DownloadProgress) {
        var ev = ImageChunkEvent(
          cumulativeBytesLoaded: result.downloaded,
          expectedTotalBytes: result.totalSize ?? imageSize,
        );
        chunkEvents?.add(ev);
      } else if (result is FileInfo) {
        var file = result.file;
        yield await file.readAsBytes();
      }
    }
    onLoaded?.call(null);
  } catch (e) {
    evictImageAsync?.call();
    onLoaded?.call(e);
    rethrow; // <<< rethrow is better than chunkEvents.addError
  } finally {
    await chunkEvents?.close();
  }
}
