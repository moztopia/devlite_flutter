import 'package:flutter/material.dart';
import 'package:devlite_flutter/services/services.dart';

class FiveScreen extends StatelessWidget {
  const FiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocalizationService().translate('debug.screens.five.content'),
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
