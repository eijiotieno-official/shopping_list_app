import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/color_notifier.dart';
import 'package:shopping_list_app/list/services/show_create_list_name.dart';
import 'package:shopping_list_app/list/services/show_pick_color.dart';

class ColorNameView extends HookConsumerWidget {
  final ShoppingList shoppingList;
  const ColorNameView(this.shoppingList, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorNotifier = ref.read(colorProvider.notifier);
    final colors = colorNotifier.colors;

    return ListTile(
      contentPadding: const EdgeInsets.only(right: 16.0),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: GestureDetector(
          onTap: () => showPickColor(
            context: context,
            colors: colors,
            shoppingList: shoppingList.copyWith(color: shoppingList.color ?? colors.first),
          ),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: shoppingList.color ?? colors.first,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          showCreateListName(context: context, shoppingList: shoppingList);
        },
        child: Text(
          shoppingList.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        ),
      ),
    );
  }
}
