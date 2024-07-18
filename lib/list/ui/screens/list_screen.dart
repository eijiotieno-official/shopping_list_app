import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/item/services/show_create_item.dart';
import 'package:shopping_list_app/item/ui/components/item_view.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';
import 'package:shopping_list_app/list/services/show_create_list_name.dart';
import 'package:shopping_list_app/list/ui/components/color_name_view.dart';
import 'package:share_plus/share_plus.dart';

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

    String remainingTotalPrice() {
      double total = 0.0;

      double boughtTotal = 0.0;

      final bought = items.where((i) => i.bought).toList();
      for (var element in bought) {
        boughtTotal = boughtTotal + element.price;
      }

      for (var element in items) {
        total = total + element.price;
      }

      return (total - boughtTotal).toString();
    }

    Future<void> share() async {
      double total = 0.0;

      for (var element in items) {
        total = total + element.price;
      }

      if (currentList != null) {
        String listString = "${currentList.name}\n";

        String itemsString = "".trim();

        for (var i = 0; i < currentList.items.length; i++) {
          final item = currentList.items[i];

          String count = item.count == 0 ? "" : "x ${item.count.toString()}";

          String price = item.price == 0 ? "" : "-  \$${item.price.toString()}";

          itemsString = "$itemsString${i + 1}. ${item.name} $count  $price\n";
        }

        await Share.share(
            "$listString\n$itemsString\nTotal Price  =  \$$total\n");
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Hero(tag: "add", child: Icon(Icons.arrow_back_rounded)),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showCreateListName(
                  context: context, shoppingList: currentList);
            },
            icon: const Icon(
              Icons.create_rounded,
            ),
          ),
          IconButton(
            onPressed: () async {
              await share();
            },
            icon: const Icon(
              Icons.reply_rounded,
            ),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            if (currentList != null) ColorNameView(currentList),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentList != null)
                    Flexible(
                      child: items.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                    "It's seems there are no items in this shopping list."),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: items[index].bought == true
                                        ? null
                                        : Border(
                                            bottom: BorderSide(
                                              color:
                                                  Theme.of(context).hoverColor,
                                            ),
                                          ),
                                  ),
                                  child: ItemView(
                                      shoppingItem: items[index],
                                      shoppingList: currentList),
                                );
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
