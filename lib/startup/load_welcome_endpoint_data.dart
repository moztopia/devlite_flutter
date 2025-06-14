// lib/startup/load_welcome_endpoint_data.dart
import 'dart:convert';
import 'package:devlite_flutter/everything.dart';
import 'package:flutter/foundation.dart';

Future<void> loadWelcomeEndpointData() async {
  try {
    final welcomeEndpoint = Configuration().getKey('api.welcome') as String?;
    if (welcomeEndpoint == null || welcomeEndpoint.isEmpty) {
      mozPrint('Welcome endpoint not found in configuration.', 'STARTUP',
          'DATA', 'ERROR');
      return;
    }

    final String preferredLanguage =
        Configuration().getKey('device.locale.languageCode') as String? ?? 'en';

    String platformIdentifier;
    if (defaultTargetPlatform == TargetPlatform.android) {
      platformIdentifier = 'android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      platformIdentifier = 'ios';
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      platformIdentifier = 'windows';
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      platformIdentifier = 'macos';
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      platformIdentifier = 'linux';
    } else {
      platformIdentifier = 'unknown';
      mozPrint(
          'Unknown client platform: $defaultTargetPlatform: ${platformIdentifier}',
          'STARTUP',
          'DATA',
          'WARNING');
    }
    final String clientIdentifier = 'app:$platformIdentifier';

    final response = await postWelcome(data: {
      "preferred_language": preferredLanguage,
      "client_identifier": clientIdentifier
    });

    if (response.statusCode == 200) {
      mozPrint('Welcome data fetched successfully:', 'STARTUP', 'DATA');
      mozPrint(jsonEncode(response.data), 'STARTUP', 'DATA');
      Configuration().setKey('welcome', response.data);
    } else {
      mozPrint('Failed to fetch welcome data: ${response.statusCode}',
          'STARTUP', 'DATA', 'ERROR');
      Configuration().setKey('welcome',
          'You need an API endpoint called welcome that populates this section.');
    }
  } catch (e) {
    Configuration().setKey('welcome',
        'You need an API endpoint called welcome that populates this section.');
    mozPrint('Error fetching welcome data: $e', 'STARTUP', 'DATA', 'ERROR');
  }
}
