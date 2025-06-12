import 'package:devlite_flutter/utilities/utilities.dart';
import 'package:devlite_flutter/services/services.dart';
import 'dart:ui';

void loadDeviceData() {
  _loadLocales();
  _loadTimeFormatPreference();
  _loadDefaultRouteName();
  mozPrint('Initial device data loaded.', 'STARTUP', 'DATA');
}

void _loadLocales() {
  final locales = PlatformDispatcher.instance.locales;
  if (locales.isNotEmpty) {
    final primaryLocale = locales.first;
    Configuration()
        .setKey('device.locale.languageCode', primaryLocale.languageCode);
    if (primaryLocale.countryCode != null) {
      Configuration()
          .setKey('device.locale.countryCode', primaryLocale.countryCode);
    }
    mozPrint('Device locale loaded: ${primaryLocale.toLanguageTag()}',
        'STARTUP', 'DATA');
  } else {
    mozPrint('No device locales found.', 'STARTUP', 'DATA', 'WARNING');
  }
}

void _loadTimeFormatPreference() {
  final use24HourFormat = PlatformDispatcher.instance.alwaysUse24HourFormat;
  Configuration().setKey('device.alwaysUse24HourFormat', use24HourFormat);
  mozPrint('Device 24-hour format preference loaded: $use24HourFormat',
      'STARTUP', 'DATA');
}

void _loadDefaultRouteName() {
  final defaultRoute = PlatformDispatcher.instance.defaultRouteName;
  Configuration().setKey('device.defaultRouteName', defaultRoute);
  mozPrint('Default route name loaded: $defaultRoute', 'STARTUP', 'DATA');
}
