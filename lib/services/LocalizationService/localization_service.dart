import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:devlite_flutter/everything.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;

  Map<String, dynamic> _localizedStrings = {};
  Map<String, dynamic> _fallbackStrings = {};
  String _currentLocale = 'en';
  late String _fallbackLocale;
  List<String> _availableLocales = [];
  late ValueNotifier<String> _localeNotifier;

  LocalizationService._internal() {
    _localeNotifier = ValueNotifier<String>(_currentLocale);
  }

  String get currentLocale => _currentLocale;
  List<String> get availableLocales => _availableLocales;
  ValueNotifier<String> get localeNotifier => _localeNotifier;

  Future<Map<String, dynamic>> _loadLocale(String locale) async {
    final String path = 'assets/languages/$locale.json';
    try {
      final String jsonString = await rootBundle.loadString(path);
      return json.decode(jsonString);
    } catch (e) {
      mozPrint('Failed to load localization for "$locale": $e',
          'INITIALIZATION', 'LOCALIZATION', 'ERROR');
      return {};
    }
  }

  Future<void> load(String locale) async {
    _currentLocale = locale;
    _localizedStrings = await _loadLocale(_currentLocale);
    mozPrint('Localization for "$_currentLocale" loaded successfully.',
        'INITIALIZATION', 'LOCALIZATION');
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
          'INITIALIZATION', 'LOCALIZATION', 'WARNING');
      translatedValue = key;
    }

    return translatedValue;
  }

  Future<void> setCurrentLocale(String locale) async {
    _currentLocale = locale;
    await load(_currentLocale);
    _localeNotifier.value = _currentLocale;
  }

  String _getDeviceLanguageCode() {
    final Configuration config = Configuration();
    final String? languageCode = config.getKey('device.locale.languageCode');
    return languageCode ?? config.getKey('language.fallback') ?? 'en';
  }

  Future<void> initializeLocale() async {
    try {
      final assetManifestString =
          await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(assetManifestString);

      final List<String> foundLocales = [];
      for (final String assetPath in manifestMap.keys) {
        if (assetPath.startsWith('assets/languages/') &&
            assetPath.endsWith('.json') &&
            !assetPath.contains('.source.json')) {
          final String fileName = assetPath.split('/').last;
          final String languageCode = fileName.replaceAll('.json', '');
          foundLocales.add(languageCode);
        }
      }
      _availableLocales = foundLocales.toSet().toList()..sort();
      mozPrint('Discovered available locales: $_availableLocales',
          'INITIALIZATION', 'LOCALIZATION');
    } catch (e) {
      mozPrint('Failed to scan AssetManifest.json for locales: $e',
          'INITIALIZATION', 'LOCALIZATION', 'ERROR');
      _availableLocales = [];
    }

    final Configuration config = Configuration();
    _fallbackLocale = config.getKey('language.fallback') as String? ?? 'en';

    String? preferredLanguageCode =
        config.getKey('language.preferred') as String?;
    String langCode = preferredLanguageCode ?? _getDeviceLanguageCode();

    if (!_availableLocales.contains(langCode)) {
      mozPrint(
          'Preferred language "$langCode" not found, falling back to "$_fallbackLocale".',
          'INITIALIZATION',
          'LOCALIZATION',
          'WARNING');
      langCode = _fallbackLocale;
    }

    _currentLocale = langCode;
    _localeNotifier.value = _currentLocale;

    _localizedStrings = await _loadLocale(_currentLocale);
    if (_currentLocale != _fallbackLocale) {
      _fallbackStrings = await _loadLocale(_fallbackLocale);
    } else {
      _fallbackStrings = _localizedStrings;
    }

    mozPrint(
        'Localization initialized for "$_currentLocale" (fallback "$_fallbackLocale").',
        'INITIALIZATION',
        'LOCALIZATION');
  }
}
