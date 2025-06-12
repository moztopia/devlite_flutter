import 'package:flutter/material.dart';

class TopNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final VoidCallback? onLeadingPressed;

  const TopNavigation({
    super.key,
    required this.title,
    required this.height,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: onLeadingPressed != null
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onLeadingPressed,
            )
          : const Center(
              child: Icon(Icons.menu),
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
