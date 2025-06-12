import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:devlite_flutter/utilities/utilities.dart';

class Configuration {
  static final Configuration _instance = Configuration._internal();
  factory Configuration() => _instance;
  Configuration._internal();

  Map<String, dynamic> _configData = {};

  Future<void> load() async {
    try {
      final String response =
          await rootBundle.loadString('assets/main_configuration.json');
      _configData = json.decode(response);
      mozPrint('Configuration loaded successfully.', 'CONFIGURATION');
    } catch (e) {
      mozPrint(
          'Unable to load configuration: $e', 'CONFIGURATION', '', 'ERROR');
      _configData = {};
    }
  }

  Future<void> resetAndLoad() async {
    _configData = {};
    await load();
    mozPrint('Configuration reset and reloaded.', 'CONFIGURATION');
  }

  dynamic getKey(String keyPath) {
    List<String> parts = keyPath.split('.');
    dynamic currentLevel = _configData;

    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      if (currentLevel is Map<String, dynamic> &&
          currentLevel.containsKey(part)) {
        currentLevel = currentLevel[part];
      } else {
        mozPrint(
            'Configuration key path "$keyPath" not found at part "$part". Returning null.',
            'CONFIGURATION',
            '',
            'WARNING');
        return null;
      }
    }
    return currentLevel;
  }

  void setKey(String keyPath, dynamic value) {
    List<String> parts = keyPath.split('.');
    Map<String, dynamic> currentLevel = _configData;

    for (int i = 0; i < parts.length - 1; i++) {
      String part = parts[i];
      if (currentLevel[part] is! Map<String, dynamic>) {
        currentLevel[part] = <String, dynamic>{};
      }
      currentLevel = currentLevel[part] as Map<String, dynamic>;
    }

    String finalPart = parts.last;
    currentLevel[finalPart] = value;
  }

  Map<String, dynamic> getAllConfigData() {
    return Map.from(_configData);
  }
}
