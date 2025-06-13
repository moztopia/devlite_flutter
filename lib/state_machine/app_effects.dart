import 'dart:math';
import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

enum TransitionType {
  none,
  fade,
  slide,
  scale,
  rotate,
  size,
  random,
}

typedef _TransitionBuilder = Widget Function(
    Widget child, Animation<double> animation);

class AppEffects {
  static const TransitionType defaultTransition = TransitionType.fade;
  static final Random _random = Random();

  static final Map<({AppState from, AppState to}), TransitionType>
      _stateToStateTransitions = {
    (from: AppState.splash, to: AppState.landing): TransitionType.slide,
    (from: AppState.landing, to: AppState.home): TransitionType.fade,
    (from: AppState.home, to: AppState.splash): TransitionType.random,
  };

  static final Map<TransitionType, _TransitionBuilder> _transitionBuilders = {
    TransitionType.fade: (child, animation) =>
        FadeTransition(opacity: animation, child: child),
    TransitionType.slide: (child, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
    TransitionType.scale: (child, animation) =>
        ScaleTransition(scale: animation, child: child),
    TransitionType.rotate: (child, animation) => RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        ),
    TransitionType.size: (child, animation) => SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: child,
        ),
    TransitionType.none: (child, animation) => child,
  };

  static TransitionType getTransitionType(AppState? from, AppState to) {
    if (from == null) {
      return TransitionType.none;
    }
    return _stateToStateTransitions[(from: from, to: to)] ?? defaultTransition;
  }

  static Widget buildTransition(
      Widget child, Animation<double> animation, TransitionType type) {
    if (type == TransitionType.random) {
      final List<TransitionType> possibleTransitions = TransitionType.values
          .where((t) => t != TransitionType.none && t != TransitionType.random)
          .toList();
      final TransitionType randomType =
          possibleTransitions[_random.nextInt(possibleTransitions.length)];
      mozPrint(
          '"${randomType.name}" RANDOMLY applied to the outgoing/incoming transition.',
          'FSM',
          'EFFECT');
      return _transitionBuilders[randomType]?.call(child, animation) ?? child;
    }
    mozPrint('"${type.name}" applied to the outgoing/incoming transition.',
        'FSM', 'EFFECT');
    return _transitionBuilders[type]?.call(child, animation) ?? child;
  }
}
