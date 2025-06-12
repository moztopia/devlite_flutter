import 'package:devlite_flutter/utilities/utilities.dart';
import 'package:devlite_flutter/services/services.dart';

Future<void> loadLocalizationData() async {
  await LocalizationService().initializeLocale();
  mozPrint(
      'Localization data loaded based on device locale.', 'STARTUP', 'DATA');
}
