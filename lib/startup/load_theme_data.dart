import 'package:flutter/material.dart';
import 'package:devlite_flutter/services/services.dart';

MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};

  final int rInt = (color.r * 255).round().clamp(0, 255);
  final int gInt = (color.g * 255).round().clamp(0, 255);
  final int bInt = (color.b * 255).round().clamp(0, 255);

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      rInt + ((ds < 0 ? rInt : (255 - rInt)) * ds).round(),
      gInt + ((ds < 0 ? gInt : (255 - gInt)) * ds).round(),
      bInt + ((ds < 0 ? bInt : (255 - bInt)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.toARGB32(), swatch);
}

ThemeData buildMainTheme() {
  final Configuration config = Configuration();
  final String? baseColorHex = config.getKey('theme.baseColor');

  if (baseColorHex == null) {
    throw StateError('Theme baseColor is missing in configuration.');
  }

  Color primaryColor = Color(int.parse(baseColorHex));

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    primaryColor: primaryColor,
    primarySwatch: _createMaterialColor(primaryColor),
  );
}

ThemeData buildDarkTheme() {
  final Configuration config = Configuration();
  final String? baseColorHex = config.getKey('theme.baseColor');

  if (baseColorHex == null) {
    throw StateError('Theme baseColor is missing in configuration.');
  }

  Color primaryColor = Color(int.parse(baseColorHex));

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    primaryColor: primaryColor,
    primarySwatch: _createMaterialColor(primaryColor),
  );
}
