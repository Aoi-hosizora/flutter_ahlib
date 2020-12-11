import 'dart:async' show Future, StreamController, scheduleMicrotask;
import 'dart:io' as io show File;
import 'dart:ui' as ui show Codec;

import 'package:flutter_ahlib/src/image/multi_image_stream_completer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http show head;

import 'local_network_image_provider.dart' as image_provider;

/// Default implementation of [image_provider.LocalOrNetworkImageProvider].
class LocalOrNetworkImageProvider extends ImageProvider<image_provider.LocalOrNetworkImageProvider> implements image_provider.LocalOrNetworkImageProvider {
  const LocalOrNetworkImageProvider({
    @required this.file,
    @required this.url,
    this.scale = 1.0,
    this.headers,
    this.cacheManager,
    this.onStartLoadingFile,
    this.onStartDownloadUrl,
    this.onFileLoaded,
    this.onUrlDownloaded,
  }) : assert(file != null || url != null, 'file and url must have one non-null');

  /// File of the image to load.
  @override
  final Future<io.File> Function() file;

  /// Web url of the image to load.
  @override
  final Future<String> Function() url;

  /// Scale of the image.
  @override
  final double scale;

  /// Headers for the image provided by network.
  @override
  final Map<String, String> headers;

  /// Cache manager.
  @override
  final BaseCacheManager cacheManager;

  /// The callback function when file start loading.
  @override
  final Function() onStartLoadingFile;

  /// The callback function when image start downloading.
  @override
  final Function() onStartDownloadUrl;

  /// Callback function when the image from file loaded.
  @override
  final Function() onFileLoaded;

  /// Callback function when the image from network downloaded.
  @override
  final Function() onUrlDownloaded;

  /// Override the [ImageProvider].
  @override
  Future<LocalOrNetworkImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LocalOrNetworkImageProvider>(this);
  }

  /// Override the [ImageProvider].
  @override
  ImageStreamCompleter load(image_provider.LocalOrNetworkImageProvider key, DecoderCallback decode) {
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

  /// Used in [MultiImageStreamCompleter] for [load].
  Stream<ui.Codec> _loadAsync(LocalOrNetworkImageProvider key, StreamController<ImageChunkEvent> chunkEvents, DecoderCallback decode) async* {
    assert(key == this);

    var fileFunc = key.file;
    var urlFunc = key.url;

    if (fileFunc != null) {
      var file = await fileFunc.call();
      assert(file == null || await file.exists());

      // use file
      if (file != null) {
        key.onStartLoadingFile?.call();
        try {
          // read the file from storage
          var bytes = await file.readAsBytes();
          var decoded = await decode(bytes);
          yield decoded;
        } catch (e) {
          // Depending on where the exception was thrown, the image cache may not
          // have had a chance to track the key in the cache at all.
          // Schedule a microtask to give the cache a chance to add the key.
          scheduleMicrotask(() {
            PaintingBinding.instance.imageCache.evict(key);
          });
          // chunkEvents.addError(e);
          rethrow;
        } finally {
          key.onFileLoaded?.call();
          await chunkEvents.close();
        }
        return;
      }
    }

    if (urlFunc != null) {
      var url = await urlFunc.call();
      assert(url == null || url.isNotEmpty);

      // use url
      if (url != null) {
        key.onStartDownloadUrl?.call();
        try {
          var mgr = key.cacheManager ?? DefaultCacheManager();
          var h = (key.headers ?? {})..['Accept-Encoding'] = '';
          var stream = mgr.getFileStream(url, withProgress: true, headers: h);

          // use head to get content length at the same time
          int contentLength;
          http.head(url, headers: {'Accept': '*/*', ...h}).then((data) {
            contentLength = int.tryParse(data.headers['content-length']);
          }).catchError((_) {});

          // await stream info
          await for (var result in stream) {
            if (result is DownloadProgress) {
              // print('${result.downloaded} ${result.totalSize} contentLength');
              chunkEvents.add(ImageChunkEvent(
                cumulativeBytesLoaded: result.downloaded,
                expectedTotalBytes: result.totalSize ?? contentLength,
              ));
            } else if (result is FileInfo) {
              // read the cache from storage
              var bytes = await result.file.readAsBytes();
              var decoded = await decode(bytes);
              yield decoded;
            }
          }
        } catch (e) {
          scheduleMicrotask(() {
            PaintingBinding.instance.imageCache.evict(key);
          });
          // chunkEvents.addError(e);
          rethrow;
        } finally {
          key.onUrlDownloaded?.call();
          await chunkEvents.close();
        }
      }
    }

    // (file is null or not found) && (url is null or empty)
    throw ArgumentError('items must have length 6');
  }

  @override
  bool operator ==(dynamic other) {
    if (other is LocalOrNetworkImageProvider) {
      // ATTENTION: url and file are all functions, so you must save the functions
      // before using this provider in order to reuse the ImageProvider from imageCache.
      return url == other.url && file == other.file && scale == other.scale;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(url, file, scale);

  @override
  String toString() => '$runtimeType(url: "$url", file: "$file", scale: $scale)';
}
