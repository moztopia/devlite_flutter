import 'package:flutter/material.dart';
import 'package:devlite_flutter/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:devlite_flutter/state_machine/state_machine.dart';
import 'package:devlite_flutter/screens/screens.dart';

class AppOrchestratorScreen extends StatefulWidget {
  const AppOrchestratorScreen({super.key});

  @override
  State<AppOrchestratorScreen> createState() => _AppOrchestratorScreenState();
}

class _AppOrchestratorScreenState extends State<AppOrchestratorScreen> {
  AppState? _previousState;

  @override
  Widget build(BuildContext context) {
    final appStateMachine = context.watch<AppStateMachine>();

    return StreamBuilder<AppState>(
      stream: appStateMachine.stateStream,
      initialData: appStateMachine.currentState,
      builder: (context, snapshot) {
        final AppState currentState = snapshot.data ?? AppState.landing;
        mozPrint('Current FSM state: $currentState', 'BUILDER');

        final TransitionType transitionType =
            AppEffects.getTransitionType(_previousState, currentState);
        _previousState = currentState;

        Widget currentScreen;
        switch (currentState) {
          case AppState.landing:
            currentScreen = const LandingScreen();
            break;
          case AppState.home:
            currentScreen = const PrimaryScreen();
            break;
          case AppState
                .splash: // Keep this for robustness, but it should never be hit if FSM starts at Landing
            currentScreen = const Text(
                'Error: Orchestrator unexpectedly received AppState.splash');
            break;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return AppEffects.buildTransition(child, animation, transitionType);
          },
          child: SizedBox(
            key: ValueKey(currentState),
            child: currentScreen,
          ),
        );
      },
    );
  }
}
