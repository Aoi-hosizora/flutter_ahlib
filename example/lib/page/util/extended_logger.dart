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
  var _printer = 'pretty';
  var _period = false;

  @override
  void initState() {
    super.initState();
    globalLogger = ExtendedLogger(
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

  void _doLog(Function(dynamic message, [dynamic error, StackTrace? stackTrace]) f, String s) {
    f(
      !_longText ? s : List.generate(5, (i) => '$s$s$s$i').join('\n'),
      !_testError ? null : ArgumentError(!_longText ? 'test error' : List.generate(5, (i) => 'test error $i').join('\n')),
      !_stackTrace ? null : StackTrace.current,
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
            OutlinedButton(child: const Text('v'), onPressed: () => _doLog(globalLogger.v, 'v')),
            OutlinedButton(child: const Text('d'), onPressed: () => _doLog(globalLogger.d, 'd')),
            OutlinedButton(child: const Text('i'), onPressed: () => _doLog(globalLogger.i, 'i')),
            OutlinedButton(child: const Text('w'), onPressed: () => _doLog(globalLogger.w, 'w')),
            OutlinedButton(child: const Text('e'), onPressed: () => _doLog(globalLogger.e, 'e')),
            OutlinedButton(child: const Text('wtf'), onPressed: () => _doLog(globalLogger.wtf, 'f')),
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
                  builder: (c) => _LogConsolePage(
                    onExport: (s) => printLog('onExport: s.length == ${s.length}'),
                  ),
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

class _LogConsolePage extends StatefulWidget {
  const _LogConsolePage({
    Key? key,
    this.onExport,
  }) : super(key: key);

  final void Function(String content)? onExport;

  @override
  State<_LogConsolePage> createState() => _LogConsolePageState();

  static var _initialized = false;
  static var _logger = globalLogger;
  static var _bufferSize = 20;
  static final _eventBuffer = ListQueue<Tuple2<DateTime, OutputEvent>>();

  static void initialize(ExtendedLogger logger, {int bufferSize = 20}) {
    if (!_initialized) {
      _initialized = true;
      _logger = logger;
      _bufferSize = bufferSize;
      _eventBuffer.clear();
      _logger.addOutputListener(_callback);
    }
  }

  static void finalize() {
    if (_initialized) {
      _logger.removeOutputListener(_callback);
      _eventBuffer.clear();
      _initialized = false;
    }
  }

  static void _callback(OutputEvent ev) {
    if (_eventBuffer.length == _bufferSize) {
      _eventBuffer.removeFirst();
    }
    _eventBuffer.add(Tuple2(DateTime.now(), ev));
  }
}

class _RenderedEvent {
  final Level level;
  final DateTime time;
  final String text;
  final String rendered;

  _RenderedEvent(this.level, this.time, this.text, this.rendered);
}

class _LogConsolePageState extends State<_LogConsolePage> {
  late final _scrollController = ScrollController()..addListener(_onScrolled);
  final _filterController = TextEditingController();

  final _renderedBuffer = ListQueue<_RenderedEvent>();
  final _filteredBuffer = <_RenderedEvent>[];
  var _filterLevel = Level.verbose;
  var _logFontSize = 14.0;

  var _enableScrollListener = true;
  var _followBottom = false;

  @override
  void initState() {
    super.initState();
    for (var ev in _LogConsolePage._eventBuffer) {
      _renderedBuffer.add(_renderEvent(ev.item1, ev.item2));
    }
    _updateFilteredBuffer();
    _LogConsolePage._logger.addOutputListener(_callback);
  }

  @override
  void dispose() {
    _LogConsolePage._logger.removeOutputListener(_callback);
    super.dispose();
  }

  void _callback(OutputEvent ev) {
    if (_renderedBuffer.length == _LogConsolePage._bufferSize) {
      _renderedBuffer.removeFirst();
    }
    _renderedBuffer.add(_renderEvent(DateTime.now(), ev));
    _updateFilteredBuffer();
  }

  _RenderedEvent _renderEvent(DateTime time, OutputEvent ev) {
    var text = ev.lines.join('\n');
    var plainText = ansiEscapeCodeToPlainText(text);
    var rendered = '[${ev.level.name}] [${time.toIso8601String()}]\n$plainText';
    return _RenderedEvent(ev.level, time, plainText, rendered);
  }

  void _updateFilteredBuffer() {
    var newBuffer = _renderedBuffer.where((ev) {
      if (ev.level.index < _filterLevel.index) {
        return false; // match level
      }
      if (_filterController.text.isEmpty) {
        return true; // empty filter query text
      }
      var query = _filterController.text;
      return ev.text.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _filteredBuffer.clear();
    _filteredBuffer.addAll(newBuffer);
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
              _renderedBuffer.clear();
              _filteredBuffer.clear();
              _LogConsolePage._eventBuffer.clear();
              setState(() {});
            },
          ),
          if (widget.onExport != null)
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: 'Export logs',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => SimpleDialog(
                    title: const Text('Export logs'),
                    children: [
                      TextDialogOption(
                        text: const Text('All logs'),
                        onPressed: () {
                          Navigator.of(c).pop();
                          widget.onExport!.call(_renderedBuffer.map((e) => e.text).join('\n'));
                        },
                      ),
                      TextDialogOption(
                        text: const Text('Only filtered logs'),
                        onPressed: () {
                          Navigator.of(c).pop();
                          widget.onExport!.call(_filteredBuffer.map((e) => e.text).join('\n'));
                        },
                      )
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1600,
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              scrollDirection: Axis.vertical,
              child: SelectableText(
                _filteredBuffer.map((el) => el.rendered).join('\n'),
                style: TextStyle(fontSize: _logFontSize),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          height: kToolbarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: _filterController,
                  onChanged: (s) => _updateFilteredBuffer(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Filter log output',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<Level>(
                value: _filterLevel,
                items: const [
                  DropdownMenuItem(child: Text('VERBOSE'), value: Level.verbose),
                  DropdownMenuItem(child: Text('DEBUG'), value: Level.debug),
                  DropdownMenuItem(child: Text('INFO'), value: Level.info),
                  DropdownMenuItem(child: Text('WARNING'), value: Level.warning),
                  DropdownMenuItem(child: Text('ERROR'), value: Level.error),
                  DropdownMenuItem(child: Text('WTF'), value: Level.wtf),
                ],
                underline: Container(color: Colors.transparent),
                onChanged: (value) {
                  _filterLevel = value ?? Level.info;
                  _updateFilteredBuffer();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _followBottom ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: FloatingActionButton(
          mini: true,
          clipBehavior: Clip.antiAlias,
          child: const Icon(Icons.arrow_downward),
          onPressed: _scrollToBottom,
        ),
      ),
    );
  }
}
