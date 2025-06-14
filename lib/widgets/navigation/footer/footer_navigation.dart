import 'package:flutter/material.dart';

class FooterNavigation extends StatefulWidget {
  final List<Widget> screens;
  final int initialIndex;
  final ValueChanged<int> onPageChanged;

  const FooterNavigation({
    super.key,
    required this.screens,
    required this.initialIndex,
    required this.onPageChanged,
  });

  @override
  State<FooterNavigation> createState() => _FooterNavigationState();
}

class _FooterNavigationState extends State<FooterNavigation> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant FooterNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != _pageController.page?.round()) {
      _pageController.animateToPage(
        widget.initialIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: widget.onPageChanged,
      children: widget.screens,
    );
  }
}
