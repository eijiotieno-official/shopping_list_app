import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/item/services/show_create_item.dart';
import 'package:shopping_list_app/item/ui/components/item_view.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';
import 'package:shopping_list_app/list/ui/components/color_name_view.dart';

class ListScreen extends HookConsumerWidget {
  final ShoppingList shoppingList;
  const ListScreen({super.key, required this.shoppingList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(shoppingListsProvider);

    final ShoppingList? currentList =
        listState.value?.firstWhereOrNull((l) => l.id == shoppingList.id);

    final List<ShoppingItem> items = currentList?.items ?? [];
    items.sort((a, b) => a.bought == b.bought ? 0 : (a.bought ? 1 : -1));

    String totalPrice() {
      double total = 0.0;
      for (var element in items) {
        total = total + element.price;
      }

      return total.toString();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Hero(tag: "add", child: Icon(Icons.arrow_back_rounded)),
        ),
        actions: [
          if (currentList != null)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete"),
                      content: Text(
                          "Confirm to delete *(${currentList.name}) shopping list."),
                      actionsPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(shoppingListsProvider.notifier)
                                .deleteShoppingList(shoppingList);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("Confirm"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete_rounded,
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (currentList != null) ColorNameView(currentList),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Items (${items.where((i) => i.bought == true).toList().length}/${items.length})",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color
                                ?.withOpacity(0.5),
                          ),
                        ),
                        if(totalPrice() != 0.0.toString())
                        Text(
                          "\$ ${totalPrice()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (currentList != null)
                    Flexible(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ItemView(
                              shoppingItem: items[index],
                              shoppingList: currentList);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: currentList == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                await showCreateItem(
                  context: context,
                  shoppingList: currentList,
                );
              },
              label: const Text("Add Item"),
              icon: const Icon(Icons.add_rounded),
            ),
    );
  }
}
