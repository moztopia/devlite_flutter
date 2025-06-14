import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:devlite_flutter/everything.dart';

class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({super.key});

  @override
  State<PrimaryScreen> createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _onLocaleChanged() {
    setState(() {});
  }

  List<Widget> get _screens => [
        HomeScreen(),
        TwoScreen(),
        ThreeScreen(),
        FourScreen(),
        FiveScreen(),
      ];

  List<String> get _appBarTitles => [
        LocalizationService().translate('header.bar.label.home'),
        LocalizationService().translate('header.bar.label.two'),
        LocalizationService().translate('header.bar.label.three'),
        LocalizationService().translate('header.bar.label.four'),
        LocalizationService().translate('header.bar.label.five')
      ];

  List<Map<String, dynamic>> get _drawerItems => [
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

  @override
  void initState() {
    super.initState();
    initializeSequenceDetection(context);
    LocalizationService().localeNotifier.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    LocalizationService().localeNotifier.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    mozPrint('${_appBarTitles[index]} was selected', 'NAVIGATION', 'FOOTER');
    SequenceDetectorService().addPress(index);
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
      extendBodyBehindAppBar: false,
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
        actions: const [
          HeaderLanguageSelector(),
        ],
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: LocalizationService().translate('footer.bar.label.home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two),
            label: LocalizationService().translate('footer.bar.label.two'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3),
            label: LocalizationService().translate('footer.bar.label.three'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_4),
            label: LocalizationService().translate('footer.bar.label.four'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_5),
            label: LocalizationService().translate('footer.bar.label.five'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context)
            .colorScheme
            .onSurface
            .withAlpha((0.6 * 255).round()),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
