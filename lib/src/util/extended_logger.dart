import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// Note: The file is based on leisim/logger and leisim/logger_flutter, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - Logger: https://github.com/leisim/logger/blob/7e510ec1cb/lib/src/logger.dart
// - Logger: https://github.com/FMotalleb/logger/blob/5bf51b0f59/lib/src/logger_fork.dart
// - AnsiParser: https://github.com/leisim/logger_flutter/blob/1e4d87d715/lib/src/ansi_parser.dart
// - AnsiParser: https://github.com/FMotalleb/logger_flutter/blob/5707c9e07b/lib/src/ansi_parser.dart

/// The signature for callbacks when [OutputEvent] is generated, used by [ExtendedLogger].
typedef OutputEventCallback = void Function(OutputEvent event);

/// The global [ExtendedLogger] for assistant, which defaults the default [ExtendedLogger].
/// You can replace this value to your own logger.
var globalLogger = ExtendedLogger();

/// This [Logger] is extended from https://github.com/leisim/logger, which contains some
/// new instance method for [OutputEvent], such as [addOutputListener].
class ExtendedLogger {
  final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;
  bool _active = true;

  /// Creates a new instance of [ExtendedLogger]. Here [filter], [printer] and [output]
  /// default to [PrettyPrinter], [DevelopmentFilter] and [ConsoleOutput].
  ExtendedLogger({
    LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level level = Level.verbose,
  })  : _filter = filter ?? DevelopmentFilter(),
        _printer = printer ?? PrettyPrinter(),
        _output = output ?? ConsoleOutput() {
    _filter.init();
    _filter.level = level;
    _printer.init();
    _output.init();
  }

  /// Logs a message at [Level.verbose] level.
  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.verbose, message, error, stackTrace);
  }

  /// Logs a message at [Level.debug] level.
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.debug, message, error, stackTrace);
  }

  /// Logs a message at [Level.info] level.
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.info, message, error, stackTrace);
  }

  /// Logs a message at [Level.warning] level.
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.warning, message, error, stackTrace);
  }

  /// Logs a message at [Level.error] level.
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.error, message, error, stackTrace);
  }

  /// Logs a message at [Level.wtf] level.
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(Level.wtf, message, error, stackTrace);
  }

  /// Logs a message at given [level].
  void log(Level level, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_active) {
      throw ArgumentError('Logger has already been closed.');
    }
    if (error != null && error is StackTrace) {
      throw ArgumentError('Error parameter cannot take a StackTrace!');
    }
    if (level == Level.nothing) {
      throw ArgumentError('Log events cannot have Level.nothing.');
    }

    var logEvent = LogEvent(level, message, error, stackTrace);
    if (_filter.shouldLog(logEvent)) {
      var output = _printer.log(logEvent);

      if (output.isNotEmpty) {
        var outputEvent = OutputEvent(level, output);
        // Issues with log output should NOT influence the main software behavior.
        try {
          _output.output(outputEvent);
        } catch (_) {}
        for (var lis in _outputListeners) {
          try {
            lis.call(outputEvent); // <<< Added by AoiHosizora
          } catch (_) {}
        }
      }
    }
  }

  // >>> Following code are added by AoiHosizora

  /// The list of output event listeners.
  final List<OutputEventCallback> _outputListeners = [];

  /// Adds a output event listener.
  void addOutputListener(OutputEventCallback listener) {
    _outputListeners.add(listener);
  }

  /// Removes a output event listener.
  void removeOutputListener(OutputEventCallback listener) {
    _outputListeners.remove(listener);
  }

  /// Removes all output event listeners.
  void clearOutputListeners() {
    _outputListeners.clear();
  }

  // <<< Above code are added by AoiHosizora

  /// Closes the logger and releases all resources.
  void close() {
    clearOutputListeners(); // <<< Added by AoiHosizora
    _active = false;
    _filter.destroy();
    _printer.destroy();
    _output.destroy();
  }
}

/// This class keeps almost the same as [AnsiParser] from https://github.com/leisim/logger_flutter,
/// which is used to render ANSI escape code to [TextSpan].
class AnsiLogParser {
  AnsiLogParser(this.darkMode);

  final bool darkMode;

  Color? foreground;
  Color? background;
  List<TextSpan> spans = [];

  static const _text = 0, _bracket = 1, _code = 2;

  void parse(String s) {
    spans = [];
    var state = _text;
    StringBuffer buffer = StringBuffer();
    var text = StringBuffer();
    var code = 0;
    List<int> codes = [];

    for (var i = 0, n = s.length; i < n; i++) {
      var c = s[i];
      switch (state) {
        case _text:
          if (c == '\u001b') {
            state = _bracket;
            buffer = StringBuffer(c);
            code = 0;
            codes = [];
          } else {
            text.write(c);
          }
          break;

        case _bracket:
          buffer.write(c);
          if (c == '[') {
            state = _code;
          } else {
            state = _text;
            text.write(buffer);
          }
          break;

        case _code:
          buffer.write(c);
          var codeUnit = c.codeUnitAt(0);
          if (codeUnit >= 48 && codeUnit <= 57) {
            code = code * 10 + codeUnit - 48;
            continue;
          } else if (c == ';') {
            codes.add(code);
            code = 0;
            continue;
          } else {
            if (text.isNotEmpty) {
              spans.add(_createSpan(text.toString()));
              text.clear();
            }
            state = _text;
            if (c == 'm') {
              codes.add(code);
              _handleCodes(codes);
            } else {
              text.write(buffer);
            }
          }
          break;
      }
    }

    spans.add(_createSpan(text.toString()));
  }

  TextSpan _createSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: foreground,
        backgroundColor: background,
      ),
    );
  }

  void _handleCodes(List<int> codes) {
    if (codes.isEmpty) {
      codes.add(0);
    }

    switch (codes[0]) {
      case 0:
        foreground = _getColor(0, true);
        background = _getColor(0, false);
        break;
      case 38:
        foreground = _getColor(codes[2], true);
        break;
      case 39:
        foreground = _getColor(0, true);
        break;
      case 48:
        background = _getColor(codes[2], false);
        break;
      case 49:
        background = _getColor(0, false);
    }
  }

  Color? _getColor(int colorCode, bool foreground) {
    switch (colorCode) {
      case 0:
        return foreground ? Colors.black : Colors.transparent;
      case 12:
        return darkMode ? Colors.lightBlue[300] : Colors.indigo[700];
      case 208:
        return darkMode ? Colors.orange[300] : Colors.orange[700];
      case 196:
        return darkMode ? Colors.red[300] : Colors.red[700];
      case 199:
        return darkMode ? Colors.pink[300] : Colors.pink[700];
      default:
        return foreground ? Colors.black : Colors.transparent; // TODO: check default color
    }
  }
}
