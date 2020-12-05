import 'dart:async' show Future, StreamController;
import 'dart:io' as io show File;
import 'dart:ui' as ui show Codec;

import 'package:http/http.dart' as http show head;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'local_network_image_provider.dart' as image_provider;

/// Default implementation of [image_provider.LocalOrNetworkImageProvider].
class LocalOrNetworkImageProvider extends ImageProvider<image_provider.LocalOrNetworkImageProvider> implements image_provider.LocalOrNetworkImageProvider {
  const LocalOrNetworkImageProvider({
    @required this.file,
    @required this.url,
    this.headers,
    this.scale = 1.0,
    this.onFile,
    this.onNetwork,
    this.cacheManager,
  })  : assert(file != null),
        assert(url != null);

  /// File of the image to load.
  @override
  final Future<io.File> Function() file;

  /// url of the image to load.
  @override
  final Future<String> Function() url;

  /// Headers for the image provider from network.
  @override
  final Map<String, String> headers;

  /// Scale of the image.
  @override
  final double scale;

  /// Callback function when the image from file loaded.
  @override
  final Function() onFile;

  /// Callback function when the image from network downloaded.
  @override
  final Function() onNetwork;

  /// Cache manager.
  @override
  final DefaultCacheManager cacheManager;

  /// Override the [ImageProvider].
  @override
  Future<LocalOrNetworkImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LocalOrNetworkImageProvider>(this);
  }

  /// Override the [ImageProvider].
  @override
  ImageStreamCompleter load(image_provider.LocalOrNetworkImageProvider key, DecoderCallback decode) {
    final chunkEvents = StreamController<ImageChunkEvent>();
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode).first,
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

  /// Used in [MultiFrameImageStreamCompleter] for [load].
  Stream<ui.Codec> _loadAsync(LocalOrNetworkImageProvider key, StreamController<ImageChunkEvent> chunkEvents, DecoderCallback decode) async* {
    assert(key == this);

    var file = await this.file.call();
    var url = await key.url.call();
    assert(file == null || await file.exists());
    assert(url == null || url.isNotEmpty);
    assert(file != null || url != null);

    // use file
    if (file != null) {
      try {
        var bytes = await file.readAsBytes();
        var decoded = await decode(bytes);
        yield decoded;
      } catch (e) {
        chunkEvents.addError(e);
      } finally {
        onFile?.call();
        await chunkEvents.close();
      }
      return;
    }

    // use url
    try {
      var mgr = cacheManager ?? DefaultCacheManager();
      var h = (headers ?? {})..['Accept-Encoding'] = '';
      var stream = mgr.getFileStream(url, withProgress: true, headers: h);

      // get file size from http at the same time
      int totalSize;
      http.head(url, headers: {
        'Accept': '*/*',
        ...h,
      }).then((data) {
        totalSize = int.tryParse(data.headers['content-length']);
      }).catchError((_) {});

      // await stream info
      await for (var result in stream) {
        if (result is DownloadProgress) {
          // print('${result.downloaded} ${result.totalSize} $totalSize');
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: result.downloaded,
            expectedTotalBytes: result.totalSize ?? totalSize ?? 0,
          ));
        } else if (result is FileInfo) {
          var file = result.file;
          var bytes = await file.readAsBytes();
          var decoded = await decode(bytes);
          yield decoded;
        }
      }
    } catch (e) {
      chunkEvents.addError(e);
    } finally {
      onNetwork?.call();
      await chunkEvents.close();
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (other is LocalOrNetworkImageProvider) {
      return url == other.url && file == other.file;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(url, file);
}
