import 'dart:async';
import 'package:devlite_flutter/everything.dart';

typedef LoadingMessageUpdater = void Function(String message, double progress);

Future<String?> _mockGetAuthToken() async {
  return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTkyLjE2OC42OC45OS9hcGkvYXV0aC9naXRodWIvY2FsbGJhY2siLCJpYXQiOjE3NDk2NDUyMjgsImV4cCI6MTc1MjY0NTIyOCwibmJmIjoxNzQ5NjQ1MjI4LCJqdGkiOiJHQmxRS2FGYklpSmU4SFNmIiwic3ViIjoiMDE5NzVlZjktNzUzZS03MGE3LWExMTUtYTBkYWE3NjhhYWMxIiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyIsInByb2ZpbGVfaWQiOiIwMTk3NWVmOS03NTU5LTcwMDItYmQ0YS05OTA1ZmFkMWYwYmUifQ.ZMCL4wbKFkAjHe7_vRqzyHX6SnFA2BzCv3OVgNWe41s';
}

Future<void> performStartupProcess({
  required LoadingMessageUpdater updateMessage,
}) async {
  List<String> loadingSteps = [
    'Initializing...',
    'Loading Assets...',
    'Loading Environment...',
    'Loading Languages...',
    'Starting Services...',
    'Connecting...',
    '1..2..3......Blast Off!'
  ];

  int currentStep = 0;
  final int totalSteps = loadingSteps.length;

  try {
    currentStep++;
    updateMessage(loadingSteps[0], currentStep / totalSteps);
    await initializePlatformEnvironment();
    await Future.delayed(const Duration(seconds: 1));

    currentStep++;
    updateMessage(loadingSteps[1], currentStep / totalSteps);
    await loadAssetConfiguration();
    await Future.delayed(const Duration(seconds: 1));

    currentStep++;
    updateMessage(loadingSteps[2], currentStep / totalSteps);
    loadDeviceData();
    await Future.delayed(const Duration(seconds: 1));

    currentStep++;
    updateMessage(loadingSteps[3], currentStep / totalSteps);
    await loadLocalizationData();
    await Future.delayed(const Duration(seconds: 1));

    currentStep++;
    updateMessage(loadingSteps[4], currentStep / totalSteps);
    final String? apiBaseUrl = Configuration().getKey('api.baseurl');
    final Uri? parsedUri = apiBaseUrl != null ? Uri.tryParse(apiBaseUrl) : null;

    if (apiBaseUrl == null || parsedUri == null || !parsedUri.isAbsolute) {
      throw Exception(
          'API base URL is invalid or missing in configuration. Cannot proceed without a valid API endpoint.');
    }

    ApiService().initialize(
      baseUrl: apiBaseUrl,
      tokenProvider: _mockGetAuthToken,
      anonymousPaths: ['/welcome', '/auth/login', '/auth/register'],
    );

    await Future.delayed(const Duration(seconds: 1));

    currentStep++;
    updateMessage(loadingSteps[5], currentStep / totalSteps);
    await loadWelcomeEndpointData();
    await Future.delayed(const Duration(seconds: 1));

    currentStep++;
    updateMessage(loadingSteps[6], currentStep / totalSteps);
    await Future.delayed(const Duration(seconds: 1));

    mozPrint('All startup tasks completed successfully.', 'STARTUP', 'PROCESS');
  } catch (e) {
    mozPrint('Startup process failed: $e', 'STARTUP', 'PROCESS', 'ERROR');
    rethrow;
  }
}
