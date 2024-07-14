import 'package:flutter/material.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/ui/components/create_list_name_view.dart';

Future<void> showCreateListName({
  required BuildContext context,
  ShoppingList? list,
}) async =>
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return CreateListNameView(list);
      },
    );
