import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';
import 'package:shopping_list_app/list/ui/screens/list_screen.dart';

class ListsView extends HookConsumerWidget {
  const ListsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingListsState = ref.watch(shoppingListsProvider);

    return shoppingListsState.when(
      data: (data) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final color = data[index].color;

            final title = data[index].title;

            final items = data[index].items;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ListScreen(shoppingList: data[index]);
                    },
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: color?.withOpacity(0.50),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.fontSize,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Text(
                                  "${items[index].count} ${items[index].name}");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      error: (error, stackTrace) =>
          const Center(child: Text("Error fetching shopping lists")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
