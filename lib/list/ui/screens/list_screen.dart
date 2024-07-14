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
        useTextEditingController(text: shoppingList?.title ?? "");
    final isFormValid = useState(false);

    void validateForm() {
      final isValid = titleController.text.trim().isNotEmpty;
      isFormValid.value = isValid;
    }

    useEffect(() {
      final listId = shoppingList?.id ?? UniqueKey().toString();
      idNotifier.update(listId);
      Future.delayed(const Duration(milliseconds: 100), () {
        colorNotifier.update(shoppingList?.color ?? colors.first);
      });
      validateForm();
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
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: GestureDetector(
                onTap: () => showColorPicker(
                  context: context,
                  colors: colors,
                  list: ShoppingList(
                    id: id.toString(),
                    title: titleController.text.trim(),
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
              title: TextField(
                controller: titleController,
                autofocus: shoppingList == null,
                decoration: const InputDecoration(
                  labelText: "List name",
                ),
              ),
            ),
            if (titleController.text.trim().isNotEmpty)
              ListTile(
                contentPadding: EdgeInsets.zero,
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
                trailing: FilledButton.tonalIcon(
                  onPressed: () {
                    showCreateItem(
                      context: context,
                      list: ShoppingList(
                        id: id.toString(),
                        title: titleController.text.trim(),
                        items: items,
                        color: color,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add"),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemView(item: items[index], list: currentList);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
