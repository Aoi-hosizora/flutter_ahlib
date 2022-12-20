import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class MultiSelectablePage extends StatefulWidget {
  const MultiSelectablePage({Key? key}) : super(key: key);

  @override
  State<MultiSelectablePage> createState() => _MultiSelectablePageState();
}

class _MultiSelectablePageState extends State<MultiSelectablePage> {
  final _controller = MultiSelectableController<ValueKey<int>>();

  void _showSnackBar(String content) {
    printLog(content);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content), duration: const Duration(seconds: 1)));
  }

  String _itemText(int index) {
    return 'Item ${index + 1}';
  }

  int? _maxCount;
  var _exitWhenNoSelect = true;
  var _useCard = true;
  var _useCheckbox = false;
  var _useFullRipple = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiSelectable Example'),
        leading: !_controller.multiSelecting
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _controller.exitMultiSelectionMode(),
              ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('maxSelectableCount'),
              SizedBox(
                height: kSwitchHeight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: ElevatedButton(
                    child: Text('$_maxCount'),
                    onPressed: () => mountedSetState(() => _maxCount = (_maxCount == null ? 1 : (_maxCount == 1 ? 2 : (_maxCount == 2 ? 4 : (_maxCount == 4 ? 8 : null))))),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('exitWhenNoSelect'),
              Switch(value: _exitWhenNoSelect, onChanged: (b) => mountedSetState(() => _exitWhenNoSelect = b)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('useCard'),
              Switch(value: _useCard, onChanged: (b) => mountedSetState(() => _useCard = b)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('useCheckbox'),
              Switch(value: _useCheckbox, onChanged: (b) => mountedSetState(() => _useCheckbox = b)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('useFullRipple'),
              Switch(value: _useFullRipple, onChanged: (b) => mountedSetState(() => _useFullRipple = b)),
            ],
          ),
          Expanded(
            child: MultiSelectable<ValueKey<int>>(
              controller: _controller,
              stateSetter: () => mountedSetState(() {}),
              exitWhenNoSelect: _exitWhenNoSelect,
              onModeChanged: (multiSelection) => _showSnackBar('multiSelection: $multiSelection'),
              onSelectChanged: (all, selected, unselected) => printLog('#all = ${all.length}, #selected = ${selected.length}, #unselected = ${unselected.length}'),
              maxSelectableCount: _maxCount,
              onReachMaxCount: (item) => _showSnackBar('Reached max count when selecting "Item ${item.value + 1}"!'),
              child: ListView.separated(
                itemCount: 20,
                separatorBuilder: (_, __) => _useCard ? const SizedBox.shrink() : const Divider(height: 0, thickness: 0),
                itemBuilder: (c, i) => !_useCheckbox
                    ? SelectableItem<ValueKey<int>>(
                        key: ValueKey<int>(i),
                        builder: (_, key, tip) => ListTile(
                          title: Text(_itemText(i)),
                          selected: tip.selected,
                          onTap: () => !tip.isNormal ? tip.toToggle?.call() : _showSnackBar('Click ${_itemText(i)}!'),
                          onLongPress: tip.isNormal ? () => _controller.enterMultiSelectionMode(alsoSelect: [key]) : null,
                        ).let(
                          (listTile) => _useCard
                              ? Card(
                                  color: tip.isNormal ? Colors.white : (tip.isSelected ? Colors.yellow : Colors.grey[200]),
                                  child: listTile,
                                )
                              : listTile,
                        ),
                      )
                    : SelectableCheckboxItem<ValueKey<int>>(
                        key: ValueKey<int>(i),
                        useFullRipple: _useFullRipple,
                        checkboxPosition: _useCard ? const PositionArgument.fromLTRB(null, null, 8, 8) : const PositionArgument.fromLTRB(null, 0, 15, 0),
                        fullRipplePosition: _useCard ? const PositionArgument.all(4) : const PositionArgument.fill(),
                        itemBuilder: (_, key, tip) => ListTile(
                          title: Text(_itemText(i)),
                          selected: tip.selected,
                          onTap: () => _showSnackBar('Click ${_itemText(i)}!'),
                          onLongPress: tip.isNormal ? () => _controller.enterMultiSelectionMode(alsoSelect: [key]) : null,
                        ).let(
                          (listTile) => _useCard ? Card(child: listTile) : listTile,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFab(
        show: _controller.multiSelecting,
        fab: FloatingActionButton(
          child: const Icon(Icons.check),
          heroTag: null,
          onPressed: () => showDialog(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Selected items'),
              content: Text((_controller.selectedItems.isEmpty
                  ? '<empty>' //
                  : (_controller.selectedItems.map((el) => el.value).toList()..sort()).map((i) => _itemText(i)).join(', '))),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(c).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
