import 'package:flutter/material.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/ui/components/pick_color_view.dart';

Future<void> showPickColor({
  required BuildContext context,
  required ShoppingList shoppingList,
  required List<Color> colors,
}) async =>
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return PickColorView(shoppingList: shoppingList, colors: colors);
      },
    );
