import 'package:devlite_flutter/state_machine/app_states.dart';
import 'package:devlite_flutter/state_machine/app_events.dart';

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
