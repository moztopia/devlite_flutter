import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:devlite_flutter/utilities/utilities.dart';

Future<void> initializePlatformEnvironment() async {
  const double windowWidth = (50 * 9);
  const double windowHeight = (50 * 16);
  const double windowAspectRatio = windowWidth / windowHeight;

  if (TargetPlatform.linux == defaultTargetPlatform ||
      TargetPlatform.macOS == defaultTargetPlatform ||
      TargetPlatform.windows == defaultTargetPlatform) {
    await windowManager.ensureInitialized();

    final String windowTitle = 'Devlite Window';

    WindowOptions initialWindowOptions = WindowOptions(
      size: const Size(windowWidth, windowHeight),
      minimumSize: const Size(windowWidth, windowHeight),
      maximumSize: const Size(windowWidth, windowHeight),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: windowTitle,
    );

    await windowManager.waitUntilReadyToShow(initialWindowOptions, () async {
      await windowManager.setSize(const Size(windowWidth, windowHeight));
      await windowManager.setMinimumSize(const Size(windowWidth, windowHeight));
      await windowManager.setMaximumSize(const Size(windowWidth, windowHeight));
      await windowManager.setAspectRatio(windowAspectRatio);
      await windowManager.center();
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setTitle(windowTitle);

      mozPrint(
          'Desktop window initialized to ${windowWidth.toInt()}x${windowHeight.toInt()} with aspect ratio ${windowAspectRatio.toStringAsFixed(2)}',
          'INITIALIZATION',
          'PLATFORM');
    });
  }

  if (TargetPlatform.android == defaultTargetPlatform ||
      TargetPlatform.iOS == defaultTargetPlatform) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    mozPrint(
        'Mobile orientation set to portrait.', 'INITIALIZATION', 'PLATFORM');
  }
}
