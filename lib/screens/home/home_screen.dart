import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Text(
          LocalizationService().translate('debug.screens.home.content'),
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
