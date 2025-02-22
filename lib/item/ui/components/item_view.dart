import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/item/services/show_create_item.dart';
import 'package:shopping_list_app/item/ui/components/full_image_view.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';

class ItemView extends HookConsumerWidget {
  final ShoppingList shoppingList;
  final ShoppingItem shoppingItem;
  const ItemView({
    super.key,
    required this.shoppingList,
    required this.shoppingItem,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = shoppingItem.count;

    return GestureDetector(
      onTap: () {
        showCreateItem(
            context: context,
            shoppingList: shoppingList,
            shoppingItem: shoppingItem);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          right: 8.0,
        ),
        child: Row(
          children: [
            Checkbox(
              value: shoppingItem.bought,
              onChanged: (value) {
                List<ShoppingItem> items = shoppingList.items;

                int index = items.indexWhere((i) => i.id == shoppingItem.id);

                items[index] = shoppingItem.copyWith(
                    bought: shoppingItem.bought == true ? false : true);

                debugPrint(index.toString());

                ref
                    .read(shoppingListsProvider.notifier)
                    .updateShoppingList(shoppingList.copyWith(items: items));
              },
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      count > 0
                          ? "${shoppingItem.name} x ${count.toString()}"
                          : shoppingItem.name,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize,
                        fontWeight: FontWeight.w500,
                        decoration: shoppingItem.bought
                            ? TextDecoration.lineThrough
                            : null,
                        color: shoppingItem.bought
                            ? Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color
                                ?.withOpacity(0.4)
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  if (shoppingItem.imageData.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FullImageView(
                                        imageData: Uint8List.fromList(
                                            shoppingItem.imageData));
                                  },
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.memory(
                                    Uint8List.fromList(shoppingItem.imageData),
                                    fit: BoxFit.cover,
                                  ),
                                  if (shoppingItem.bought)
                                    Container(
                                      color: Colors.black.withOpacity(0.75),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (shoppingItem.price > 0 && shoppingItem.bought == false)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "\$ ${shoppingItem.price.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge?.fontSize,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Item"),
                      content: Text(
                          "Confirm to delete *(${shoppingItem.name}) item."),
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
                            final updatedList = shoppingList;
                            updatedList.items
                                .removeWhere((i) => i.id == shoppingItem.id);
                            ref
                                .read(shoppingListsProvider.notifier)
                                .updateShoppingList(updatedList);
                            Navigator.pop(context);
                          },
                          child: const Text("Confirm"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.close_rounded,
                color: shoppingItem.bought
                    ? Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.4)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
