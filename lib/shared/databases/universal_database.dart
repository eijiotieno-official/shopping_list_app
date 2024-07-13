import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// A generic class to handle CRUD operations for items of T using SharedPreferences
class UniversalDatabase<T> {
  final String
      storageKey; // Key used to store and retrieve data from SharedPreferences
  final T Function(String source)
      fromJson; // Function to convert a JSON map to an object of T
  final String Function(T)
      toJson; // Function to convert an object of T to a JSON map

  // Constructor to initialize the storageKey, fromJson, and toJson functions
  UniversalDatabase({
    required this.storageKey,
    required this.fromJson,
    required this.toJson,
  });

  // Method to read and return a list of items of T from SharedPreferences
  Future<List<T>> read() async {
    try {
      // Get the instance of SharedPreferences
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      // Retrieve the list of JSON strings from SharedPreferences using the storageKey, or an empty list if not found
      final itemsStringList = sharedPreferences.getStringList(storageKey) ?? [];

      // Convert each JSON string to an object of T and return the list
      return itemsStringList.map((e) => fromJson(jsonDecode(e))).toList();
    } catch (e) {
      // Throw an exception if an error occurs
      throw Exception('Error reading data: $e');
    }
  }

  // Method to add a new item of T to SharedPreferences
  Future<void> create(T item) async {
    try {
      // Get the instance of SharedPreferences
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      // Retrieve the list of JSON strings from SharedPreferences using the storageKey, or an empty list if not found
      List<String> itemsStringList =
          sharedPreferences.getStringList(storageKey) ?? [];

      // Convert the item to a JSON string and add it to the list
      itemsStringList.add(jsonEncode(toJson(item)));

      // Save the updated list back to SharedPreferences
      await sharedPreferences.setStringList(storageKey, itemsStringList);
    } catch (e) {
      // Throw an exception if an error occurs
      throw Exception('Error creating item: $e');
    }
  }

  // Method to delete an item of T from SharedPreferences based on a specified id
  Future<void> delete(String id) async {
    try {
      // Get the instance of SharedPreferences
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      // Retrieve the list of JSON strings from SharedPreferences using the storageKey, or an empty list if not found
      List<String> itemsStringList =
          sharedPreferences.getStringList(storageKey) ?? [];

      // Remove the item from the list where the id matches the specified id
      itemsStringList.removeWhere((e) {
        final itemMap = fromJson(jsonDecode(e));
        return (itemMap as dynamic).id == id; // Null check added here
      });

      // Save the updated list back to SharedPreferences
      await sharedPreferences.setStringList(storageKey, itemsStringList);
    } catch (e) {
      // Throw an exception if an error occurs
      throw Exception('Error deleting item: $e');
    }
  }

  // Method to update an existing item of T in SharedPreferences
  Future<void> update(T item) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      List<String> itemsStringList =
          sharedPreferences.getStringList(storageKey) ?? [];

      final model = (item as dynamic);

      for (int i = 0; i < itemsStringList.length; i++) {
        final currentItem = fromJson(jsonDecode(itemsStringList[i])) as dynamic;
        if (currentItem.id == model.id) {
          itemsStringList[i] = jsonEncode(toJson(item));
          break; // Exit loop once updated
        }
      }

      // Save the updated list back to SharedPreferences
      await sharedPreferences.setStringList(storageKey, itemsStringList);
    } catch (e) {
      throw Exception('Error updating item: $e');
    }
  }
}
