import 'package:flutter/material.dart';
import 'package:devlite_flutter/widgets/widgets.dart';
import 'package:devlite_flutter/screens/screens.dart';

class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({super.key});

  @override
  State<PrimaryScreen> createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TwoScreen(),
    const ThreeScreen(),
    const FourScreen(),
    const FiveScreen(),
  ];

  final List<String> _appBarTitles = const [
    'Home',
    'Two',
    'Three',
    'Four',
    'Five',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double topNavBarHeight = screenHeight / 14;

    return Scaffold(
      appBar: TopNavigation(
        title: _appBarTitles[_selectedIndex],
        height: topNavBarHeight,
      ),
      body: FooterNavigation(
        screens: _screens,
        initialIndex: _selectedIndex,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two),
            label: 'Two',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3),
            label: 'Three',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_4),
            label: 'Four',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_5),
            label: 'Five',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
