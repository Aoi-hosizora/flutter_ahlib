import 'package:logger/logger.dart';

// Note: The file is based on leisim/logger, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - Logger: https://github.com/leisim/logger/blob/7e510ec1cb/lib/src/logger.dart
// - Logger: https://github.com/FMotalleb/logger/blob/5bf51b0f59/lib/src/logger_fork.dart

/// The signature for [OutputEvent] is generated, used by [ExtendedLogger].
typedef OutputEventCallback = void Function(OutputEvent event);

/// The global [ExtendedLogger] for assistant, you can set this field to a new logger.
var globalLogger = ExtendedLogger();

/// This is an extended [Logger] from https://github.com/leisim/logger, which contains
/// [addOutputListener] method.
class ExtendedLogger {
  final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;
  bool _active = true;

  /// Creates a new instance of Logger. Here [filter], [printer] and [output] defaults
  /// to [PrettyPrinter], [DevelopmentFilter] and [ConsoleOutput].
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
      throw ArgumentError('Log events cannot have Level.nothing');
    }

    var logEvent = LogEvent(level, message, error, stackTrace);
    if (_filter.shouldLog(logEvent)) {
      var output = _printer.log(logEvent);

      if (output.isNotEmpty) {
        var outputEvent = OutputEvent(level, output);
        // Issues with log output should NOT influence
        // the main software behavior.
        try {
          _output.output(outputEvent);
          _outputListeners.forEach((lis) => lis.call(outputEvent)); // <<< Added by AoiHosizora
        } catch (_) {
          // print(e); // <<< Commented by AoiHosizora
          // print(s);
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
