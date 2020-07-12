import 'dart:async' show Future, StreamController;
import 'dart:io' as io show File;
import 'dart:ui' as ui show Codec;

import 'package:http/http.dart' as http show head;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'local_network_image_provider.dart' as image_provider;

/// `image_provider.LocalOrNetworkImageProvider` implement
class LocalOrNetworkImageProvider extends ImageProvider<image_provider.LocalOrNetworkImageProvider>
    implements image_provider.LocalOrNetworkImageProvider {
  const LocalOrNetworkImageProvider({
    @required this.file,
    @required this.url,
    this.headers,
    this.onFile,
    this.onNetwork,
    this.cacheManager,
  })  : assert(file != null),
        assert(url != null);

  @override
  final Future<io.File> Function() file;
  @override
  final Future<String> Function() url;
  @override
  final Map<String, String> headers;
  @override
  final Function() onFile;
  @override
  final Function() onNetwork;
  @override
  final DefaultCacheManager cacheManager;

  @override
  Future<LocalOrNetworkImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LocalOrNetworkImageProvider>(this);
  }

  @override
  ImageStreamCompleter load(
    image_provider.LocalOrNetworkImageProvider key,
    DecoderCallback decode,
  ) {
    final chunkEvents = StreamController<ImageChunkEvent>();
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode).first,
      chunkEvents: chunkEvents.stream,
      scale: 1.0, // key.scale
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
    LocalOrNetworkImageProvider key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
  ) async* {
    assert(key == this);

    var file = await this.file.call();
    var url = await key.url.call();
    assert(file != null || (url != null && url.isNotEmpty));

    if (file != null && await file.exists()) {
      var bytes = await file.readAsBytes();
      var decoded = await decode(bytes);
      yield decoded;
      onFile?.call();
      return;
    }

    try {
      var mngr = cacheManager ?? DefaultCacheManager();
      var h = (headers ?? {})..['Accept-Encoding'] = '';
      var stream = mngr.getFileStream(url, withProgress: true, headers: h);

      int totalSize;
      http.head(url, headers: {
        'Accept': '*/*',
        'Accept-Encoding': '',
      }).then((data) {
        totalSize = int.tryParse(data.headers['content-length']);
      });

      await for (var result in stream) {
        if (result is DownloadProgress) {
          print('${result.downloaded} ${result.totalSize} $totalSize');
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
