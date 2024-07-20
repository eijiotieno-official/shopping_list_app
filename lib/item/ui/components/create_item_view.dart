import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';
import 'package:shopping_list_app/shared/utils/string_utils.dart';

/// Widget for creating or updating a shopping item.
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
    return CreateItemForm(
      shoppingList: shoppingList,
      shoppingItem: shoppingItem,
      onSave: (item) async {
        final items = List<ShoppingItem>.from(shoppingList.items);
        if (shoppingItem == null) {
          items.add(item);
        } else {
          final index = items.indexWhere((i) => i.id == shoppingItem?.id);
          items[index] = item;
        }
        await ref
            .read(shoppingListsProvider.notifier)
            .updateShoppingList(shoppingList.copyWith(items: items))
            .then((_) => Navigator.pop(context));
      },
    );
  }
}

/// Form for creating or updating a shopping item.
class CreateItemForm extends HookWidget {
  final ShoppingList shoppingList;
  final ShoppingItem? shoppingItem;
  final Future<void> Function(ShoppingItem) onSave;

  const CreateItemForm({
    super.key,
    required this.shoppingList,
    this.shoppingItem,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final nameController =
        useTextEditingController(text: shoppingItem?.name ?? "");
    final priceController =
        useTextEditingController(text: shoppingItem?.price.toString() ?? "");
    final countController =
        useTextEditingController(text: shoppingItem?.count.toString() ?? "");
    final imageDataState = useState<List<int>?>(
        shoppingItem?.imageData.isEmpty ?? true
            ? null
            : shoppingItem?.imageData);
    final isFormValid = useState(false);
    final isItemInList = useState(false);

    useEffect(() {
      nameController.addListener(() {
        final matchItem = shoppingList.items.firstWhereOrNull((i) =>
            i.name.toLowerCase().replaceAll(" ", "").trim() ==
            nameController.text.toLowerCase().replaceAll(" ", "").trim());

        bool match = matchItem != null && matchItem.id != shoppingItem?.id;

        isFormValid.value =
            nameController.text.trim().isNotEmpty && match == false;
        isItemInList.value = match;
      });
      return () {
        nameController.removeListener(() {
          isFormValid.value = nameController.text.trim().isNotEmpty;
        });
      };
    }, [nameController]);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            controller: nameController,
            labelText: 'Name',
            keyboardType: TextInputType.text,
            autofocus: true,
          ),
          if (isItemInList.value)
            const Text(
              "Item is already in the list",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          _buildTextField(
            controller: countController,
            labelText: 'Count',
            keyboardType: TextInputType.number,
            autofocus: false,
          ),
          _buildTextField(
            controller: priceController,
            labelText: 'Price',
            keyboardType: TextInputType.number,
            autofocus: false,
            prefixText: '\$ ',
          ),
          _buildImagePicker(context, imageDataState),
          _buildSaveButton(context, isFormValid, imageDataState.value,
              nameController, countController, priceController),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  /// Builds a text field with the given parameters.
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
    required bool autofocus,
    String? prefixText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autofocus: autofocus,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelText: labelText,
          prefixText: prefixText,
        ),
      ),
    );
  }

  /// Builds the image picker widget.
  Widget _buildImagePicker(
      BuildContext context, ValueNotifier<List<int>?> imageDataState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        height: imageDataState.value != null
            ? MediaQuery.of(context).size.width * 0.60
            : MediaQuery.of(context).size.width * 0.20,
        width: double.infinity,
        child: imageDataState.value != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(Uint8List.fromList(imageDataState.value!),
                        fit: BoxFit.cover),
                    Center(
                      child: IconButton(
                        style: ButtonStyle(
                          iconColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black.withOpacity(0.65)),
                        ),
                        onPressed: () => imageDataState.value = null,
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                children: [
                  _buildImagePickerOption(
                    context: context,
                    label: Icons.image_rounded,
                    onTap: () =>
                        _pickImage(ImageSource.gallery, imageDataState),
                  ),
                  _buildImagePickerOption(
                    context: context,
                    label: Icons.camera_alt_rounded,
                    onTap: () => _pickImage(ImageSource.camera, imageDataState),
                  ),
                ],
              ),
      ),
    );
  }

  /// Builds an image picker option (either gallery or camera).
  Widget _buildImagePickerOption({
    required BuildContext context,
    required IconData label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Theme.of(context).hoverColor,
            ),
            child: Center(
              child: Icon(label, size: 30),
            ),
          ),
        ),
      ),
    );
  }

  /// Picks an image from the specified source and updates the image data state.
  Future<void> _pickImage(
      ImageSource source, ValueNotifier<List<int>?> imageDataState) async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: source, imageQuality: 50);
    if (result != null) {
      final file = File(result.path);
      final data = await file.readAsBytes();
      imageDataState.value = data;
    }
  }

  /// Builds the save button.
  Widget _buildSaveButton(
    BuildContext context,
    ValueNotifier<bool> isFormValid,
    List<int>? imageData,
    TextEditingController nameController,
    TextEditingController countController,
    TextEditingController priceController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: isFormValid.value
              ? () async {
                  await _saveItem(
                    context,
                    nameController,
                    countController,
                    priceController,
                    imageData,
                  );
                }
              : null,
          child: Text(shoppingItem == null ? 'Save' : 'Update'),
        ),
      ),
    );
  }

  /// Saves the shopping item and triggers the onSave callback.
  Future<void> _saveItem(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController countController,
    TextEditingController priceController,
    List<int>? imageData,
  ) async {
    final id = shoppingItem?.id ?? StringUtils.generatedID();
    final count = int.tryParse(countController.text.trim()) ?? 0;
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final bought = shoppingItem?.bought ?? false;

    final item = ShoppingItem(
      id: id,
      name: nameController.text.trim(),
      count: count,
      price: price,
      bought: bought,
      imageData: imageData ?? [],
    );

    await onSave(item);
  }
}
