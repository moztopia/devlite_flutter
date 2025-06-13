import 'package:devlite_flutter/utilities/utilities.dart';

class SequenceDetectorService {
  static final SequenceDetectorService _instance =
      SequenceDetectorService._internal();
  factory SequenceDetectorService() => _instance;
  SequenceDetectorService._internal();

  final List<({int index, DateTime timestamp})> _pressHistory = [];
  final Map<List<int>, Function> _registeredPatterns = {};
  Duration _timeframe = const Duration(seconds: 3);

  void setTimeframe(Duration duration) {
    _timeframe = duration;
    mozPrint('SequenceDetector timeframe set to ${duration.inSeconds} seconds.',
        'SEQUENCE', 'CONFIGURE');
  }

  void registerPattern(List<int> pattern, Function callback) {
    _registeredPatterns[pattern] = callback;
    mozPrint('Registered pattern: $pattern', 'SEQUENCE', 'CONFIGURE');
  }

  void addPress(int index) {
    _pressHistory.add((index: index, timestamp: DateTime.now()));
    _pruneHistory();
    _checkPatterns();
  }

  void _pruneHistory() {
    final DateTime cutoff = DateTime.now().subtract(_timeframe);
    _pressHistory.removeWhere((entry) => entry.timestamp.isBefore(cutoff));
  }

  void _checkPatterns() {
    if (_pressHistory.isEmpty) return;

    for (final pattern in _registeredPatterns.keys) {
      if (_pressHistory.length >= pattern.length) {
        final List<int> currentSequence = _pressHistory
            .sublist(_pressHistory.length - pattern.length)
            .map((e) => e.index)
            .toList();

        if (listEquals(currentSequence, pattern)) {
          final DateTime firstPressTime =
              _pressHistory[_pressHistory.length - pattern.length].timestamp;
          final DateTime lastPressTime = _pressHistory.last.timestamp;

          if (lastPressTime.difference(firstPressTime) <= _timeframe) {
            mozPrint('Pattern $pattern detected!', 'SEQUENCE', 'DETECTED');
            _registeredPatterns[pattern]?.call();
            _pressHistory.clear();
            break;
          }
        }
      }
    }
  }

  void reset() {
    _pressHistory.clear();
    mozPrint('SequenceDetector history reset.', 'SEQUENCE', 'HISTORY');
  }

  bool listEquals<T>(List<T>? a, List<T>? b) {
    if (a == b) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
