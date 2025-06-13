import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devlite_flutter/state_machine/state_machine.dart';
import 'package:devlite_flutter/screens/screens.dart';
import 'package:devlite_flutter/startup/startup.dart';
import 'package:devlite_flutter/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const InitialSplashScreenRoot());
}

class InitialSplashScreenRoot extends StatefulWidget {
  const InitialSplashScreenRoot({super.key});

  @override
  State<InitialSplashScreenRoot> createState() =>
      _InitialSplashScreenRootState();
}

class _InitialSplashScreenRootState extends State<InitialSplashScreenRoot> {
  String _loadingMessage = 'Initializing application...';
  double _loadingProgress = 0.0;
  bool _startupTasksCompleted = false;

  @override
  void initState() {
    super.initState();
    _startSplashProcess();
  }

  void _updateLoadingMessage(String message, double progress) {
    if (mounted) {
      setState(() {
        _loadingMessage = message;
        _loadingProgress = progress;
      });
    }
  }

  Future<void> _startSplashProcess() async {
    try {
      await performStartupProcess(
        updateMessage: _updateLoadingMessage,
      );
      _startupTasksCompleted = true;
    } catch (e) {
      _updateLoadingMessage('Startup Error: $e', 0.0);
      _startupTasksCompleted = false;
      return;
    } finally {
      if (mounted && _startupTasksCompleted) {
        runApp(
          Provider<AppStateMachine>(
            create: (_) => AppStateMachine(),
            dispose: (_, appStateMachine) => appStateMachine.dispose(),
            child: const DevliteFlutterApp(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF2196F3),
        primaryColor: const Color(0xFF2196F3),
      ),
      home: SplashScreen(message: _loadingMessage, progress: _loadingProgress),
    );
  }
}

class DevliteFlutterApp extends StatefulWidget {
  const DevliteFlutterApp({super.key});

  @override
  State<DevliteFlutterApp> createState() => _DevliteFlutterAppState();
}

class _DevliteFlutterAppState extends State<DevliteFlutterApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadRuntimeData(context);
      context.read<AppStateMachine>().addEvent(AppEvent.appStarted);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Configuration config = Configuration();
    final String themeModeString = config.getKey('theme.mode') ?? 'system';
    ThemeMode themeMode = ThemeMode.system;

    switch (themeModeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'system':
      default:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp(
      title: 'Devlite Flutter',
      theme: buildMainTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      home: const AppOrchestratorScreen(),
    );
  }
}
