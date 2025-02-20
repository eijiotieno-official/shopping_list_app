import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_list_app/list/services/show_create_list_name.dart';
import 'package:shopping_list_app/list/ui/components/lists_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Shopping List"),
        ),
        body: const ListsView(),
        floatingActionButton: FloatingActionButton(
          heroTag: "add",
          onPressed: () {
            showCreateListName(context: context);
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
