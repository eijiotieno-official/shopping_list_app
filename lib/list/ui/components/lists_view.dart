import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/list/notifiers/list_notifier.dart';
import 'package:shopping_list_app/list/ui/components/list_item.dart';

class ListsView extends HookConsumerWidget {
  const ListsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingListsState = ref.watch(shoppingListsProvider);

    return shoppingListsState.when(
      data: (data) => data.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("It's seems there are no shopping lists"),
              ),
            )
          : Padding(
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
                  return ListItem(list: data[index]);
                },
              ),
            ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Error fetching shopping lists $error"),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
