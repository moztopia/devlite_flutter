import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:devlite_flutter/utilities/utilities.dart';
import 'package:devlite_flutter/services/services.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  Map<String, dynamic> _localizedStrings = {};
  Map<String, dynamic> _fallbackStrings = {};
  String _currentLocale = 'en';
  late String _fallbackLocale;

  String get currentLocale => _currentLocale;

  Future<Map<String, dynamic>> _loadLocale(String locale) async {
    final String path = 'assets/languages/$locale.json';
    try {
      final String jsonString = await rootBundle.loadString(path);
      return json.decode(jsonString);
    } catch (e) {
      mozPrint('Failed to load localization for "$locale": $e', 'LOCALIZATION',
          '', 'ERROR');
      return {};
    }
  }

  Future<void> load(String locale) async {
    _currentLocale = locale;
    _localizedStrings = await _loadLocale(_currentLocale);
    mozPrint('Localization for "$_currentLocale" loaded successfully.',
        'LOCALIZATION');
  }

  String translate(String key) {
    List<String> parts = key.split('.');
    dynamic currentLevel = _localizedStrings;
    dynamic fallbackLevel = _fallbackStrings;
    String translatedValue;

    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      if (currentLevel is Map<String, dynamic> &&
          currentLevel.containsKey(part)) {
        currentLevel = currentLevel[part];
      } else {
        currentLevel = null;
      }

      if (fallbackLevel is Map<String, dynamic> &&
          fallbackLevel.containsKey(part)) {
        fallbackLevel = fallbackLevel[part];
      } else {
        fallbackLevel = null;
      }
    }

    if (currentLevel != null) {
      translatedValue = currentLevel.toString();
    } else if (fallbackLevel != null) {
      translatedValue = fallbackLevel.toString();
      mozPrint(
          'Key "$key" not found in "$_currentLocale", falling back to "$_fallbackLocale".',
          'LOCALIZATION',
          '',
          'WARNING');
    } else {
      mozPrint('Localization key "$key" not found in any locale.',
          'LOCALIZATION', '', 'WARNING');
      translatedValue = key;
    }

    return translatedValue;
  }

  Future<void> setCurrentLocale(String locale) async {
    _currentLocale = locale;
    await load(_currentLocale);
  }

  String _getDeviceLanguageCode() {
    final Configuration config = Configuration();
    final String? languageCode = config.getKey('device.locale.languageCode');
    return languageCode ?? config.getKey('languages.fallback') ?? 'en';
  }

  Future<void> initializeLocale() async {
    final Configuration config = Configuration();
    _fallbackLocale = config.getKey('language.fallback') as String? ?? 'en';

    String? preferredLanguageCode =
        config.getKey('language.preferred') as String?;
    String langCode = preferredLanguageCode ?? _getDeviceLanguageCode();
    _currentLocale = langCode;

    _localizedStrings = await _loadLocale(_currentLocale);
    if (_currentLocale != _fallbackLocale) {
      _fallbackStrings = await _loadLocale(_fallbackLocale);
    } else {
      _fallbackStrings = _localizedStrings;
    }

    mozPrint(
        'Localization initialized for "$_currentLocale" (fallback "$_fallbackLocale").',
        'LOCALIZATION');
  }
}
