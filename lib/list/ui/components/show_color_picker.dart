import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/color_notifier.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';

Future<void> showColorPicker({
  required BuildContext context,
  required ShoppingList list,
  required List<Color> colors,
}) async {
  await showModalBottomSheet(
    backgroundColor: Theme.of(context).colorScheme.surface,
    isDismissible: false,
    context: context,
    showDragHandle: true,
    builder: (context) {
      return HookConsumer(
        builder: (context, ref, child) {
          final color = ref.watch(colorProvider);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: colors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    ref.read(colorProvider.notifier).update(colors[index]);
                    ref.read(shoppingListsProvider.notifier).updateShoppingList(
                        list.copyWith(color: colors[index]));
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: color == colors[index]
                          ? Border.all(
                              color: Colors.white.withOpacity(0.75),
                              width: 5,
                            )
                          : null,
                      color: colors[index],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}
