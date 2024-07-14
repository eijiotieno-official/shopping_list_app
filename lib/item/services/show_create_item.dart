
import 'package:flutter/material.dart';
import 'package:shopping_list_app/item/ui/components/create_item_view.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';

Future<void> showCreateItem({
  required BuildContext context,
  required ShoppingList shoppingList,
}) async =>
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return CreateItemView(shoppingList: shoppingList);
      },
    );

