import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class MultiSelectablePage extends StatefulWidget {
  const MultiSelectablePage({Key? key}) : super(key: key);

  @override
  State<MultiSelectablePage> createState() => _MultiSelectablePageState();
}

class _MultiSelectablePageState extends State<MultiSelectablePage> {
  final _controller = MultiSelectableController();

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
      body: MultiSelectable(
        controller: _controller,
        stateSetter: () => mountedSetState(() {}),
        exitOnNoSelect: true,
        onChanged: (allItems, newItems, removedItems) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('#all = ${allItems.length}, #new = ${newItems.length}, #remove = ${removedItems.length}'), duration: const Duration(seconds: 1)));
        },
        maxCount: 6,
        onReachMaxCount: (item) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reached max count when selecting $item!'), duration: const Duration(seconds: 1)));
        },
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (c, i) => SelectableItem(
            key: ValueKey(i),
            builder: (_, key, tip) => Card(
              child: ListTile(
                leading: tip.isNormal
                    ? null
                    : AbsorbPointer(
                        absorbing: true,
                        child: Checkbox(
                          value: tip.isSelected,
                          onChanged: (v) {},
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                      ),
                title: Text('Item ${i + 1}'),
                onTap: () {
                  if (!tip.isNormal) {
                    tip.toToggle?.call();
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item ${i + 1}'), duration: const Duration(seconds: 1)));
                  }
                },
                onLongPress: tip.isNormal
                    ? () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        _controller.enterMultiSelectionMode(alsoSelect: [key]);
                      }
                    : null,
              ),
            ),
          ),
        ),
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
              content: Text((_controller.selectedItems.map((el) => 'Item ${(el as ValueKey<int>).value + 1}').toList()..sort()).join(', ')),
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
