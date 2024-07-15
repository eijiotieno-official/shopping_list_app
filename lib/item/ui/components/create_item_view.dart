import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';

class CreateItemView extends HookConsumerWidget {
  final ShoppingList shoppingList;
  final ShoppingItem? shoppingItem;
  const CreateItemView({
    super.key,
    required this.shoppingList,
    this.shoppingItem,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController =
        useTextEditingController(text: shoppingItem?.name ?? "");

    final imageDataState = useState<List<int>?>(shoppingItem == null
        ? null
        : shoppingItem!.imageData.isEmpty
            ? null
            : shoppingItem?.imageData);

    List<int>? imageData = imageDataState.value;

    Future<void> pickImage(ImageSource source) async {
      ImagePicker picker = ImagePicker();
      final result = await picker.pickImage(source: source, imageQuality: 50);
      if (result != null) {
        final file = File(result.path);
        final data = await file.readAsBytes();
        imageDataState.value = data;
      }
    }

    final priceController =
        useTextEditingController(text: shoppingItem?.price.toString() ?? "");

    final countController =
        useTextEditingController(text: shoppingItem?.count.toString() ?? "");

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
          ? 0
          : int.parse(countController.text.trim());

      final price = priceController.text.trim().isEmpty
          ? 0.0
          : double.parse(priceController.text.trim());

      ShoppingItem item = ShoppingItem(
        id: UniqueKey().toString(),
        name: nameController.text.trim(),
        count: count,
        price: price,
        bought: false,
        imageData: imageData ?? [],
      );

      final items = shoppingList.items;

      if (shoppingItem == null) {
        items.add(item);
      } else {
        int index = items.indexWhere((i) => i.id == shoppingItem?.id);
        items[index] = item.copyWith(id: shoppingItem?.id);
      }
      await ref
          .read(shoppingListsProvider.notifier)
          .updateShoppingList(shoppingList.copyWith(items: items));
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
              height: keyboardHeight == 0.0 && imageData != null
                  ? MediaQuery.of(context).size.width * 0.60
                  : MediaQuery.of(context).size.width * 0.20,
              width: double.infinity,
              child: imageData != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Image.memory(Uint8List.fromList(imageData),
                              fit: BoxFit.cover),
                          Center(
                            child: IconButton.filledTonal(
                              style: ButtonStyle(
                                iconColor: WidgetStateProperty.all<Color>(
                                    Colors.white),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.black.withOpacity(0.65)),
                              ),
                              onPressed: () {
                                imageDataState.value = null;
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
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isFormValid.value
                          ? () async {
                              await save().then((_) => Navigator.pop(context));
                            }
                          : null,
                      child: Text(shoppingItem == null ? "Save" : "Update"),
                    ),
                  ),
                ),
                if (shoppingItem != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton.filledTonal(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete"),
                              content: Text(
                                  "Confirm to delete *(${shoppingItem?.name}) item."),
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
                                    final updatedList = shoppingList;
                                    updatedList.items.removeWhere(
                                        (i) => i.id == shoppingItem?.id);
                                    ref
                                        .read(shoppingListsProvider.notifier)
                                        .updateShoppingList(updatedList);
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
                  ),
              ],
            ),
          ),
          SizedBox(height: keyboardHeight),
        ],
      ),
    );
  }
}
