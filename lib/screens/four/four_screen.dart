import 'package:flutter/material.dart';
import 'package:devlite_flutter/services/services.dart';

class FourScreen extends StatelessWidget {
  const FourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Text(
          LocalizationService().translate('debug.screens.four.content'),
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
