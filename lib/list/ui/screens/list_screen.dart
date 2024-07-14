import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/item/services/show_create_item_modal.dart';
import 'package:shopping_list_app/item/ui/components/item_view.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/color_notifier.dart';
import 'package:shopping_list_app/list/notifiers/id_notifier.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';
import 'package:shopping_list_app/list/services/show_create_list_name.dart';
import 'package:shopping_list_app/list/ui/components/show_color_picker.dart';

class ListScreen extends HookConsumerWidget {
  final ShoppingList? shoppingList;
  const ListScreen({super.key, this.shoppingList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(shoppingListsProvider);
    final idNotifier = ref.read(idProvider.notifier);
    final colorNotifier = ref.read(colorProvider.notifier);
    final colors = colorNotifier.colors;
    final color = ref.watch(colorProvider);
    final id = ref.watch(idProvider);

    final TextEditingController titleController =
        useTextEditingController(text: shoppingList?.name ?? "");
    final isFormValid = useState(false);

    void validateForm() {
      final isValid = titleController.text.trim().isNotEmpty;
      isFormValid.value = isValid;
    }

    useEffect(() {
      Future.microtask(() {
        if (shoppingList == null) {
          showCreateListName(context: context);
        }
        final listId = shoppingList?.id ?? UniqueKey().toString();
        idNotifier.update(listId);
        Future.delayed(const Duration(milliseconds: 100), () {
          colorNotifier.update(shoppingList?.color ?? colors.first);
        });
        validateForm();
      });
      return null;
    }, []);

    useEffect(() {
      titleController.addListener(validateForm);
      return () {
        titleController.removeListener(validateForm);
      };
    }, [titleController]);

    final ShoppingList? currentList =
        shoppingList ?? listState.value?.firstWhereOrNull((l) => l.id == id);
    final List<ShoppingItem> items = currentList?.items ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Hero(tag: "add", child: Icon(Icons.arrow_back_rounded)),
        ),
        actions: [
          if (shoppingList != null)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete"),
                      content: Text(
                          "Confirm to delete *(${currentList?.name}) shopping list."),
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
            Card(
              margin: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () => showColorPicker(
                      context: context,
                      colors: colors,
                      list: ShoppingList(
                        id: id.toString(),
                        name: titleController.text.trim(),
                        items: items,
                        color: color,
                      ),
                    ),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                title: TextField(
                  controller: titleController,
                  autofocus: shoppingList == null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "List Name",
                  ),
                  onChanged: (v) {
                    ref
                        .read(shoppingListsProvider.notifier)
                        .updateShoppingList(ShoppingList(
                          id: id.toString(),
                          name: titleController.text.trim(),
                          items: items,
                          color: color,
                        ));
                  },
                ),
              ),
            ),
            if (titleController.text.trim().isNotEmpty)
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        "Items ${items.length}",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color
                              ?.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ItemView(
                              item: items[index], list: currentList);
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: titleController.text.trim().isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                showCreateItem(
                  context: context,
                  list: ShoppingList(
                    id: id.toString(),
                    name: titleController.text.trim(),
                    items: items,
                    color: color,
                  ),
                );
              },
              label: const Text("Add Item"),
              icon: const Icon(Icons.add_rounded),
            ),
    );
  }
}
