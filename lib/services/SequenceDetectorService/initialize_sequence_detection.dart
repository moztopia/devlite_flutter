import 'package:devlite_flutter/services/services.dart';
import 'package:devlite_flutter/utilities/utilities.dart';

void initializeSequenceDetection() {
  const int sequenceDetectionTimeout = 5;
  SequenceDetectorService()
      .setTimeframe(const Duration(seconds: sequenceDetectionTimeout));
  SequenceDetectorService().registerPattern([0, 1, 0], () {
    mozPrint('0-1-0 pattern triggered', 'SEQUENCE', 'TRIGGER');
  });
  SequenceDetectorService().registerPattern([4, 3, 2, 1, 0], () {
    mozPrint('4-3-2-1-0 pattern triggered', 'SEQUENCE', 'TRIGGER');
  });
}
