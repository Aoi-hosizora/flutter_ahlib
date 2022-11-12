import 'dart:async';
import 'dart:io' show File, HttpException;
import 'dart:typed_data';

import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

const _testImageUrl = 'https://user-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg';
const _testFakeUrl = 'https://userxxx-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg';
const _filePath = './test.jpg';

dynamic Function() _wrapFunction(Future<void> Function() f) {
  Future<void> _ensureDeleted(String filepath) async {
    var f = File(filepath);
    if (await f.exists()) {
      await f.delete();
    }
  }

  return () async {
    var cache = DefaultCacheManager();
    try {
      await _ensureDeleted(_filePath);
      await cache.removeFile(_testImageUrl);
      await cache.removeFile('key');
      await f();
    } finally {
      await _ensureDeleted(_filePath);
      await cache.removeFile(_testImageUrl);
      await cache.removeFile('key');
    }
  };
}

Future<Uint8List> _toBytes(Stream<Uint8List> stream) async {
  var bytes = <int>[];
  await for (var bs in stream) {
    bytes.addAll(bs);
  }
  return Uint8List.fromList(bytes);
}

void _onFileLoading() => print('onFileLoading');

void _onFileLoaded(e) => print('onFileLoaded $e');

void _onUrlLoading() => print('onUrlLoading');

void _onUrlLoaded(e) => print('onUrlLoaded $e');

void main() {
  group('loadImage normal', () {
    test('load image file', _wrapFunction(() async {
      var f = File(_filePath);
      await f.writeAsBytes(List.generate(1024, (_) => 0));
      var bytes = await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(file: File(_filePath), url: _testImageUrl, onFileLoading: _onFileLoading)));
      expect(bytes.length, 1024);
    }));

    test('load image file (future)', _wrapFunction(() async {
      var f = File(_filePath);
      await f.writeAsBytes(List.generate(1024, (_) => 0));
      var bytes = await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(fileFuture: Future.value(File(_filePath)), urlFuture: Future.value(null), onFileLoaded: _onFileLoaded)));
      expect(bytes.length, 1024);
    }));

    test('download image', _wrapFunction(() async {
      var bytes = await _toBytes(loadLocalOrNetworkImageBytes(option: const LoadImageOption(url: _testImageUrl, asyncHeadFirst: true, onUrlLoading: _onUrlLoading)));
      expect(bytes.isNotEmpty, true);
      var info = await DefaultCacheManager().getFileFromCache(_testImageUrl);
      expect(info != null, true);
      expect((await info!.file.stat()).size, bytes.length);
    }));

    test('download image (future)', _wrapFunction(() async {
      var bytes = await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(fileFuture: Future.value(null), urlFuture: Future.value(_testImageUrl), onUrlLoaded: _onUrlLoaded)));
      expect(bytes.isNotEmpty, true);
      var info = await DefaultCacheManager().getFileFromCache(_testImageUrl);
      expect(info != null, true);
      expect((await info!.file.stat()).size, bytes.length);
    }));

    test('load from cache', _wrapFunction(() async {
      await DefaultCacheManager().putFile(_testImageUrl, Uint8List(1024), key: 'key');
      var bytes = await _toBytes(loadLocalOrNetworkImageBytes(option: const LoadImageOption(url: _testImageUrl, cacheKey: 'key', onUrlLoading: _onUrlLoading)));
      expect(bytes.length, 1024);
    }));

    test('load from cache (future)', _wrapFunction(() async {
      await DefaultCacheManager().putFile(_testImageUrl, Uint8List(1024), key: 'key');
      var bytes = await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(fileFuture: Future.value(null), urlFuture: Future.value(_testImageUrl), cacheKey: 'key', onUrlLoaded: _onUrlLoaded)));
      expect(bytes.length, 1024);
    }));

    test('download image as fallback', _wrapFunction(() async {
      var bytes = await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(file: File(_filePath), url: _testImageUrl, fileMustExist: false, onUrlLoading: _onUrlLoading)));
      expect(bytes.length > 1024, true);
    }));

    test('download image as fallback (future)', _wrapFunction(() async {
      var bytes = await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(fileFuture: Future.value(File(_filePath)), urlFuture: Future.value(_testImageUrl), fileMustExist: false, onUrlLoaded: _onUrlLoaded)));
      expect(bytes.length > 1024, true);
    }));
  });

  group('loadImage error', () {
    test('file not found', _wrapFunction(() async {
      try {
        await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(file: File(_filePath), fileMustExist: true, onFileLoaded: _onFileLoaded)));
      } catch (e) {
        print(e);
        expect(e is Exception, true);
        return;
      }
      fail('should throw Exception');
    }));

    test('file not found when fallback', _wrapFunction(() async {
      try {
        await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(file: File(_filePath), url: null, fileMustExist: false, onFileLoaded: _onFileLoaded)));
      } catch (e) {
        print(e);
        expect(e is Exception, true);
        return;
      }
      fail('should throw Exception');
    }));

    test('wrong url format', _wrapFunction(() async {
      try {
        await _toBytes(loadLocalOrNetworkImageBytes(option: const LoadImageOption(url: '::Not valid URI::', onUrlLoaded: _onUrlLoaded)));
      } catch (e) {
        print(e);
        expect(e is FormatException, true);
        return;
      }
      fail('should throw Exception');
    }));

    test('head or download error', _wrapFunction(() async {
      try {
        await _toBytes(loadLocalOrNetworkImageBytes(option: const LoadImageOption(url: _testFakeUrl, asyncHeadFirst: true, onUrlLoaded: _onUrlLoaded), evictImageAsync: () {}));
      } catch (e) {
        print(e);
        expect(e is HttpException, true);
        return;
      }
      fail('should throw Exception');
    }));

    test('download timeout', _wrapFunction(() async {
      try {
        await _toBytes(loadLocalOrNetworkImageBytes(option: const LoadImageOption(url: _testImageUrl, networkTimeout: Duration(milliseconds: 1)), evictImageAsync: () {}));
      } catch (e) {
        print(e);
        expect(e is TimeoutException, true);
        return;
      }
      fail('should throw Exception');
    }));

    test('not future wrong argument', _wrapFunction(() async {
      () async {
        try {
          await _toBytes(loadLocalOrNetworkImageBytes(option: const LoadImageOption(file: null, url: null))); // all null
        } catch (e) {
          print(e);
          expect(e is ArgumentError, true);
          return;
        }
        fail('should throw Exception');
      }();
      () async {
        try {
          await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(url: _testImageUrl, cacheManager: CacheManager(Config('x')), maxHeight: 1))); // wrong cache manager
        } catch (e) {
          print(e);
          expect(e is ArgumentError, true);
          return;
        }
        fail('should throw Exception');
      }();
    }));

    test('future wrong argument', _wrapFunction(() async {
      () async {
        try {
          await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(fileFuture: null, urlFuture: Future.value(null)))); // null future
        } catch (e) {
          print(e);
          expect(e is ArgumentError, true);
          return;
        }
        fail('should throw Exception');
      }();
      () async {
        try {
          await _toBytes(loadLocalOrNetworkImageBytes(option: LoadImageOption(fileFuture: Future.value(null), urlFuture: Future.value(null)))); // all results are null
        } catch (e) {
          print(e);
          expect(e is ArgumentError, true);
          return;
        }
        fail('should throw Exception');
      }();
    }));
  });
}
