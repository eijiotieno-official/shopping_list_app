import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';

Future<void> showCreateItem({
  required BuildContext context,
  required ShoppingList? list,
}) async =>
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return CreateItemView(list: list);
      },
    );

class CreateItemView extends HookConsumerWidget {
  final ShoppingList? list;
  const CreateItemView({super.key, this.list});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();

    final imagePathState = useState<String?>(null);

    String? imagePath = imagePathState.value;

    Future<void> pickImage(ImageSource source) async {
      ImagePicker picker = ImagePicker();
      final result = await picker.pickImage(source: source);
      if (result != null) {
        imagePathState.value = result.path;
      }
    }

    final priceController = useTextEditingController();

    final countController = useTextEditingController();

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
      final count = countController.text.trim().isEmpty
          ? null
          : int.parse(countController.text.trim());

      final price = priceController.text.trim().isEmpty
          ? null
          : double.parse(priceController.text.trim());

      ShoppingItem item = ShoppingItem(
        id: UniqueKey().toString(),
        name: nameController.text.trim(),
        count: count,
        price: price,
        imagePath: imagePath,
      );

      final items = list?.items ?? [];

      if (items.isEmpty) {
        await ref
            .read(shoppingListsProvider.notifier)
            .addShoppingList(list?.copyWith(items: [item]));
      } else {
        items.add(item);
        await ref
            .read(shoppingListsProvider.notifier)
            .updateShoppingList(list?.copyWith(items: items));
      }
    }

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelText: "Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: TextField(
              controller: countController,
              autofocus: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelText: "Count",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: TextField(
              controller: priceController,
              autofocus: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelText: "Price",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: SizedBox(
              height: keyboardHeight == 0.0 && imagePath != null
                  ? MediaQuery.of(context).size.width * 0.60
                  : MediaQuery.of(context).size.width * 0.20,
              width: double.infinity,
              child: imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                          Center(
                            child: IconButton.filledTonal(
                              style: ButtonStyle(
                                iconColor: WidgetStateProperty.all<Color>(
                                    Colors.white),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.black.withOpacity(0.65)),
                              ),
                              onPressed: () {
                                imagePathState.value = null;
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                await pickImage(ImageSource.gallery);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Theme.of(context).hoverColor,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_rounded,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                await pickImage(ImageSource.camera);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Theme.of(context).hoverColor,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isFormValid.value
                    ? () async {
                        await save().then((_) => Navigator.pop(context));
                      }
                    : null,
                child: const Text("Save"),
              ),
            ),
          ),
          SizedBox(height: keyboardHeight),
        ],
      ),
    );
  }
}
