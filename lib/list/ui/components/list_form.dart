import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';
import 'package:shopping_list_app/item/ui/components/item_view.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';

class ListForm extends HookConsumerWidget {
  final ShoppingList? list;
  const ListForm(this.list, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = useState(list?.color);

    Color color = colorState.value ?? Colors.green;

    final titleController = useTextEditingController(text: list?.title ?? "");

    final itemsState = useState(list?.items ?? []);

    List<ShoppingItem> items = itemsState.value;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: color,
              ),
              title: TextField(
                controller: titleController,
                autofocus: list == null,
                decoration: const InputDecoration(
                  hintText: "List name",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Items ${items.length}",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.5),
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return AlertDialog(
                    //       content: ,
                    //     );
                    //   },
                    // );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    "Add",
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                ),
              ],
            ),
            if (items.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemView(items[index]);
                  },
                ),
              ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
