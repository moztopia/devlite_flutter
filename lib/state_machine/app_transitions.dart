import 'package:devlite_flutter/everything.dart';

class AppTransitions {
  static final Map<AppState, Map<AppEvent, AppState>> _transitions = {
    AppState.landing: {
      AppEvent.goToHome: AppState.home,
      AppEvent.reloadApp: AppState.splash,
      AppEvent.appStarted: AppState.landing,
    },
    AppState.home: {
      AppEvent.reloadApp: AppState.splash,
    },
  };

  static AppState getNextState(AppState currentState, AppEvent event) {
    return _transitions[currentState]?[event] ?? currentState;
  }
}
