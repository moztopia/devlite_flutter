import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devlite_flutter/everything.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DevliteBootstrapApp());
}

class DevliteBootstrapApp extends StatelessWidget {
  const DevliteBootstrapApp({super.key});

  Future<bool> _initializeApp() async {
    await performStartupProcess(
      updateMessage: (_, __) {},
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              backgroundColor: Color(0xFF2196F3),
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          );
        }

        return Provider<AppStateMachine>(
          create: (_) => AppStateMachine()..addEvent(AppEvent.appStarted),
          dispose: (_, appStateMachine) => appStateMachine.dispose(),
          child: const DevliteFlutterApp(),
        );
      },
    );
  }
}

class DevliteFlutterApp extends StatelessWidget {
  const DevliteFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Configuration();
    final themeModeString = config.getKey('theme.mode') ?? 'system';
    final themeMode = switch (themeModeString) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    loadRuntimeData(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: config.getKey('app.title'),
      theme: buildMainTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      home: const AppOrchestratorScreen(),
    );
  }
}
