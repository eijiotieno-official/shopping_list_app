import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';
import 'package:shopping_list_app/list/ui/screens/list_screen.dart';
import 'package:shopping_list_app/shared/utils/string_utils.dart';

class CreateListNameView extends HookConsumerWidget {
  final ShoppingList? shoppingList;

  const CreateListNameView(this.shoppingList, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController =
        useTextEditingController(text: shoppingList?.name ?? "");

    final isFormValid = useState(false);

    void validateForm() {
      final isValid = nameController.text.trim().isNotEmpty;
      isFormValid.value = isValid;
    }

    useEffect(() {
      nameController.addListener(validateForm);
      return () {
        nameController.removeListener(validateForm);
      };
    }, [nameController]);

    Future<void> save() async {
      final id = shoppingList?.id ?? StringUtils.generatedID();

      final items = shoppingList?.items ?? [];

      ShoppingList updatedShoppingList = ShoppingList(
        id: id,
        name: nameController.text.trim(),
        items: items,
        color: shoppingList?.color,
      );

      if (shoppingList == null) {
        await ref
            .read(shoppingListsProvider.notifier)
            .addShoppingList(updatedShoppingList)
            .then(
          (_) async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ListScreen(shoppingList: updatedShoppingList);
                },
              ),
            );
          },
        );
      } else {
        await ref
            .read(shoppingListsProvider.notifier)
            .updateShoppingList(updatedShoppingList)
            .then(
              (_) => Navigator.pop(context),
            );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              labelText: "List Name",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isFormValid.value
                    ? () async {
                        await save();
                      }
                    : null,
                child: const Text("Save"),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
