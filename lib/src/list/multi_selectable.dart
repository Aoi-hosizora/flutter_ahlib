import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/lazy_indexed_stack.dart';

/// A widget which simply enables multi-selection for items, these items can be [SelectableItem],
/// or other customizable [Widget].
///
/// Note that items are distinguished through [Key], and these keys are unnecessary to be unique.
/// Also note that this widget only contains related settings about multi-selection, and have no
/// display influence on [child].
///
/// Example:
/// ```
/// final _controller = MultiSelectableController<ValueKey<int>>();
///
/// // use SelectableItem directly
/// MultiSelectable<ValueKey<int>>(
///   controller: _controller,
///   stateSetter: () => mountedSetState(() {}),
///   exitWhenNoSelect: true,
///   maxCount: 6,
///   child: ListView.builder(
///     itemCount: 20,
///     itemBuilder: (c, i) => SelectableItem<ValueKey<int>>(
///       key: ValueKey<int>(i),
///       builder: (_, key, tip) => Card(
///         color: tip.isNormal ? Colors.white : tip.isSelected ? Colors.yellow : Colors.grey[200],
///         child: ListTile(
///           title: Text('Item ${i + 1}'),
///           selected: tip.selected,
///           onTap: () => !tip.isNormal ? tip.toToggle?.call() : /* ... */,
///           onLongPress: tip.isNormal ? () => _controller.enterMultiSelectionMode(alsoSelect: [key]) : null,
///         ),
///       ),
///     ),
///   ),
/// )
///
/// // use SelectableCheckBoxItem
/// MultiSelectable<ValueKey<int>>(
///   controller: _controller,
///   stateSetter: () => mountedSetState(() {}),
///   exitWhenNoSelect: true,
///   maxCount: 6,
///   child: ListView.builder(
///     itemCount: 20,
///     itemBuilder: (c, i) => SelectableCheckBoxItem<ValueKey<int>>(
///       key: ValueKey<int>(i),
///       useFullRipple: true,
///       builder: (_, key, tip) => Card(
///         child: ListTile(
///           title: Text('Item ${i + 1}'),
///           selected: tip.selected,
///           onTap: () { /* ... */ },
///           onLongPress: tip.isNormal ? () => _controller.enterMultiSelectionMode(alsoSelect: [key]) : null,
///         ),
///       ),
///     ),
///   ),
/// )
/// ```
class MultiSelectable<K extends Key> extends StatefulWidget {
  const MultiSelectable({
    Key? key,
    required this.controller,
    required this.stateSetter,
    required this.child,
    this.exitWhenNoSelect = true,
    this.onModeChanged,
    this.onSelectChanged,
    this.maxSelectableCount,
    this.onReachMaxCount,
  }) : super(key: key);

  /// The controller of this widget, which can be used to control multi-selection.
  final MultiSelectableController<K> controller;

  /// The state setter of parent widget.
  final VoidCallback stateSetter;

  /// The widget below this widget in the tree, typically is a [Scrollable] widget.
  final Widget child;

  /// The flag to exit multi-selection mode when there is no item selected, defaults to true.
  final bool exitWhenNoSelect;

  /// The callback that will be invoked when enter or exit multi-selection mode.
  final void Function(bool newInMultiSelectionMode)? onModeChanged;

  /// The callback that will be invoked when some new items are selected or unselected.
  final void Function(Set<K> allSelectedItems, Iterable<K> selectedItems, Iterable<K> unselectedItems)? onSelectChanged;

  /// The max selectable count for multi-selection, defaults to null, which means no checking.
  final int? maxSelectableCount;

  /// The callback that will be invoked when selection count equals to [maxSelectableCount].
  final void Function(K exceedKey)? onReachMaxCount;

  @override
  State<MultiSelectable<K>> createState() => _MultiSelectableState<K>();

  /// Returns the [MultiSelectable] most closely associated with the given context.
  static MultiSelectable<K>? of<K extends Key>(BuildContext context) {
    var parent = context.findAncestorWidgetOfExactType<MultiSelectable<K>>();
    return parent;
  }
}

class _MultiSelectableState<K extends Key> extends State<MultiSelectable<K>> {
  @override
  void initState() {
    super.initState();
    widget.controller.attach(context); // attach controller with MultiSelectable's context
  }

  @override
  void dispose() {
    widget.controller.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// The controller of [MultiSelectable], which is used to enter/exit multi-selection mode, or
/// select/unselect items manually.
class MultiSelectableController<K extends Key> {
  MultiSelectableController();

  // The element context that contains MultiSelectable widget.
  BuildContext? _context;

  // The MultiSelectable widget from the attached context, returns null if context is invalid.
  MultiSelectable<K>? get _widget {
    if (_context == null || _context!.widget is! MultiSelectable<K>) {
      return null;
    }
    return _context!.widget as MultiSelectable<K>;
  }

  /// Attaches [MultiSelectable]'s [BuildContext] to this controller.
  void attach(BuildContext context) => _context = context;

  /// Detaches [MultiSelectable]'s [BuildContext] from this controller.
  void detach() => _context = null;

  @mustCallSuper
  void dispose() {
    _context = null;
    _multiSelecting = false;
    _selectedItems.clear();
  }

  var _multiSelecting = false;

  /// The flag to describe whether current is in multi-selection mode.
  bool get multiSelecting => _multiSelecting;

  /// Enters multi-selection mode for items and notifies parent widget. This will also mark these
  /// items selected if [alsoSelect] is not null.
  void enterMultiSelectionMode({Iterable<K>? alsoSelect}) {
    if (!_multiSelecting) {
      _multiSelecting = true;
      _widget?.stateSetter.call();
      _widget?.onModeChanged?.call(true);
      if (alsoSelect != null) {
        select(alsoSelect); // also with stateSetter
      }
    }
  }

  /// Exits multi-selection mode for items and notifies parent widget. This will also unselect all
  /// items when [alsoUnselect] is true.
  void exitMultiSelectionMode({bool alsoUnselect = true}) {
    if (_multiSelecting) {
      if (alsoUnselect) {
        unselectAll(); // also with stateSetter
      }
      _multiSelecting = false;
      _widget?.stateSetter.call();
      _widget?.onModeChanged?.call(false);
    }
  }

  final _selectedItems = <K>{};

  /// The selected item keys set. Updating this set manually is not recommend.
  Set<K> get selectedItems => _selectedItems;

  /// Checks whether given item is marked as selected.
  bool isSelected(K item) {
    return _selectedItems.contains(item);
  }

  /// Marks given items as selected, notifies parent widget, and calls [onSelectChanged] if necessary.
  void select(Iterable<K> items) {
    if (items.isNotEmpty) {
      if (_widget?.maxSelectableCount != null && _selectedItems.length >= (_widget?.maxSelectableCount)!) {
        _widget?.onReachMaxCount?.call(items.first);
      } else {
        _selectedItems.addAll(items);
        _widget?.stateSetter.call();
        _widget?.onSelectChanged?.call(_selectedItems, items, []);
      }
    }
  }

  /// Marks given items as unselected, notifies parent widget, and calls [onSelectChanged] if necessary.
  void unselect(Iterable<K> items) {
    if (items.isNotEmpty) {
      _selectedItems.removeAll(items);
      _widget?.stateSetter.call();
      _widget?.onSelectChanged?.call(_selectedItems, [], items);
    }
  }

  /// Marks all items as unselected, notifies parent widget, and calls [onSelectChanged] if necessary.
  void unselectAll() {
    if (_selectedItems.isNotEmpty) {
      var items = _selectedItems.toList();
      _selectedItems.clear();
      _widget?.stateSetter.call();
      _widget?.onSelectChanged?.call(_selectedItems, [], items);
    }
  }
}

/// The helper tip class for [MultiSelectable] and [SelectableItem], which contains some flags and
/// [toToggle] function for selecting and unselecting.
class SelectableItemTip {
  const SelectableItemTip({
    required this.multiSelecting,
    required this.selected,
    this.toToggle,
  });

  /// The flag to describe whether current is in multi-selection mode.
  final bool multiSelecting;

  /// The flag to describe whether current item is selected.
  final bool selected;

  /// The flag to describe whether current is not in multi-selection mode, or said in normal state.
  bool get isNormal => !multiSelecting;

  /// The flag to describe whether current item is selected.
  bool get isSelected => multiSelecting && selected;

  /// The flag to describe whether current item is unselected.
  bool get isUnselected => multiSelecting && !selected;

  /// The function to select item or unselect item when multi-selection mode is enabled.
  final void Function()? toToggle;
}

/// The signature for building a widget with [key] and [SelectableItemTip], used by [SelectableItem].
typedef SelectableItemWidgetBuilder<K extends Key> = Widget Function(BuildContext context, K key, SelectableItemTip tip);

/// A widget which contains logics for toggling selecting, typically is used under [MultiSelectable].
///
/// See [MultiSelectable] for example.
class SelectableItem<K extends Key> extends StatelessWidget {
  const SelectableItem({
    required K key,
    required this.builder,
  })  : _key = key,
        super(key: key);

  final K _key;

  /// The key used to distinguish items, which is inherited from [Key] and must not be null.
  @override
  K get key => _key;

  /// The widget builder for building current item, given current [key] and [SelectableItemTip].
  final SelectableItemWidgetBuilder<K> builder;

  @override
  Widget build(BuildContext context) {
    var parent = MultiSelectable.of<K>(context); // get multi-selection settings with correct MultiSelectable<K> type
    if (parent == null) {
      throw ArgumentError('SelectableItem must be used under MultiSelectable');
    }

    var controller = parent.controller;
    SelectableItemTip tip;
    if (!controller.multiSelecting) {
      // parent is not found || normal (not in multi-selection mode)
      tip = const SelectableItemTip(
        multiSelecting: false,
        selected: false,
        toToggle: null, // no need to toggle, ignore this field
      );
    } else if (!controller.isSelected(key)) {
      // unselected
      tip = SelectableItemTip(
        multiSelecting: true,
        selected: false,
        toToggle: () {
          controller.select([key]);
        },
      );
    } else {
      // selected
      tip = SelectableItemTip(
        multiSelecting: true,
        selected: true,
        toToggle: () {
          controller.unselect([key]);
          if (parent.exitWhenNoSelect && controller.selectedItems.isEmpty) {
            controller.exitMultiSelectionMode(); // exit if there is no item selected
          }
        },
      );
    }

    return builder(context, key, tip);
  }
}

/// A convenient widget which wraps [SelectableItem] and displays a [Checkbox] for toggling.
///
/// See [MultiSelectable] for example.
class SelectableCheckboxItem<K extends Key> extends StatelessWidget {
  const SelectableCheckboxItem({
    required K key,
    required this.itemBuilder,
    this.switchDuration,
    this.switchCurve,
    this.checkboxPosition = const PositionArgument.fromLTRB(null, null, 8, 8),
    this.checkboxBuilder,
    this.useFullRipple = true,
    this.fullRipplePosition = const PositionArgument.fill(),
    this.fullRippleBuilder,
  })  : _key = key,
        super(key: key);

  final K _key;

  /// The key used to distinguish items, which is inherited from [Key] and must not be null.
  @override
  K get key => _key;

  /// The widget builder for building current item, given current [key] and [SelectableItemTip],
  /// which will be wrapped by [SelectableItem] and [Stack].
  final SelectableItemWidgetBuilder<K> itemBuilder;

  /// The duration for animation when showing or hiding checkbox for multi-selection mode.
  final Duration? switchDuration;

  /// The curve for animation when showing or hiding checkbox for multi-selection mode.
  final Curve? switchCurve;

  /// The [Checkbox] stack position of this widget, defaults to `PositionArgument.fromLTRB(null, null, 8, 8)`.
  final PositionArgument checkboxPosition;

  /// The [Checkbox] widget builder of this widget, defaults to use `MaterialTapTargetSize.shrinkWrap`
  /// and `VisualDensity(horizontal: -4, vertical: -4)`.
  final SelectableItemWidgetBuilder<K>? checkboxBuilder;

  /// The flag to determine whether use the full ripple widget (such as [InkWell] in [Stack])
  /// rather than only using [Checkbox], for toggling, defaults to true.
  final bool useFullRipple;

  /// The full ripple stack position of this widget, defaults to `PositionArgument.fill()`.
  final PositionArgument fullRipplePosition;

  /// The full ripple builder of this widget, defaults to use [Material] with [InkWell] inside.
  final SelectableItemWidgetBuilder<K>? fullRippleBuilder;

  @override
  Widget build(BuildContext context) {
    return SelectableItem<K>(
      key: key,
      builder: (c, k, t) => Stack(
        children: [
          itemBuilder(c, k, t),
          Positioned(
            left: checkboxPosition.left,
            right: checkboxPosition.right,
            top: checkboxPosition.top,
            bottom: checkboxPosition.bottom,
            child: AnimatedSwitcher(
              duration: switchDuration ?? const Duration(milliseconds: 200),
              reverseDuration: switchDuration ?? const Duration(milliseconds: 200),
              switchInCurve: switchCurve ?? Curves.linear,
              switchOutCurve: switchCurve ?? Curves.linear,
              child: t.isNormal
                  ? const SizedBox.shrink()
                  : checkboxBuilder?.call(c, k, t) ??
                      Checkbox(
                        value: t.isSelected,
                        onChanged: (v) => t.toToggle?.call(),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
            ),
          ),
          if (!t.isNormal && useFullRipple)
            Positioned(
              left: fullRipplePosition.left,
              right: fullRipplePosition.right,
              top: fullRipplePosition.top,
              bottom: fullRipplePosition.bottom,
              child: fullRippleBuilder?.call(c, k, t) ??
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => t.toToggle?.call(),
                    ),
                  ),
            ),
        ],
      ),
    );
  }
}
