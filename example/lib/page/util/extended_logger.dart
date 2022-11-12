import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';
import 'package:logger/logger.dart';

class ExtendedLoggerPage extends StatefulWidget {
  const ExtendedLoggerPage({Key? key}) : super(key: key);

  @override
  State<ExtendedLoggerPage> createState() => _ExtendedLoggerPageState();
}

class PrintLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    var text = event.lines.join('\n');
    var plainText = ansiEscapeCodeToPlainText(text);
    printLog(plainText, alsoPrint: false, logPrefix: false);
  }
}

class _ExtendedLoggerPageState extends State<ExtendedLoggerPage> {
  var _longText = false;
  var _testError = false;
  var _stackTrace = false;
  var _ignoreOutput = false;
  var _printer = 'pretty';
  var _period = false;

  @override
  void initState() {
    super.initState();
    globalLogger = ExtendedLogger(
      filter: ProductionFilter(),
      output: MultiOutput([ConsoleOutput(), PrintLogOutput()]),
      printer: PrettyPrinter(printTime: true),
    );
    _LogConsolePage.initialize(globalLogger);
  }

  @override
  void dispose() {
    _LogConsolePage.finalize();
    super.dispose();
  }

  void _doLog(Function(dynamic message, [dynamic error, StackTrace? stackTrace, bool? ignoreOnce]) f, String s) {
    f(
      !_longText ? s : List.generate(5, (i) => '$s$s$s$i').join('\n'),
      !_testError ? null : ArgumentError(!_longText ? 'test error' : List.generate(5, (i) => 'test error $i').join('\n')),
      !_stackTrace ? null : StackTrace.current,
      _ignoreOutput,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExtendedLogger Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CheckboxListTile(
              title: const Text('use long text'),
              value: _longText,
              onChanged: (v) => mountedSetState(() => _longText = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('with test error'),
              value: _testError,
              onChanged: (v) => mountedSetState(() => _testError = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('with stack trace'),
              value: _stackTrace,
              onChanged: (v) => mountedSetState(() => _stackTrace = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('ignore output'),
              value: _ignoreOutput,
              onChanged: (v) => mountedSetState(() => _ignoreOutput = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Row(
              children: [
                const SizedBox(width: 25),
                Text('printer type :', style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _printer,
                  items: const [
                    DropdownMenuItem(child: Text('pretty'), value: 'pretty'),
                    DropdownMenuItem(child: Text('simple'), value: 'simple'),
                    DropdownMenuItem(child: Text('logfmt'), value: 'logfmt'),
                    DropdownMenuItem(child: Text('prefix (pretty)'), value: 'prefix (pretty)'),
                    DropdownMenuItem(child: Text('prefix (simple)'), value: 'prefix (simple)'),
                    DropdownMenuItem(child: Text('preferred'), value: 'preferred'),
                  ],
                  underline: Container(color: Colors.transparent),
                  onChanged: (value) {
                    _printer = value ?? 'pretty';
                    if (mounted) setState(() {});
                    switch (_printer) {
                      case 'simple':
                        globalLogger.changePrinter(SimplePrinter(printTime: true));
                        break;
                      case 'logfmt':
                        globalLogger.changePrinter(LogfmtPrinter());
                        break;
                      case 'prefix (pretty)':
                        globalLogger.changePrinter(PrefixPrinter(PrettyPrinter(printEmojis: false)));
                        break;
                      case 'prefix (simple)':
                        globalLogger.changePrinter(PrefixPrinter(SimplePrinter(printTime: false)));
                        break;
                      case 'preferred':
                        globalLogger.changePrinter(PreferredPrinter());
                        break;
                      case 'pretty':
                      default:
                        globalLogger.changePrinter(PrettyPrinter(printTime: true));
                        break;
                    }
                  },
                ),
              ],
            ),
            const Divider(),
            OutlinedButton(child: const Text('logger.v'), onPressed: () => _doLog(globalLogger.v, 'v')),
            OutlinedButton(child: const Text('logger.d'), onPressed: () => _doLog(globalLogger.d, 'd')),
            OutlinedButton(child: const Text('logger.i'), onPressed: () => _doLog(globalLogger.i, 'i')),
            OutlinedButton(child: const Text('logger.w'), onPressed: () => _doLog(globalLogger.w, 'w')),
            OutlinedButton(child: const Text('logger.e'), onPressed: () => _doLog(globalLogger.e, 'e')),
            OutlinedButton(child: const Text('logger.wtf'), onPressed: () => _doLog(globalLogger.wtf, 'f')),
            OutlinedButton(
              child: Text('period - ${_period ? "on" : "off"}'),
              onPressed: () async {
                _period = !_period;
                if (mounted) setState(() {});
                while (_period) {
                  await Future.delayed(const Duration(seconds: 2));
                  if (_period) {
                    _doLog(globalLogger.i, 'per');
                  }
                }
              },
            ),
            const Divider(),
            OutlinedButton(
              child: const Text('Goto log console page'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => const _LogConsolePage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The follow code is based on leisim/logger_flutter and fmotalleb/logger_flutter, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in these classes keeps the same as the following source codes:
// - LogConsole: https://github.com/leisim/logger_flutter/blob/1e4d87d715/lib/src/log_console.dart
// - LogConsole: https://github.com/FMotalleb/logger_flutter/blob/5707c9e07b/lib/src/log_console.dart

class _PlainOutputEvent {
  final OutputEvent origin;
  final String plainText;

  _PlainOutputEvent(this.origin, this.plainText);
}

class _LogConsolePage extends StatefulWidget {
  const _LogConsolePage({Key? key}) : super(key: key);

  @override
  State<_LogConsolePage> createState() => _LogConsolePageState();

  static var initialized = false;
  static var _logger = globalLogger;
  static var _bufferSize = 20;
  static final _eventBuffer = ListQueue<_PlainOutputEvent>();

  static void initialize(ExtendedLogger logger, {int bufferSize = 20}) {
    if (!initialized) {
      initialized = true;
      _logger = logger;
      _bufferSize = bufferSize;
      _eventBuffer.clear();
      _logger.addOutputListener(_callback);
    }
  }

  static void finalize() {
    if (initialized) {
      _logger.removeOutputListener(_callback);
      _eventBuffer.clear();
      initialized = false;
    }
  }

  static void _callback(OutputEvent ev) {
    if (_eventBuffer.length == _bufferSize) {
      _eventBuffer.removeFirst();
    }
    var text = ev.lines.join('\n');
    var plainText = ansiEscapeCodeToPlainText(text);
    _eventBuffer.add(_PlainOutputEvent(ev, plainText));
  }
}

class _LogConsolePageState extends State<_LogConsolePage> {
  final _scrollController = ScrollController();
  final _filterController = TextEditingController();

  final _filteredBuffer = <_PlainOutputEvent>[];
  var _filterLevel = Level.verbose;
  var _logFontSize = 14.0;

  var _enableScrollListener = true;
  var _followBottom = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.addListener(_onScrolled);
      _updateFilteredBuffer();
      _LogConsolePage._logger.addOutputListener(_callback);
    });
  }

  @override
  void dispose() {
    _LogConsolePage._logger.removeOutputListener(_callback);
    _scrollController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  void _callback(OutputEvent ev) {
    _updateFilteredBuffer();
  }

  void _updateFilteredBuffer() {
    var filtered = _LogConsolePage._eventBuffer.where((ev) {
      if (ev.origin.level.index < _filterLevel.index) {
        return false; // match level
      }
      if (_filterController.text.isEmpty) {
        return true; // empty filter query text
      }
      return ev.plainText.toLowerCase().contains(_filterController.text.toLowerCase());
    });
    _filteredBuffer.clear();
    _filteredBuffer.addAll(filtered);
    if (mounted) setState(() {});

    if (_followBottom) {
      _scrollToBottom();
    }
  }

  void _onScrolled() {
    if (_enableScrollListener) {
      _followBottom = _scrollController.offset >= _scrollController.position.maxScrollExtent;
      if (mounted) setState(() {});
    }
  }

  void _scrollToBottom() async {
    _enableScrollListener = false;
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _scrollController.scrollToBottom();
      _enableScrollListener = true;
      _onScrolled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Larger text',
            onPressed: () => mountedSetState(() => _logFontSize++),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Smaller text',
            onPressed: () => mountedSetState(() => _logFontSize--),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: () {
              _filteredBuffer.clear();
              _LogConsolePage._eventBuffer.clear();
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Export logs',
            onPressed: () => showDialog(
              context: context,
              builder: (c) => SimpleDialog(
                title: const Text('Export logs'),
                children: [
                  TextDialogOption(
                    text: const Text('All logs'),
                    onPressed: () {
                      Navigator.of(c).pop();
                      var logs = _LogConsolePage._eventBuffer.map((e) => e.plainText).join('\n');
                      printLog('export: logs.length == ${logs.length}');
                    },
                  ),
                  TextDialogOption(
                    text: const Text('Only filtered logs'),
                    onPressed: () {
                      Navigator.of(c).pop();
                      var logs = _filteredBuffer.map((e) => e.plainText).join('\n');
                      printLog('export: logs.length == ${logs.length}');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 2000,
                    child: SelectableText(
                      _filteredBuffer.map((el) => el.plainText).join('\n'),
                      style: TextStyle(fontFamily: 'monospace', fontSize: _logFontSize),
                    ),
                  ),
                ),
              ),
            ),
          ),
          BottomAppBar(
            color: Colors.white,
            child: Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _filterController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Filter log...',
                      ),
                      style: const TextStyle(fontSize: 20),
                      onChanged: (s) => _updateFilteredBuffer(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<Level>(
                    value: _filterLevel,
                    items: const [
                      DropdownMenuItem(child: Text('verbose'), value: Level.verbose),
                      DropdownMenuItem(child: Text('debug'), value: Level.debug),
                      DropdownMenuItem(child: Text('info'), value: Level.info),
                      DropdownMenuItem(child: Text('warning'), value: Level.warning),
                      DropdownMenuItem(child: Text('error'), value: Level.error),
                      DropdownMenuItem(child: Text('wtf'), value: Level.wtf),
                    ],
                    underline: Container(color: Colors.transparent),
                    onChanged: (value) {
                      if (value != null) {
                        _filterLevel = value;
                        _updateFilteredBuffer();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _followBottom ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: FloatingActionButton(
          child: const Icon(Icons.arrow_downward),
          heroTag: null,
          mini: true,
          onPressed: _scrollToBottom,
        ),
      ),
    );
  }
}
