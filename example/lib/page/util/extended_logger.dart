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

class _ExtendedLoggerPageState extends State<ExtendedLoggerPage> {
  var _longText = false;
  var _testError = false;
  var _stackTrace = false;

  var _darkMode = false;
  var _showCloseButton = false;
  var _showClearButton = true;

  @override
  void initState() {
    super.initState();
    _LogConsolePage.initialize(globalLogger);
  }

  void _doLog(Function(dynamic message, [dynamic error, StackTrace? stackTrace]) f, String s) {
    f(
      !_longText ? s : '$s$s$s\n' * 5,
      !_testError ? null : ArgumentError(!_longText ? 'test error' : 'test error\n' * 5),
      !_stackTrace ? null : StackTrace.current,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExtendedLogger Example'),
      ),
      body: Center(
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
            const Divider(),
            OutlinedButton(child: const Text('v'), onPressed: () => _doLog(globalLogger.v, 'v')),
            OutlinedButton(child: const Text('d'), onPressed: () => _doLog(globalLogger.d, 'd')),
            OutlinedButton(child: const Text('i'), onPressed: () => _doLog(globalLogger.i, 'i')),
            OutlinedButton(child: const Text('w'), onPressed: () => _doLog(globalLogger.w, 'w')),
            OutlinedButton(child: const Text('e'), onPressed: () => _doLog(globalLogger.e, 'e')),
            OutlinedButton(child: const Text('wtf'), onPressed: () => _doLog(globalLogger.wtf, 'f')),
            const Divider(),
            CheckboxListTile(
              title: const Text('dark mode'),
              value: _darkMode,
              onChanged: (v) => mountedSetState(() => _darkMode = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('show close button'),
              value: _showCloseButton,
              onChanged: (v) => mountedSetState(() => _showCloseButton = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('show clear button'),
              value: _showClearButton,
              onChanged: (v) => mountedSetState(() => _showClearButton = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            OutlinedButton(
              child: const Text('Goto log console page'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => _LogConsolePage(
                    darkMode: _darkMode,
                    showCloseButton: _showCloseButton,
                    showClearButton: _showClearButton,
                    onExport: (s) => printLog('${"=" * 20}\n$s\n${'=' * 20}'),
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
    this.darkMode = false,
    this.showCloseButton = false,
    this.showClearButton = true,
    this.onExport,
  }) : super(key: key);

  final bool darkMode;
  final bool showCloseButton;
  final bool showClearButton;
  final void Function(String content)? onExport;

  @override
  State<_LogConsolePage> createState() => _LogConsolePageState();

  static var _initialized = false;
  static final _outputEventBuffer = ListQueue<OutputEvent>();
  static late final ExtendedLogger _logger;
  static int _bufferSize = 20;

  static void initialize(ExtendedLogger logger, {int bufferSize = 20}) {
    if (_initialized) {
      return;
    }

    _initialized = true;
    _logger = logger;
    _bufferSize = bufferSize;

    _logger.addOutputListener((event) {
      if (_outputEventBuffer.length == bufferSize) {
        _outputEventBuffer.removeFirst();
      }
      _outputEventBuffer.add(event);
    });
  }
}

class _RenderedEvent {
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;

  _RenderedEvent(this.id, this.level, this.span, this.lowerCaseText);
}

class _LogConsolePageState extends State<_LogConsolePage> {
  late OutputEventCallback _callback;

  final ListQueue<_RenderedEvent> _renderedBuffer = ListQueue();
  List<_RenderedEvent> _filteredBuffer = [];

  final _scrollController = ScrollController();
  final _filterController = TextEditingController();

  Level _filterLevel = Level.verbose;
  double _logFontSize = 14;

  var _currentId = 0;
  bool _scrollListenerEnabled = true;
  bool _followBottom = true;

  @override
  void initState() {
    super.initState();

    _callback = (e) {
      if (_renderedBuffer.length == _LogConsolePage._bufferSize) {
        _renderedBuffer.removeFirst();
      }
      _renderedBuffer.add(_renderEvent(e));
      _refreshFilter();
    };

    _LogConsolePage._logger.addOutputListener(_callback);

    _scrollController.addListener(() {
      if (!_scrollListenerEnabled) return;
      var scrolledToBottom = _scrollController.offset >= _scrollController.position.maxScrollExtent;
      setState(() {
        _followBottom = scrolledToBottom;
      });
    });
  }

  @override
  void dispose() {
    _LogConsolePage._logger.removeOutputListener(_callback);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _renderedBuffer.clear();
    for (var event in _LogConsolePage._outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }
    _refreshFilter();
  }

  void _refreshFilter() {
    var newFilteredBuffer = _renderedBuffer.where((it) {
      var logLevelMatches = it.level.index >= _filterLevel.index;
      if (!logLevelMatches) {
        return false;
      } else if (_filterController.text.isNotEmpty) {
        var filterText = _filterController.text.toLowerCase();
        return it.lowerCaseText.contains(filterText);
      } else {
        return true;
      }
    }).toList();
    setState(() {
      _filteredBuffer = newFilteredBuffer;
    });

    if (_followBottom) {
      Future.delayed(Duration.zero, _scrollToBottom);
    }
  }

  void _scrollToBottom() async {
    _scrollListenerEnabled = false;

    setState(() {
      _followBottom = true;
    });

    var scrollPosition = _scrollController.position;
    await _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    _scrollListenerEnabled = true;
  }

  _RenderedEvent _renderEvent(OutputEvent event) {
    var parser = AnsiLogParser(widget.darkMode);
    var text = event.lines.join('\n');
    parser.parse(text);
    return _RenderedEvent(
      _currentId++,
      event.level,
      TextSpan(children: parser.spans),
      text.toLowerCase(),
    );
  }

  Widget _buildLogBar({required bool dark, required Widget child}) {
    return SizedBox(
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (!dark)
              BoxShadow(
                color: Colors.grey[400] ?? Colors.grey,
                blurRadius: 3,
              ),
          ],
        ),
        child: Material(
          color: dark ? Colors.blueGrey[900] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.darkMode
          ? Theme.of(context).copyWith(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueGrey),
            )
          : Theme.of(context).copyWith(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlueAccent),
            ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLogBar(
                dark: widget.darkMode,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'Log Console',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (widget.showClearButton)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Color.fromARGB(255, 254, 20, 3)),
                        onPressed: () {
                          _renderedBuffer.clear();
                          _LogConsolePage._outputEventBuffer.clear();
                          _refreshFilter();
                          setState(() {});
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.import_export),
                      onPressed: () => widget.onExport?.call(_renderedBuffer.map((e) => e.lowerCaseText).join()),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => mountedSetState(() => _logFontSize++),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => mountedSetState(() => _logFontSize--),
                    ),
                    if (widget.showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: widget.darkMode ? Colors.black : Colors.grey[150],
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      // width: 1600, // TODO <<<
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: _filteredBuffer.length,
                        itemBuilder: (context, index) {
                          var logEntry = _filteredBuffer[index];
                          return Text.rich(
                            logEntry.span,
                            key: Key(logEntry.id.toString()),
                            style: TextStyle(fontSize: _logFontSize),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              _buildLogBar(
                dark: widget.darkMode,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(fontSize: 20),
                        controller: _filterController,
                        onChanged: (s) => _refreshFilter(),
                        decoration: const InputDecoration(
                          labelText: 'Filter log output',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
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
                      onChanged: (value) {
                        _filterLevel = value ?? Level.info;
                        _refreshFilter();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: _followBottom ? 0 : 1,
          duration: const Duration(milliseconds: 150),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              mini: true,
              clipBehavior: Clip.antiAlias,
              child: Icon(
                Icons.arrow_downward,
                color: widget.darkMode ? Colors.white : Colors.lightBlue[900],
              ),
              onPressed: _scrollToBottom,
            ),
          ),
        ),
      ),
    );
  }
}
