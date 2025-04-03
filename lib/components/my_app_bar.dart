import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;


  const MyAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Transparent background
      elevation: 0,
      title: Text(title),
      foregroundColor: Colors.grey,
      actions: actions, // Actions will appear on the right
    );
  }

  @override
  // Define the height of the app bar. 
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}