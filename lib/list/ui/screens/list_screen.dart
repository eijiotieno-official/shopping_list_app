import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';

class ListScreen extends HookConsumerWidget {
  final ShoppingList? list;
  const ListScreen({super.key, this.list});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(),
    );
  }
}
