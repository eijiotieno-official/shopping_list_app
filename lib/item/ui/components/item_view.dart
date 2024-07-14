import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/item/ui/components/full_image_view.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';

class ItemView extends HookConsumerWidget {
  final ShoppingList? shoppingList;
  final ShoppingItem item;
  const ItemView({
    super.key,
    required this.shoppingList,
    required this.item,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = shoppingList?.items ?? [];

    final count = item.count ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          right: 16.0,
        ),
        horizontalTitleGap: 0.0,
        leading: Checkbox(
          value: item.bought,
          onChanged: (value) {
            int index = items.indexWhere((i) => i.id == item.id);
            items[index] =
                item.copyWith(bought: item.bought == true ? false : true);
            ref
                .read(shoppingListsProvider.notifier)
                .updateShoppingList(shoppingList?.copyWith(items: items));
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  decoration: item.bought ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (count > 0) Text(count.toString()),
          ],
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.imagePath != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FullImageView(imagePath: item.imagePath!);
                            },
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(item.imagePath!),
                              fit: BoxFit.cover,
                            ),
                            if (item.bought)
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
            if (item.price != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "\$ ${item.price.toString()}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
