import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:devlite_flutter/widgets/widgets.dart';
import 'package:devlite_flutter/screens/screens.dart';
import 'package:devlite_flutter/utilities/utilities.dart';
import 'package:devlite_flutter/services/services.dart';

class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({super.key});

  @override
  State<PrimaryScreen> createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  final List<Map<String, dynamic>> _drawerItems = [
    {
      'label': LocalizationService().translate('header.drawer.settings'),
      'icon': Icons.settings,
      'isDivider': false
    },
    {'isDivider': true},
    {
      'label': LocalizationService().translate('header.drawer.billing'),
      'icon': Icons.account_balance_wallet,
      'isDivider': false
    },
    {'isDivider': true},
    {
      'label': LocalizationService().translate('header.drawer.feedback'),
      'icon': Icons.feedback,
      'isDivider': false
    },
    {
      'label': LocalizationService().translate('header.drawer.about'),
      'icon': Icons.info,
      'isDivider': false
    },
    {
      'label': LocalizationService().translate('header.drawer.help'),
      'icon': Icons.help,
      'isDivider': false
    },
    {'isDivider': true},
    {
      'label': LocalizationService().translate('header.drawer.logout'),
      'icon': Icons.logout,
      'isDivider': false,
      'isLogout': true
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    mozPrint('${_appBarTitles[index]} was selected', 'NAVIGATION', 'FOOTER');
  }

  void _showLogoutConfirmationDialog() {
    showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AppModalDialog(
          title: LocalizationService().translate('dialog.logout.title'),
          content: LocalizationService().translate('dialog.logout.content'),
          onYes: () {
            mozPrint('Application is quitting.', 'APP', 'EXIT');
            SystemNavigator.pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double topNavBarHeight = screenHeight / 14;

    return Scaffold(
      key: _scaffoldKey,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          mozPrint('Hamburger Menu (closed)', 'NAVIGATION', 'HEADER');
        }
      },
      appBar: TopNavigation(
        title: _appBarTitles[_selectedIndex],
        height: topNavBarHeight,
        onLeadingPressed: () {
          _scaffoldKey.currentState?.openDrawer();
          mozPrint('Hamburger Menu (opened)', 'NAVIGATION', 'HEADER');
        },
      ),
      drawer: Drawer(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _drawerItems.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(LocalizationService().translate('header.title'),
                    style: const TextStyle(color: Colors.white, fontSize: 24)),
              );
            }
            final item = _drawerItems[index - 1];
            if (item['isDivider'] == true) {
              return const Divider();
            }
            return ListTile(
              leading: Icon(item['icon']),
              title: Text(item['label']),
              onTap: () {
                mozPrint(
                    '${item['label']} was selected', 'NAVIGATION', 'HEADER');
                Navigator.pop(context);
                if (item['isLogout'] == true) {
                  _showLogoutConfirmationDialog();
                }
              },
            );
          },
        ),
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
