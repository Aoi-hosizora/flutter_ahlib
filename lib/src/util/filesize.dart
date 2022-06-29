/// Returns a formatted string value of given file size. Refers to:
/// https://github.com/synw/filesize/blob/master/lib/src/filesize.dart.
String filesize(int size, [int round = 2, bool space = true]) {
  int divider = 1024;

  if (size < divider) {
    return space ? '$size B' : '${size}B';
  }

  if (size < divider * divider) {
    var r = size / divider;
    var n = r.toStringAsFixed(size % divider == 0 ? 0 : round);
    return space ? '$n KB' : '${n}KB';
  }

  if (size < divider * divider * divider) {
    var r = size / divider / divider;
    var n = r.toStringAsFixed(size % divider == 0 ? 0 : round);
    return space ? '$n MB' : '${n}MB';
  }

  if (size < divider * divider * divider * divider) {
    var r = size / divider / divider / divider;
    var n = r.toStringAsFixed(size % divider == 0 ? 0 : round);
    return space ? '$n GB' : '${n}GB';
  }

  var r = size / divider / divider / divider / divider;
  var n = r.toStringAsFixed(size % divider == 0 ? 0 : round);
  return space ? '$n TB' : '${n}TB';
}
