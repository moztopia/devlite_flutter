import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

void initializeSequenceDetection(BuildContext context) {
  const int sequenceDetectionTimeout = 5;
  SequenceDetectorService()
      .setTimeframe(const Duration(seconds: sequenceDetectionTimeout));
  SequenceDetectorService().registerPattern([0, 1, 0], () {
    mozPrint('0-1-0 pattern triggered', 'SEQUENCE', 'TRIGGER');
  });
  SequenceDetectorService().registerPattern([4, 3, 2, 1, 0], () {
    mozPrint('4-3-2-1-0 pattern triggered', 'SEQUENCE', 'TRIGGER');
  });
  SequenceDetectorService().registerPattern([0, 1, 2, 3, 4, 4, 4], () {
    mozPrint('0-1-2-3-4-4-4 pattern triggered. Showing config dialog.',
        'SEQUENCE', 'TRIGGER');
    executeSequenceMethod_0123444(context);
  });
  SequenceDetectorService().registerPattern([0, 1, 2, 1, 0], () {
    mozPrint('0-1-2-1-0 pattern triggered. Showing reload config dialog.',
        'SEQUENCE', 'TRIGGER');
    showReloadConfigDialog(context);
  });
}
