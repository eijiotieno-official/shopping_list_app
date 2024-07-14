import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/list/services/list_services.dart';

class ListNotifier extends StateNotifier<AsyncValue<List<ShoppingList>>> {
  ListNotifier() : super(const AsyncValue.loading()) {
    loadShoppingLists();
  }

  Future<void> loadShoppingLists() async {
    final list = await ListServices.fetchLists();
    list.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }

  Future<void> addShoppingList(ShoppingList? shoppingList) async {
    if (shoppingList != null) {
      state = AsyncValue.data([...state.value ?? [], shoppingList]);
      final result = await ListServices.addList(shoppingList);
      result.fold(
          (l) => state = AsyncValue.error(l, StackTrace.current), (r) {});
    }
  }

  Future<void> deleteShoppingList(ShoppingList? shoppingList) async {
    if (shoppingList != null) {
      final List<ShoppingList> data = state.value ?? [];
      state =
          AsyncValue.data(data.where((a) => a.id != shoppingList.id).toList());
      final result = await ListServices.deleteList(shoppingList);
      result.fold(
          (l) => state = AsyncValue.error(l, StackTrace.current), (r) {});
    }
  }

  Future<void> updateShoppingList(ShoppingList? shoppingList) async {
    if (shoppingList != null) {
      state = AsyncValue.data(
        [
          for (final a in state.value ?? [])
            if (a.id == shoppingList.id) shoppingList else a,
        ],
      );
      final result = await ListServices.updateList(shoppingList);
      result.fold(
          (l) => state = AsyncValue.error(l, StackTrace.current), (r) {});
    }
  }
}

final shoppingListsProvider =
    StateNotifierProvider<ListNotifier, AsyncValue<List<ShoppingList>>>((ref) {
  return ListNotifier();
});
