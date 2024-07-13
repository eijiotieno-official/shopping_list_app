import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list_app/list/models/shopping_list_model.dart';
import 'package:shopping_list_app/shared/databases/universal_database.dart';

class ListServices {
  static final UniversalDatabase<ShoppingList> _shoppingListDatabase =
      UniversalDatabase<ShoppingList>(
    storageKey: 'shopping_lists',
    fromJson: (json) => ShoppingList.fromJson(json),
    toJson: (item) => item.toJson(),
  );

  static Future<Either<String, List<ShoppingList>>> fetchLists() async {
    try {
      final result = await _shoppingListDatabase.read();
      return Right(result);
    } catch (e) {
      debugPrint("Error : $e");
      return Left(e.toString());
    }
  }

  static Future<Either<String, None>> addList(ShoppingList list) async {
    try {
      await _shoppingListDatabase.create(list);
      return const Right(None());
    } catch (e) {
      debugPrint("Error : $e");
      return Left(e.toString());
    }
  }

  static Future<Either<String, None>> updateList(ShoppingList list) async {
    try {
      await _shoppingListDatabase.update(list);
      return const Right(None());
    } catch (e) {
      debugPrint("Error : $e");
      return Left(e.toString());
    }
  }

  static Future<Either<String, None>> deleteList(ShoppingList list) async {
    try {
      await _shoppingListDatabase.delete(list.id);
      return const Right(None());
    } catch (e) {
      debugPrint("Error : $e");
      return Left(e.toString());
    }
  }
}
