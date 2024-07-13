import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/item/models/shopping_item_model.dart';

class ItemView extends HookConsumerWidget {
  final ShoppingItem item;
  const ItemView(this.item, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
