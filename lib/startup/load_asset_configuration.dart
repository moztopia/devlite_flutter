import 'package:devlite_flutter/everything.dart';

Future<void> loadAssetConfiguration() async {
  await Configuration().load();
  mozPrint('Asset configuration loaded.', 'STARTUP', 'DATA');
}
