import 'package:flutter/widgets.dart';
import 'package:devlite_flutter/everything.dart';

void loadRuntimeData(BuildContext context) {
  _loadScreenAndWindowInfo(context);
  mozPrint('Runtime device data loaded.', 'STARTUP', 'DATA');
}

void _loadScreenAndWindowInfo(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final Configuration config = Configuration();

  config.setKey('device.screen.size.width', mediaQuery.size.width);
  config.setKey('device.screen.size.height', mediaQuery.size.height);
  config.setKey('device.screen.orientation', mediaQuery.orientation.name);

  mozPrint(
      'Screen dimensions: ${mediaQuery.size.width}x${mediaQuery.size.height} @ ${mediaQuery.devicePixelRatio}x DPI. Orientation: ${mediaQuery.orientation.name}',
      'STARTUP',
      'DATA');
}
