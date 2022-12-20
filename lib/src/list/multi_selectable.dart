import 'package:flutter/material.dart';

/// A widget which simply enables multi-selection for items, these items can be [SelectableItem],
/// or other customizable [Widget]. Note that this widget only contains related settings about
/// multi-selection, and have no display influence on [child].
///
/// Example:
/// ```
/// final _controller = MultiSelectableController();
///
/// MultiSelectable(
///   controller: _controller,
///   stateSetter: () => mountedSetState(() {}),
///   exitOnNoSelect: true,
///   maxCount: 6,
///   child: ListView.builder(
///     itemCount: 20,
///     itemBuilder: (c, i) => SelectableItem(
///       key: ValueKey(i),
///       builder: (_, key, tip) => Card(
///         color: tip.isNormal ? Colors.white : tip.isSelected ? Colors.yellow : Colors.grey[200],
///         child: ListTile(
///           title: Text('Item ${i + 1}'),
///           onTap: () { if (!tip.isNormal) tip.toToggle?.call(); },
///           onLongPress: () { if (tip.isNormal) _controller.enterMultiSelectionMode(alsoSelect: [key]); },
///         ),
///       ),
///     ),
///   ),
/// ),
/// ```
class MultiSelectable extends StatefulWidget {
  // TODO <K extends Key> ???
  const MultiSelectable({
    Key? key,
    required this.controller,
    required this.stateSetter,
    required this.child,
    this.exitOnNoSelect = true,
    this.onChanged,
    this.maxCount,
    this.onReachMaxCount,
  }) : super(key: key);

  /// The controller of this widget, which can be used to control multi-selection.
  final MultiSelectableController controller;

  /// The state setter of parent widget.
  final VoidCallback stateSetter;

  /// The widget below this widget in the tree, typically is a [Scrollable] widget.
  final Widget child;

  /// The flag to exit multi-selection mode when there is no item selected, defaults to true.
  final bool exitOnNoSelect;

  /// The callback that will be invoked when multi-selection state changed.
  final void Function(Set<Key> allSelectedItems, Iterable<Key> newItems, Iterable<Key> removedItems)? onChanged;

  /// The max selection count for multi-selection, defaults to null, which means no checking.
  final int? maxCount;

  /// The callback that will be invoked when selection count equals to [maxCount].
  final void Function(Key exceedKey)? onReachMaxCount;

  @override
  State<MultiSelectable> createState() => _MultiSelectableState();

  /// Returns the [MultiSelectable] most closely associated with the given context.
  static MultiSelectable? of(BuildContext context) {
    var parent = context.findAncestorWidgetOfExactType<MultiSelectable>();
    return parent;
  }
}

class _MultiSelectableState extends State<MultiSelectable> {
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
/// select/unselect items manually. Note that items are distinguished through [Key], and these
/// are unnecessary to be unique.
class MultiSelectableController {
  MultiSelectableController();

  // The element context that contains MultiSelectable widget.
  BuildContext? _context;

  // The MultiSelectable widget from the attached context, returns null if context is invalid.
  MultiSelectable? get _widget {
    if (_context == null || _context!.widget is! MultiSelectable) {
      return null;
    }
    return _context!.widget as MultiSelectable;
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
  void enterMultiSelectionMode({List<Key>? alsoSelect}) {
    if (!_multiSelecting) {
      _multiSelecting = true;
      if (alsoSelect == null) {
        _widget?.stateSetter.call();
      } else {
        select(alsoSelect); // with stateSetter
      }
    }
  }

  /// Exits multi-selection mode for items and notifies parent widget. This will also unselect all
  /// items when [alsoUnselect] is true.
  void exitMultiSelectionMode({bool alsoUnselect = true}) {
    if (_multiSelecting) {
      _multiSelecting = false;
      if (!alsoUnselect) {
        _widget?.stateSetter.call();
      } else {
        unselectAll(); // with stateSetter
      }
    }
  }

  final _selectedItems = <Key>{};

  /// The selected items set.
  Set<Key> get selectedItems => _selectedItems;

  /// Checks whether given item is marked as selected.
  bool isSelected(Key item) {
    return _selectedItems.contains(item);
  }

  /// Marks given items as selected, notifies parent widget, and calls [onChanged] if necessary.
  void select(Iterable<Key> items) {
    if (items.isNotEmpty) {
      if (_widget?.maxCount != null && _selectedItems.length >= (_widget?.maxCount)!) {
        _widget?.onReachMaxCount?.call(items.first);
        return;
      }
      _selectedItems.addAll(items);
      _widget?.onChanged?.call(_selectedItems, items, []);
      _widget?.stateSetter.call();
    }
  }

  /// Marks given items as unselected, notifies parent widget, and calls [onChanged] if necessary.
  void unselect(Iterable<Key> items) {
    if (items.isNotEmpty) {
      _selectedItems.removeAll(items);
      _widget?.onChanged?.call(_selectedItems, [], items);
      _widget?.stateSetter.call();
    }
  }

  /// Marks all items as unselected, notifies parent widget, and calls [onChanged] if necessary.
  void unselectAll() {
    if (_selectedItems.isNotEmpty) {
      var items = _selectedItems.toList();
      _selectedItems.clear();
      _widget?.onChanged?.call(_selectedItems, [], items);
      _widget?.stateSetter.call();
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

/// A widget which contains logics for toggling selecting, typically is used under [MultiSelectable].
class SelectableItem extends StatelessWidget {
  const SelectableItem({
    required Key key,
    required this.builder,
  })  : _key = key,
        super(key: key);

  final Key _key;

  /// The key used to distinguish items which must not be null.
  @override
  Key get key => _key;

  /// The widget builder for building current item, given current key and [SelectableItemTip].
  final Widget Function(BuildContext context, Key key, SelectableItemTip tip) builder;

  @override
  Widget build(BuildContext context) {
    var parent = MultiSelectable.of(context); // get multi-selection settings
    if (parent == null) {
      var tip = const SelectableItemTip(multiSelecting: false, selected: false);
      return builder(context, key, tip);
    }

    var controller = parent.controller;
    SelectableItemTip tip;
    if (!controller.multiSelecting) {
      // normal
      tip = const SelectableItemTip(multiSelecting: false, selected: false);
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
          if (parent.exitOnNoSelect && controller.selectedItems.isEmpty) {
            controller.exitMultiSelectionMode();
          }
        },
      );
    }

    return builder(context, key, tip);
  }
}
