import 'package:flutter/material.dart';
import 'package:devlite_flutter/services/services.dart';

class TwoScreen extends StatelessWidget {
  const TwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocalizationService().translate('debug.screens.two.content'),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
