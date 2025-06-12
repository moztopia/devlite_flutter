import 'package:flutter/material.dart';
import 'package:devlite_flutter/services/services.dart';

class ThreeScreen extends StatelessWidget {
  const ThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocalizationService().translate('debug.screens.three.content'),
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
