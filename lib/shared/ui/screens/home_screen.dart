import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_list_app/list/ui/components/lists_view.dart';
import 'package:shopping_list_app/list/ui/screens/list_screen.dart';

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
        appBar: AppBar(),
        body: const ListsView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return  const ListScreen();
                },
              ),
            );
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
