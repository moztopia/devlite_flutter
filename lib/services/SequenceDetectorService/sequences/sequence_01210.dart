import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

void showReloadConfigDialog(BuildContext context) {
  showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AppModalDialog(
        title: LocalizationService().translate('dialog.reloadConfig.title'),
        content: LocalizationService().translate('dialog.reloadConfig.content'),
        onYes: () async {
          mozPrint(
              'Reloading app data initiated by sequence...', 'APP', 'RELOAD');

          await Configuration().resetAndLoad();
          loadDeviceData();
          await loadLocalizationData();

          final String? apiBaseUrl = Configuration().getKey('api.baseurl');
          final Uri? parsedUri =
              apiBaseUrl != null ? Uri.tryParse(apiBaseUrl) : null;

          if (apiBaseUrl == null ||
              parsedUri == null ||
              !parsedUri.isAbsolute) {
            mozPrint(
                'Invalid API base URL after reload. API service may not function correctly.',
                'API',
                'RELOAD',
                'ERROR');
          } else {
            ApiService().initialize(baseUrl: apiBaseUrl);
          }
          await loadWelcomeEndpointData();

          mozPrint('App data reloaded successfully.', 'APP', 'RELOAD');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(LocalizationService()
                    .translate('dialog.reloadConfig.success'))),
          );
        },
      );
    },
  );
}
