import 'package:logger/logger.dart';

// Note: The file is partly based on leisim/logger and FMotalleb/logger, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - Logger: https://github.com/leisim/logger/blob/7e510ec1cb/lib/src/logger.dart
// - Logger: https://github.com/FMotalleb/logger/blob/5bf51b0f59/lib/src/logger_fork.dart

/// The signature for callbacks when [OutputEvent] is generated, used by [ExtendedLogger].
typedef OutputEventCallback = void Function(OutputEvent event);

/// The global [ExtendedLogger] for assistant, which defaults the default [ExtendedLogger].
/// You can replace this value to your own logger.
var globalLogger = ExtendedLogger();

/// This [Logger] is extended from https://github.com/leisim/logger, which contains some
/// new instance method, such as [changePrinter] and [addOutputListener].
class ExtendedLogger {
  final LogFilter _filter;
  LogPrinter _printer;
  LogOutput _output;
  bool _active = true;

  /// Creates a new instance of [ExtendedLogger]. Here [filter], [printer] and [output]
  /// default to [DevelopmentFilter], [PrettyPrinter] and [ConsoleOutput].
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

  /// Changes current [LogPrinter] to given [printer].
  void changePrinter(LogPrinter printer) {
    var oldPrinter = _printer;
    printer.init();
    _printer = printer;
    oldPrinter.destroy();
  }

  /// Changes current [LogOutput] to given [output].
  void changeOutput(LogOutput output) {
    var oldOutput = _output;
    output.init();
    _output = output;
    oldOutput.destroy();
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

/// Parses given text which contains ANSI escape code to plain text.
String ansiEscapeCodeToPlainText(String s) {
  return s.replaceAll(RegExp('\x1b\\[.+?m'), '');
}

/// This is an implementation of [LogPrinter], which is preferred by Aoi-Hosizora :)
///
/// Format:
/// ```
/// [DBG] [00:05:56] xxx
///                  xxx
///          [Error] xxx
///                  xxx
///          [Trace] xxx
///                  xxx
///                  xxx
/// ```
class PreferredPrinter extends LogPrinter {
  PreferredPrinter({
    this.printError = true,
    this.printTrace = true,
    this.timeOnly = true,
    this.errorMaxLines = 8,
    this.traceMaxLines = 8,
  }) : super();

  /// The flag to print error message.
  final bool printError;

  /// The flag to print stack trace.
  final bool printTrace;

  /// The flag to print time rather than date-time.
  final bool timeOnly;

  /// The max lines count of error message.
  final int errorMaxLines;

  /// The max lines count of stack trace.
  final int traceMaxLines;

  late final _levelMap = <Level, String>{
    Level.verbose: 'VBS',
    Level.debug: 'DBG',
    Level.info: 'INF',
    Level.warning: 'WRN',
    Level.error: 'ERR',
    Level.wtf: 'WTF',
  };

  String _twoDigit(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  List<String> log(LogEvent event) {
    var now = DateTime.now();
    var mLines = event.message.toString().split('\n');
    if (mLines.isEmpty) {
      return [];
    }

    var levelString = _levelMap[event.level] ?? '?';
    var timeString = timeOnly
        ? '${_twoDigit(now.hour)}:${_twoDigit(now.minute)}:${_twoDigit(now.second)}' //
        : '${_twoDigit(now.month)}/${_twoDigit(now.day)} ${_twoDigit(now.hour)}:${_twoDigit(now.minute)}:${_twoDigit(now.second)}';
    var mPrefix = '[$levelString] [$timeString] '; // "[DBG] [00:05:56] " / "[DBG] [2022/11/11 00:05:56] "
    var out = <String>[
      '$mPrefix${mLines.first}',
      for (int i = 1; i < mLines.length; i++) ' ' * mPrefix.length + mLines[i],
    ];

    if (printError && event.error != null) {
      var eLines = event.error.toString().split('\n');
      if (eLines.isNotEmpty) {
        var ePrefix = ' ' * (mPrefix.length - 8) + '[Error] '; // "         [Error] " / "                    [Error] "
        out.addAll([
          '$ePrefix${eLines.first}',
          for (int i = 1; i < eLines.length && i < errorMaxLines; i++) ' ' * ePrefix.length + eLines[i],
        ]);
      }
    }

    if (printTrace && event.stackTrace != null) {
      var tLines = event.stackTrace.toString().split('\n');
      if (tLines.isNotEmpty) {
        var tPrefix = ' ' * (mPrefix.length - 8) + '[Trace] '; // "         [Trace] " / "                    [Trace] "
        out.addAll([
          '$tPrefix${tLines.first}',
          for (int i = 1; i < tLines.length && i < traceMaxLines; i++) ' ' * tPrefix.length + tLines[i],
        ]);
      }
    }

    return out;
  }
}
