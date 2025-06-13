import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

void initializeSequenceDetection(BuildContext context) {
  const int sequenceDetectionTimeout = 5;
  SequenceDetectorService()
      .setTimeframe(const Duration(seconds: sequenceDetectionTimeout));
  SequenceDetectorService().registerPattern([0, 1, 2, 3, 4, 4, 4], () {
    mozPrint('0-1-2-3-4-4-4 pattern triggered. Showing config dialog.',
        'SEQUENCE', 'TRIGGER');
    executeSequenceMethod_0123444(context);
  });
}
