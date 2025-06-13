import 'dart:convert';
import 'package:devlite_flutter/everything.dart';

Future<void> loadWelcomeEndpointData() async {
  try {
    final welcomeEndpoint = Configuration().getKey('api.welcome') as String?;
    if (welcomeEndpoint == null || welcomeEndpoint.isEmpty) {
      mozPrint('Welcome endpoint not found in configuration.', 'STARTUP',
          'DATA', 'ERROR');
      return;
    }

    final response = await postWelcome(
        data: {"preferred_language": "en", "client_identifier": "app:android"});

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
