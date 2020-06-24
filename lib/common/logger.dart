import 'package:logger/logger.dart';

class _Logger extends LogPrinter {
  String tag;

  _Logger({this.tag = ''});

  @override
  void log(Level level, message, error, StackTrace stackTrace) {
    var color = PrettyPrinter.levelColors[level];
    var emoji = PrettyPrinter.levelEmojis[level];
    var now = DateTime.now().toString();
    if (tag == '') {
      tag = '*';
    }
    println(color('$now: $emoji [$tag] $message'));
  }
}

Logger loggerWithTag({String tag = ''}) {
  return Logger(printer: _Logger(tag: tag));
}
