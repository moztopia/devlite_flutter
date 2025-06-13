import 'dart:async';
import 'package:devlite_flutter/everything.dart';

class AppStateMachine {
  AppState _currentState = AppState.landing;
  final _stateController = StreamController<AppState>.broadcast();

  AppState get currentState => _currentState;
  Stream<AppState> get stateStream => _stateController.stream;

  void addEvent(AppEvent event) {
    AppState saveState = _currentState;
    _currentState = AppTransitions.getNextState(_currentState, event);
    mozPrint('$event', 'FSM', 'EVENT');
    mozPrint('$saveState\x1B[34m ===> \x1B[0m$_currentState', 'FSM', 'STATE');
    _stateController.sink.add(_currentState);
  }

  void reset() {
    _currentState = AppState.landing;
    _stateController.sink.add(_currentState);
    mozPrint('AppStateMachine reset to AppState.landing', 'FSM', 'RESET');
  }

  void dispose() {
    _stateController.close();
  }
}
