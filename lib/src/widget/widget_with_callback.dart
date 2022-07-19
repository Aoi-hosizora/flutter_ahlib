import 'package:flutter/material.dart';

/// A [StatelessWidget] with some callbacks.
class StatelessWidgetWithCallback extends StatelessWidget {
  /// Creates [StatelessWidgetWithCallback] with non-null [child].
  const StatelessWidgetWithCallback({
    Key? key,
    required this.child,
    this.buildCallback,
    this.postFrameCallback,
  })  : builder = null,
        assert(child != null),
        super(key: key);

  /// Creates [StatelessWidgetWithCallback] with non-null [builder].
  const StatelessWidgetWithCallback.builder({
    Key? key,
    required this.builder,
    this.buildCallback,
    this.postFrameCallback,
  })  : child = null,
        assert(builder != null),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The function which is used to obtain the stateful child widget.
  final WidgetBuilder? builder;

  /// The callback that will be invoked when [State.build] is called.
  final void Function()? buildCallback;

  /// The callback that will be scheduled for the end of this frame.
  final void Function()? postFrameCallback;

  @override
  Widget build(BuildContext context) {
    assert(child != null || builder != null);

    buildCallback?.call();
    if (postFrameCallback != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => postFrameCallback?.call());
    }

    if (child != null) {
      return child!;
    }
    return builder!(context);
  }
}

/// A [StatefulWidget] with some callbacks.
class StatefulWidgetWithCallback extends StatefulWidget {
  /// Creates [StatefulWidgetWithCallback] with non-null [child].
  const StatefulWidgetWithCallback({
    Key? key,
    required this.child,
    this.initStateCallback,
    this.didChangeDependenciesCallback,
    this.didUpdateWidgetCallback,
    this.reassembleCallback,
    this.buildCallback,
    this.activateCallback,
    this.deactivateCallback,
    this.disposeCallback,
    this.permanentFrameCallback,
    this.postFrameCallbackForInitState,
    this.postFrameCallbackForDidChangeDependencies,
    this.postFrameCallbackForDidUpdateWidget,
    this.postFrameCallbackForBuild,
  })  : builder = null,
        assert(child != null),
        super(key: key);

  /// Creates [StatefulWidgetWithCallback] with non-null [builder].
  const StatefulWidgetWithCallback.builder({
    Key? key,
    required this.builder,
    this.initStateCallback,
    this.didChangeDependenciesCallback,
    this.didUpdateWidgetCallback,
    this.reassembleCallback,
    this.buildCallback,
    this.activateCallback,
    this.deactivateCallback,
    this.disposeCallback,
    this.permanentFrameCallback,
    this.postFrameCallbackForInitState,
    this.postFrameCallbackForDidChangeDependencies,
    this.postFrameCallbackForDidUpdateWidget,
    this.postFrameCallbackForBuild,
  })  : child = null,
        assert(builder != null),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The function which is used to obtain the stateful child widget.
  final StatefulWidgetBuilder? builder;

  /// The callback that will be invoked when [State.initState] is called.
  final void Function()? initStateCallback;

  /// The callback that will be invoked when [State.didChangeDependencies] is called.
  final void Function()? didChangeDependenciesCallback;

  /// The callback that will be invoked when [State.didUpdateWidget] is called.
  final void Function()? didUpdateWidgetCallback;

  /// The callback that will be invoked when [State.reassemble] is called.
  final void Function()? reassembleCallback;

  /// The callback that will be invoked when [State.build] is called.
  final void Function()? buildCallback;

  /// The callback that will be invoked when [State.activate] is called.
  final void Function()? activateCallback;

  /// The callback that will be invoked when [State.deactivate] is called.
  final void Function()? deactivateCallback;

  /// The callback that will be invoked when [State.dispose] is called.
  final void Function()? disposeCallback;

  /// The callback that will be scheduled for the end of each frame, which will be
  /// called after postFrameCallback.
  final void Function()? permanentFrameCallback;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.initState].
  final void Function()? postFrameCallbackForInitState;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.didChangeDependencies].
  final void Function()? postFrameCallbackForDidChangeDependencies;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.didUpdateWidget].
  final void Function()? postFrameCallbackForDidUpdateWidget;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.build].
  final void Function()? postFrameCallbackForBuild;

  @override
  State<StatefulWidgetWithCallback> createState() => _StatefulWidgetWithCallbackState();
}

class _StatefulWidgetWithCallbackState extends State<StatefulWidgetWithCallback> {
  @override
  void initState() {
    super.initState();
    widget.initStateCallback?.call();
    if (widget.permanentFrameCallback != null) {
      // Note: Persistent frame callbacks cannot be unregistered.
      // Once registered, they are called for every frame for the
      // lifetime of the application.
      WidgetsBinding.instance?.addPersistentFrameCallback((_) => widget.permanentFrameCallback?.call());
    }
    if (widget.postFrameCallbackForInitState != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForInitState?.call());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependenciesCallback?.call();
    if (widget.postFrameCallbackForDidChangeDependencies != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForDidChangeDependencies?.call());
    }
  }

  @override
  void didUpdateWidget(covariant StatefulWidgetWithCallback oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidgetCallback?.call();
    if (widget.postFrameCallbackForDidUpdateWidget != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForDidUpdateWidget?.call());
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.reassembleCallback?.call();
  }

  @override
  void activate() {
    super.activate();
    widget.activateCallback?.call();
  }

  @override
  void deactivate() {
    widget.deactivateCallback?.call();
    super.deactivate();
  }

  @override
  void dispose() {
    widget.disposeCallback?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.child, builder = widget.builder;
    assert(child != null || builder != null);

    widget.buildCallback?.call();
    if (widget.postFrameCallbackForBuild != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForBuild?.call());
    }

    if (child != null) {
      return child;
    }
    return builder!(context, setState);
  }
}

/// A helper class for [TableCell], and is used to decide which [TableCell] to fill
/// the whole [TableRow] in vertical direction, which is not implemented by flutter.
///
/// Example:
/// ```
/// // in State class
/// final _helper = TableCellHelper(9, 2); // 9x2
///
/// // 1. in initState and didUpdateWidget method
/// // 2. or in build method
/// // 3. or use StatefulWidgetWithCallback with postFrameCallbackForXXX
/// WidgetsBinding.instance!.addPostFrameCallback((_) {
///   if (_helper.searchForHighestCells()) {
///     if (mounted) setState(() {});
///   }
/// });
///
/// // Table constructor in build method
/// Table(
///   children: [
///     for (int i = 0; i &lt; 9; i++)
///       TableRow(
///         children: [
///           for (int j = 0; j &lt; 2; j++)
///             TableCell(
///               key: _helper.getCellKey(i, j)
///               verticalAlignment: _helper.determineCellAlignment(i, j, TableCellVerticalAlignment.top),
///               child: Text('item ($i, $j)'),
///             ),
///         ],
///       ),
///   ],
/// )
///
/// // for update Table content
/// _helper.reset(newRow, newHeight);
/// if (mounted) setState(() {});
/// ```
class TableCellHelper {
  TableCellHelper(this._rows, this._columns)
      : assert(_rows >= 0 && _columns >= 0),
        _keys = List.generate(_rows, (_) => List.generate(_columns, (_) => GlobalKey())),
        _highests = <int>[];

  int _rows;
  int _columns;
  List<List<GlobalKey>> _keys;
  List<int> _highests;

  /// Resets the [TableCellHelper] with new rows and columns, which should be used
  /// when [TableRow] count or [TableCell] content was changed, following [setState].
  void reset(int rows, int columns) {
    assert(_rows >= 0 && _columns >= 0);
    _rows = rows;
    _columns = columns;
    _keys = List.generate(_rows, (_) => List.generate(_columns, (_) => GlobalKey()));
    _highests = <int>[];
  }

  /// Returns the [TableCell]'s [GlobalKey] for given index.
  GlobalKey getCellKey(int i, int j) {
    assert(_rows > 0 && _columns > 0);
    assert(i < _rows && j < _columns);
    return _keys[i][j];
  }

  /// Determines the [TableCell]'s [TableCellVerticalAlignment] with given index.
  TableCellVerticalAlignment? determineCellAlignment(int i, int j, [TableCellVerticalAlignment? initialValue]) {
    assert(_rows > 0 && _columns > 0);
    assert(i < _rows && j < _columns);
    if (_highests.isEmpty) {
      return initialValue;
    }
    if (_highests[i] == j) {
      return TableCellVerticalAlignment.top; // highest -> top
    }
    return TableCellVerticalAlignment.fill; // others -> fill
  }

  /// Searches the highest [TableCell] in multiple [TableRow] and this function
  /// returns true if the highests list is regenerated.
  bool searchForHighestCells() {
    if (_rows == 0 || _columns == 0) {
      return false; // there is no cell
    }
    if (_highests.isNotEmpty) {
      return false; // search has been already done
    }

    var newHighests = <int>[];
    for (int i = 0; i < _rows; i++) {
      var max = 0, maxHeight = -1.0;
      for (int j = 0; j < _columns; j++) {
        var curHeight = _keys[i][j].currentContext?.size?.height;
        if (curHeight == null) {
          return false; // there are some rendered cells
        }
        if (curHeight > maxHeight) {
          max = j;
          maxHeight = curHeight;
        }
      }
      newHighests.add(max);
    }

    _highests = newHighests;
    return true; // highests list is regenerated
  }
}
