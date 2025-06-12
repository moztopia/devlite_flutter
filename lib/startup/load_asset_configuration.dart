import 'package:devlite_flutter/services/services.dart';
import 'package:devlite_flutter/utilities/utilities.dart';

Future<void> loadAssetConfiguration() async {
  await Configuration().load();
  mozPrint('Asset configuration loaded.', 'STARTUP', 'DATA');
}
