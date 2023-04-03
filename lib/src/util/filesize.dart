const int _divider = 1024;
const int _divider2 = _divider * _divider;
const int _divider3 = _divider * _divider * _divider;
const int _divider4 = _divider * _divider * _divider * _divider;

String _filesize(int bytes, {int round = 2, bool mustRound = false, bool space = true}) {
  if (bytes < _divider) {
    return space ? '$bytes B' : '${bytes}B';
  }

  if (bytes < _divider2) {
    var r = bytes / _divider;
    var n = r.toStringAsFixed(!mustRound && (bytes % _divider == 0) ? 0 : round);
    return space ? '$n KB' : '${n}KB';
  }

  if (bytes < _divider3) {
    var r = bytes / _divider2;
    var n = r.toStringAsFixed(!mustRound && (bytes % _divider == 0) ? 0 : round);
    return space ? '$n MB' : '${n}MB';
  }

  if (bytes < _divider4) {
    var r = bytes / _divider3;
    var n = r.toStringAsFixed(!mustRound && (bytes % _divider == 0) ? 0 : round);
    return space ? '$n GB' : '${n}GB';
  }

  var r = bytes / _divider4;
  var n = r.toStringAsFixed(!mustRound && (bytes % _divider == 0) ? 0 : round);
  return space ? '$n TB' : '${n}TB';
}

/// Returns a formatted string value (such as "2 MB" and "2.34 KB") of given byte size.
String filesize(int bytes, [int round = 2, bool mustRound = false]) {
  return _filesize(bytes, round: round, mustRound: mustRound, space: true);
}

/// Returns a formatted string value (such as "2MB" and "2.34KB") of given byte size.
String filesizeWithoutSpace(int bytes, [int round = 2, bool mustRound = false]) {
  return _filesize(bytes, round: round, mustRound: mustRound, space: false);
}
