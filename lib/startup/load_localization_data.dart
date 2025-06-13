import 'package:devlite_flutter/utilities/utilities.dart';
import 'package:devlite_flutter/services/services.dart';

Future<void> loadLocalizationData() async {
  await LocalizationService().initializeLocale();

  Configuration()
      .setKey('language.available', LocalizationService().availableLocales);
  mozPrint(
      'Available languages saved to Configuration: ${LocalizationService().availableLocales}',
      'STARTUP',
      'DATA');

  mozPrint(
      'Localization data loaded based on device locale.', 'STARTUP', 'DATA');
}
