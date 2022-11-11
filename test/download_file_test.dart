import 'dart:io' show File;
import 'dart:typed_data';

import 'package:flutter_ahlib/flutter_ahlib_util.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path_;

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
      await _ensureDeleted('./test.jpg');
      await _ensureDeleted('./test (2).jpg');
      await _ensureDeleted('./test (3).jpg');
      await cache.removeFile('key');
      await f();
    } finally {
      await _ensureDeleted('./test.jpg');
      await _ensureDeleted('./test (2).jpg');
      await _ensureDeleted('./test (3).jpg');
      await cache.removeFile('key');
    }
  };
}

Future<void> _expectFile(File f, String basename, {int? filesize}) async {
  expect(await f.exists(), true);
  expect(path_.basename(f.path), basename);
  if (filesize == null) {
    expect((await f.stat()).size > 0, true);
  } else if (filesize > 0) {
    expect((await f.stat()).size, filesize);
  } else {
    expect((await f.stat()).size != filesize, true);
  }
}

const _testImageUrl = 'https://user-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg';
const _testFakeUrl = 'https://userxxx-images.githubusercontent.com/31433480/139594297-c68369d4-32d9-4f8b-8727-ccaf2d1a53f6.jpg';

void main() {
  group('downloadFile_normal', () {
    test('normal_downloading', _wrapFunction(() async {
      var f = await downloadFile(url: _testImageUrl, filepath: './test.jpg');
      await _expectFile(f, 'test.jpg');
    }));

    test('prefer_cache', _wrapFunction(() async {
      await DefaultCacheManager().putFile(_testImageUrl, Uint8List(1024), key: 'key');
      var f = await downloadFile(url: _testImageUrl, filepath: './test.jpg', cacheKey: 'key', option: const DownloadOption(behavior: DownloadBehavior.preferUsingCache));
      await _expectFile(f, 'test.jpg', filesize: 1024); // == 1024 (use cache)
    }));

    test('force_download', _wrapFunction(() async {
      await DefaultCacheManager().putFile(_testImageUrl, Uint8List(1024), key: 'key');
      var f = await downloadFile(url: _testImageUrl, filepath: './test.jpg', cacheKey: 'key', option: const DownloadOption(behavior: DownloadBehavior.forceDownload));
      await _expectFile(f, 'test.jpg', filesize: -1024); // != 1024 (no use cache)
    }));

    test('redecide_filepath', _wrapFunction(() async {
      var f = await downloadFile(url: _testImageUrl, filepath: './test.xxx', option: DownloadOption(redecideHandler: (_, mime) => './test.${getPreferredExtensionFromMime(mime ?? '') ?? 'xxx'}'));
      await _expectFile(f, 'test.jpg');
    }));

    test('redecide_and_ignore_error', _wrapFunction(() async {
      var f = await downloadFile(url: _testImageUrl, filepath: './test.xxx', option: DownloadOption(redecideHandler: (_, __) => './test.jpg', ignoreHeadError: true, headTimeout: const Duration(milliseconds: 1)));
      await _expectFile(f, 'test.jpg');
    }));

    test('add_suffix', _wrapFunction(() async {
      await File('./test.jpg').create();
      await File('./test (2).jpg').create();
      var f = await downloadFile(url: _testImageUrl, filepath: './test.jpg', option: DownloadOption(conflictHandler: (_) async => DownloadConflictBehavior.addSuffix, suffixBuilder: (i) => ' ($i)' /* => default */));
      await _expectFile(f, 'test (3).jpg');
    }));

    test('update_cache', _wrapFunction(() async {
      var f = await downloadFile(url: _testImageUrl, filepath: './test.jpg', cacheKey: 'key', option: const DownloadOption(alsoUpdateCache: true, maxAgeForCache: Duration(seconds: 1)));
      await _expectFile(f, 'test.jpg');
      var info = await DefaultCacheManager().getFileFromCache('key');
      expect(info != null, true);
      expect((await info!.file.stat()).size, (await f.stat()).size);
      expect(info.validTill.subtract(const Duration(seconds: 1)).isBefore(DateTime.now()), true);
    }));
  });

  group('downloadFile_error', () {
    test('download_error', _wrapFunction(() async {
      try {
        await downloadFile(url: _testFakeUrl, filepath: './test.jpg');
      } on DownloadException catch (e) {
        print(e);
        expect(e.type == DownloadErrorType.download || e.type == DownloadErrorType.head, true);
        return;
      }
      fail('should throw DownloadException');
    }));

    test('notAllow_conflict', _wrapFunction(() async {
      await File('./test.jpg').create();
      try {
        await downloadFile(url: _testImageUrl, filepath: './test.jpg', option: DownloadOption(conflictHandler: (_) async => DownloadConflictBehavior.notAllow));
      } on DownloadException catch (e) {
        print(e);
        expect(e.type, DownloadErrorType.conflict);
        return;
      }
      fail('should throw DownloadException');
    }));

    test('cache_miss_not_found', _wrapFunction(() async {
      try {
        await downloadFile(url: _testImageUrl, filepath: './test.jpg', option: const DownloadOption(behavior: DownloadBehavior.mustUseCache));
      } on DownloadException catch (e) {
        print(e);
        expect(e.type, DownloadErrorType.cacheMiss);
        return;
      }
      fail('should throw DownloadException');
    }));

    test('cache_miss_invalid', _wrapFunction(() async {
      await DefaultCacheManager().putFile(_testImageUrl, Uint8List(1024), key: 'key', maxAge: const Duration(milliseconds: 500));
      await Future.delayed(const Duration(seconds: 1));
      try {
        await downloadFile(url: _testImageUrl, filepath: './test.jpg', option: const DownloadOption(behavior: DownloadBehavior.mustUseCache));
      } on DownloadException catch (e) {
        print(e);
        expect(e.type, DownloadErrorType.cacheMiss);
        return;
      }
      fail('should throw DownloadException');
    }));

    test('head_timeout', _wrapFunction(() async {
      try {
        await downloadFile(url: _testImageUrl, filepath: './test.xxx', option: DownloadOption(redecideHandler: (_, __) => '', ignoreHeadError: false, headTimeout: const Duration(milliseconds: 1)));
      } on DownloadException catch (e) {
        print(e);
        expect(e.type, DownloadErrorType.head);
        return;
      }
      fail('should throw DownloadException');
    }));

    test('download_timeout', _wrapFunction(() async {
      try {
        await downloadFile(url: _testImageUrl, filepath: './test.jpg', option: const DownloadOption(downloadTimeout: Duration(milliseconds: 1)));
      } on DownloadException catch (e) {
        print(e);
        expect(e.type, DownloadErrorType.download);
        return;
      }
      fail('should throw DownloadException');
    }));
  });
}
