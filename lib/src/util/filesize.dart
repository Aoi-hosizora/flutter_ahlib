/// [filesize] returns a string type of file size.
/// Reference from https://github.com/synw/filesize/blob/master/lib/src/filesize.dart.
String filesize(int size, [int round = 2]) {
  int divider = 1024;

  if (size < divider) {
    return "$size B";
  }

  if (size < divider * divider) {
    num r = size / divider;
    return "${r.toStringAsFixed(size % divider == 0 ? 0 : round)} KB";
  }

  if (size < divider * divider * divider) {
    num r = size / divider / divider;
    return "${r.toStringAsFixed(size % divider == 0 ? 0 : round)} MB";
  }

  if (size < divider * divider * divider * divider) {
    num r = size / divider / divider / divider;
    return "${r.toStringAsFixed(size % divider == 0 ? 0 : round)} GB";
  }

  num r = size / divider / divider / divider / divider;
  return "${r.toStringAsFixed(size % divider == 0 ? 0 : round)} TB";
}
