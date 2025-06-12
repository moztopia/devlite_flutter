import 'package:flutter/material.dart';

class TopNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  const TopNavigation({super.key, required this.title, required this.height});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: const Center(
        child: Icon(Icons.menu),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
