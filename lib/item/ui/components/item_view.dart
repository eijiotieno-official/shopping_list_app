import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';

class ItemView extends HookConsumerWidget {
  final ShoppingList? list;
  final ShoppingItem item;
  const ItemView({
    super.key,
    required this.list,
    required this.item,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = list?.items ?? [];

    final count = item.count ?? 0;

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Checkbox(
          value: item.bought,
          onChanged: (value) {
            int index = items.indexWhere((i) => i.id == item.id);
            items[index] =
                item.copyWith(bought: item.bought == true ? false : true);
            ref
                .read(shoppingListsProvider.notifier)
                .updateShoppingList(list?.copyWith(items: items));
          },
        ),
        title: Row(
          children: [
            Expanded(child: Text(item.name)),
            if (count > 0) Text(count.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildIsDone(bool bought, VoidCallback onTap, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).hoverColor,
          ),
        ),
        child: CircleAvatar(
          radius: 15.0,
          child: bought
              ? const Icon(Icons.check_rounded, color: Colors.white)
              : null,
          backgroundColor:
              bought ? null : Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
