import 'dart:async';
import 'dart:io' show File;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path_;

// TODO add test

/// An enum type for [DownloadOption], which is used to describe how to download.
enum DownloadBehavior {
  /// Prefers using cache, if given cache key is not found in [CacheManager], it will download the file
  /// from network.
  preferUsingCache,

  /// Must use cache, if given cache key is not found in [CacheManager], it will throw [DownloadException]
  /// with [DownloadErrorType.cacheMiss].
  mustUseCache,

  /// Downloads in force, this will ignore any data which is stored in [CacheManager].
  forceDownload,
}

/// An enum type for [DownloadOption], which is used to describe how to handle when the given filepath
/// has already existed.
enum DownloadConflictBehavior {
  /// Does not allow overwriting, it will throw [DownloadException] with [DownloadErrorType.conflict].
  notAllow,

  /// Overwrites the old file directly.
  overwrite,

  /// Adds suffix to the basename of filepath, and the suffix is built by [DownloadOption.suffixBuilder].
  addSuffix,
}

/// The signature for redeciding filepath for saving, used by [DownloadOption] and [downloadFile].
typedef RedecideFilepathHandler = String Function(Map<String, String>? header, String? contentType);

/// The signature for handling filepath conflict, used by [DownloadOption] and [downloadFile].
typedef FilepathConflictHandler = Future<DownloadConflictBehavior> Function(String filepath);

/// The signature for building filepath suffix, used by [DownloadOption] and [downloadFile].
typedef FilepathSuffixBuilder = String Function(int index);

/// The default filepath conflict handler for [DownloadOption].
Future<DownloadConflictBehavior> _defaultConflictHandler(String filepath) async {
  return DownloadConflictBehavior.notAllow;
}

/// The default filepath suffix builder for [DownloadOption].
String _defaultSuffixBuilder(int index) {
  return ' ($index)';
}

/// A data class for [downloadFile], which is used to describe some downloading options.
class DownloadOption {
  const DownloadOption({
    this.behavior = DownloadBehavior.preferUsingCache,
    this.redecideHandler,
    this.ignoreHeadError = false,
    this.conflictHandler = _defaultConflictHandler,
    this.suffixBuilder = _defaultSuffixBuilder,
    this.alsoUpdateCache = false,
    this.maxAgeForCache = const Duration(days: 30),
    this.headTimeout,
    this.downloadTimeout,
  });

  /// The download behavior, defaults to [DownloadBehavior.preferUsingCache].
  final DownloadBehavior behavior;

  /// The filepath redeciding handler, usually for file extension checking, with the header of HEAD
  /// response and its Content-Type given, defaults to null.
  ///
  /// If this value is not null, an extra asynchronous http HEAD request will be sent. If it fails to
  /// get response and [ignoreHeadError] is true, null header and null contentType will be passed.
  final RedecideFilepathHandler? redecideHandler;

  /// The flag for ignoring errors when making http HEAD request, otherwise it will throw [DownloadException]
  /// with [DownloadErrorType.head].
  final bool ignoreHeadError;

  /// The filepath conflict handler, with conflicted filepath given, defaults to not allow overwriting.
  final FilepathConflictHandler conflictHandler;

  /// The filepath suffix builder, and this suffix will be added to the end of the basename of filepath,
  /// defaults to " ($index)". Note that is will only be used for [DownloadConflictBehavior.addSuffix].
  final FilepathSuffixBuilder suffixBuilder;

  /// The flag for updating cache only when data downloading is finished. Note that if valid data is
  /// found from cache and used to save file, the cache item will never be updated.
  final bool alsoUpdateCache;

  /// The max age duration for cache updating, defaults to `const Duration(days: 30)`.
  final Duration maxAgeForCache;

  /// The timeout duration of http HEAD request, defaults to do not check timeout.
  final Duration? headTimeout;

  /// The timeout duration of downloading file, defaults to do not check timeout.
  final Duration? downloadTimeout;
}

/// Downloads file from [url] with [headers] and saves to [filepath]. Here [cacheManager] defaults to
/// `DefaultCacheManager()`, and [cacheKey] defaults to [url], and [option] defines detailed downloading
/// option, such as downloading behaviors.
///
/// Note that this function will only throw exceptions with type of [DownloadException], you can perform
/// the corresponding operations by checking [DownloadException.type].
Future<File> downloadFile({
  required String url,
  required String filepath,
  Map<String, String>? headers,
  CacheManager? cacheManager,
  String? cacheKey,
  DownloadOption? option,
}) async {
  cacheManager ??= DefaultCacheManager();
  cacheKey ??= url;
  option ??= const DownloadOption();

  // 1. parse given url
  Uri uri;
  try {
    uri = Uri.parse(url);
  } catch (e, s) {
    throw DownloadException._fromError(e, s); // FormatException
  }

  // 2. make http HEAD request asynchronously
  Future<String> filepathFuture;
  if (option.redecideHandler == null) {
    filepathFuture = Future.value(filepath);
  } else {
    filepathFuture = Future<String>.microtask(() async {
      http.Response resp;
      try {
        var future = http.head(uri, headers: headers);
        if (option!.headTimeout != null) {
          future = future.timeout(option.headTimeout!);
        }
        resp = await future;
      } on TimeoutException catch (e, s) {
        throw DownloadException._head('Failed to make http HEAD request to "$url": timed out.', e, s);
      } catch (e, s) {
        throw DownloadException._head('Failed to make http HEAD request to "$url": $e.', e, s);
      }
      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw DownloadException._head('Got invalid status code ${resp.statusCode} from "$url".');
      }
      return option.redecideHandler!.call(resp.headers, resp.headers['content-type'] ?? '');
    }).onError((e, s) {
      if (!option!.ignoreHeadError) {
        return Future.error(DownloadException._fromError(e!, s), s);
      }
      return Future.value(option.redecideHandler!.call(null, null));
    });
  }

  // 3. check file existence asynchronously
  var fileFuture = filepathFuture.then((filepath) async {
    var newFile = File(filepath);
    if (await newFile.exists()) {
      var behavior = await option!.conflictHandler.call(filepath);
      switch (behavior) {
        case DownloadConflictBehavior.notAllow:
          throw DownloadException._conflict('File "$filepath" has already existed before saving.');
        case DownloadConflictBehavior.overwrite:
          await newFile.delete();
          break;
        case DownloadConflictBehavior.addSuffix:
          for (var i = 2;; i++) {
            var basename = path_.withoutExtension(filepath);
            var extension = path_.extension(filepath); // .xxx
            var fallbackFile = File('$basename${option.suffixBuilder(i)}$extension');
            if (!(await fallbackFile.exists())) {
              newFile = fallbackFile;
              break;
            }
          }
          break;
      }
    }
    await newFile.create(recursive: true);
    return newFile;
  }).onError((e, s) {
    return Future.error(DownloadException._fromError(e!, s), s);
  });

  try {
    // 4. check cache, save cached data to file
    if (option.behavior != DownloadBehavior.forceDownload) {
      var cached = await cacheManager.getFileFromCache(cacheKey);
      if (cached == null || cached.validTill.isBefore(DateTime.now())) {
        if (option.behavior == DownloadBehavior.mustUseCache) {
          throw DownloadException._cacheMiss('There is no valid data for "$cacheKey" in cache.');
        }
      } else {
        var destination = await fileFuture;
        return await cached.file.copy(destination.path);
      }
    }

    // 5. download data from url
    http.Response resp;
    try {
      var future = http.get(uri, headers: headers);
      if (option.downloadTimeout != null) {
        future = future.timeout(option.downloadTimeout!);
      }
      resp = await future;
    } on TimeoutException catch (e, s) {
      throw DownloadException._download('Failed to make http GET request to "$url": timed out.', e, s);
    } catch (e, s) {
      throw DownloadException._download('Failed to make http GET request to "$url": $e.', e, s);
    }
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw DownloadException._download('Got invalid status code ${resp.statusCode} from "$url".');
    }

    // 6. save downloaded data to file, update cache
    var data = resp.bodyBytes;
    if (option.alsoUpdateCache) {
      unawaited(cacheManager.putFile(url, data, key: cacheKey, maxAge: option.maxAgeForCache));
    }
    var targetFile = await fileFuture;
    return await targetFile.writeAsBytes(data, flush: true);
  } catch (e, s) {
    try {
      var targetFile = await fileFuture;
      await targetFile.delete(); // clear failed file
    } catch (_) {}
    throw DownloadException._fromError(e, s);
  }
}

/// An enum type for [DownloadException], which is used to describe the exception type when downloading.
enum DownloadErrorType {
  /// Represents exceptions occurred when http HEAD request is failed.
  head,

  /// Represents exceptions occurred when given filepath has already existed.
  conflict,

  /// Represents exceptions occurred when no valid data found in cache.
  cacheMiss,

  /// Represents exceptions occurred when http GET request for downloading is failed.
  download,

  /// Represents some other exceptions.
  other,
}

/// An exception type only used by [downloadFile], with [type] as its type and [message] as its message.
class DownloadException implements Exception {
  const DownloadException._head(this._message, [this._error, this._stackTrace]) : _type = DownloadErrorType.head;

  const DownloadException._conflict(this._message, [this._error, this._stackTrace]) : _type = DownloadErrorType.conflict;

  const DownloadException._cacheMiss(this._message, [this._error, this._stackTrace]) : _type = DownloadErrorType.cacheMiss;

  const DownloadException._download(this._message, [this._error, this._stackTrace]) : _type = DownloadErrorType.download;

  const DownloadException._other(this._message, [this._error, this._stackTrace]) : _type = DownloadErrorType.other;

  factory DownloadException._fromError(Object error, StackTrace stackTrace) {
    if (error is DownloadException) {
      return error;
    }
    return DownloadException._other(error.toString(), error, stackTrace);
  }

  final DownloadErrorType _type;
  final Object? _error;
  final StackTrace? _stackTrace;
  final String _message;

  /// Returns the type of this exception.
  DownloadErrorType get type => _type;

  /// Returns the origin error of this exception. This value must not be null when [type] equals to
  /// [DownloadErrorType.other], otherwise it may be null.
  Object? get error => _error;

  /// Returns the origin stack trace of this exception. This value must not be null when [type] equals to
  /// [DownloadErrorType.other], otherwise it may be null.
  StackTrace? get stackTrace => _stackTrace;

  /// Returns the message of this exception. This value will always be human-readable when [type] does
  /// not equal to [DownloadErrorType.other].
  String get message => _message;

  @override
  String toString() {
    var msg = 'DownloadException [$_type]: $message';
    if (_stackTrace != null) {
      msg += '\nSource stack:\n$stackTrace';
    }
    return msg;
  }
}
