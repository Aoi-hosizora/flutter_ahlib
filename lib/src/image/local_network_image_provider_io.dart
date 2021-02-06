import 'dart:async' show Future, StreamController, scheduleMicrotask;
import 'dart:io' as io show File;
import 'dart:ui' as ui show Codec;

import 'package:flutter_ahlib/src/image/multi_image_stream_completer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http show head;

import 'local_network_image_provider.dart' as image_provider;

/// The default implementation of [image_provider.LocalOrNetworkImageProvider].
class LocalOrNetworkImageProvider extends ImageProvider<image_provider.LocalOrNetworkImageProvider> implements image_provider.LocalOrNetworkImageProvider {
  const LocalOrNetworkImageProvider({
    @required this.file,
    @required this.url,
    this.scale = 1.0,
    this.headers,
    this.cacheManager,
    this.onFileLoading,
    this.onNetworkLoading,
    this.onFileLoaded,
    this.onNetworkLoaded,
  })  : assert(file != null),
        assert(url != null);

  /// The file of the image to load.
  @override
  final Future<io.File> Function() file;

  /// The web url of the image to load.
  @override
  final Future<String> Function() url;

  /// The scale of the image.
  @override
  final double scale;

  /// The headers of the request used to fetch the network image.
  @override
  final Map<String, String> headers;

  /// The cache manager, uses [DefaultCacheManager] if null.
  @override
  final BaseCacheManager cacheManager;

  /// The callback function invoked when the local file starts to loading.
  @override
  final Function() onFileLoading;

  /// The callback function invoked when the network image start to download.
  @override
  final Function() onNetworkLoading;

  /// The callback function invoked when the local file loaded.
  @override
  final Function() onFileLoaded;

  /// The callback function invoked when the network image downloaded.
  @override
  final Function() onNetworkLoaded;

  /// Overrides the [ImageProvider].
  @override
  Future<LocalOrNetworkImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LocalOrNetworkImageProvider>(this);
  }

  /// Overrides the [ImageProvider].
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

  /// Loads image to [ui.Codec] stream, used in [load] and [MultiImageStreamCompleter].
  Stream<ui.Codec> _loadAsync(LocalOrNetworkImageProvider key, StreamController<ImageChunkEvent> chunkEvents, DecoderCallback decode) async* {
    assert(key == this);

    var file = await key.file.call();
    var url = await key.url.call();
    assert(file == null || await file.exists());
    assert(url == null || url.isNotEmpty);
    assert(file != null || url != null);

    // use file
    if (file != null) {
      onFileLoading?.call();
      try {
        var bytes = await file.readAsBytes();
        var decoded = await decode(bytes);
        yield decoded;
      } catch (e) {
        scheduleMicrotask(() {
          PaintingBinding.instance.imageCache.evict(key);
        });
        chunkEvents.addError(e);
      } finally {
        await chunkEvents.close();
        onFileLoaded?.call();
      }
      return;
    }

    // use url
    onNetworkLoading?.call();
    try {
      var mgr = cacheManager ?? DefaultCacheManager();
      var h = (headers ?? {})..['Accept-Encoding'] = '';
      var stream = mgr.getFileStream(url, withProgress: true, headers: h);

      // get file size from http head request at the same time
      int totalSize;
      http.head(url, headers: {
        'Accept': '*/*',
        ...h,
      }).then((data) {
        totalSize = int.tryParse(data.headers['content-length']);
      }).catchError((_) {}); // ignore error

      // await stream info
      await for (var result in stream) {
        if (result is DownloadProgress) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: result.downloaded,
            expectedTotalBytes: result.totalSize ?? totalSize,
          ));
        } else if (result is FileInfo) {
          var file = result.file;
          var bytes = await file.readAsBytes();
          var decoded = await decode(bytes);
          yield decoded;
        }
      }
    } catch (e) {
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      chunkEvents.addError(e);
    } finally {
      await chunkEvents.close();
      onNetworkLoaded?.call();
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (other is LocalOrNetworkImageProvider) {
      // ATTENTION: url and file are all functions, so you must save the functions to list
      // before using the ImageProvider, to avoid operator== returning false.
      return url == other.url && file == other.file && scale == other.scale;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(url, file, scale);
}
