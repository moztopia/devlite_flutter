import 'package:flutter/material.dart';
import 'package:devlite_flutter/services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocalizationService().translate('debug.screens.home.content'),
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
