# Sequence Detector Service Guide

This directory (`lib/services/SequenceDetectorService/`) manages the detection of specific button press sequences within a defined timeframe. It allows the application to react to custom "cheat codes" or hidden interactions.

## How to Define and Register Sequence Patterns

1.  **Locate `initialize_sequence_detection.dart`:** This file is designed to contain all your application's custom button press sequences.
2.  **Import `services.dart` and `utilities.dart`:** These imports provide access to the `SequenceDetectorService` and the `mozPrint` utility for logging.
3.  **Define patterns and callbacks:** Inside the `initializeSequenceDetection` function, use `SequenceDetectorService().registerPattern()` to define patterns (lists of button indices) and the `callback` function to be executed when the pattern is detected.

### Example Structure: `lib/services/SequenceDetectorService/initialize_sequence_detection.dart`

```dart
import 'package:devlite_flutter/services/services.dart';
import 'package:devlite_flutter/utilities/utilities.dart';

void initializeSequenceDetection() {
  const int sequenceDetectionTimeout = 5;
  SequenceDetectorService()
      .setTimeframe(const Duration(seconds: sequenceDetectionTimeout));

  // Example pattern: Home (0) -> Two (1) -> Home (0)
  SequenceDetectorService().registerPattern([0, 1, 0], () {
    mozPrint('0-1-0 pattern triggered', 'SEQUENCE', 'TRIGGER');
    // Add any specific actions here, e.g., show a dialog, change a theme.
  });

  // Example pattern: Five (4) -> Four (3) -> Three (2) -> Two (1) -> Home (0)
  SequenceDetectorService().registerPattern([4, 3, 2, 1, 0], () {
    mozPrint('4-3-2-1-0 pattern triggered', 'SEQUENCE', 'TRIGGER');
    // Add any specific actions here.
  });

  // You can add more patterns as needed
  // SequenceDetectorService().registerPattern([index1, index2, ...], () { /* action */ });
}
```

**Note on Timeframe:**

- The `setTimeframe()` method sets the maximum duration within which all button presses for a given sequence must occur to be considered a valid detection. This is set globally for all registered patterns.

## Registering New Pattern Initialization Files

The `initialize_sequence_detection.dart` file is already exported by `sequence_detector.dart`. If you were to create additional files for more complex pattern groupings (e.g., `initialize_developer_sequences.dart`), you would need to export them here.

### Modify `lib/services/SequenceDetectorService/sequence_detector.dart`

Add an `export` statement for your new file (if you create one):

```dart
export 'package:devlite_flutter/services/SequenceDetectorService/sequence_detector_service.dart';
export 'package:devlite_flutter/services/SequenceDetectorService/initialize_sequence_detection.dart';
// export 'package:devlite_flutter/services/SequenceDetectorService/initialize_developer_sequences.dart'; // Example for new file
```

## Using the Sequence Detector Service

To enable sequence detection, you need to:

1.  **Import `services.dart`:** This exports the `initializeSequenceDetection` function and the `SequenceDetectorService` instance.

    ```dart
    import 'package:devlite_flutter/services/services.dart';
    ```

2.  **Call `initializeSequenceDetection()`:** This function, typically called once early in the app's lifecycle (e.g., in `PrimaryScreen.initState`), sets up all your predefined patterns.

    ```dart
    @override
    void initState() {
      super.initState();
      initializeSequenceDetection(); // Call this to set up patterns
    }
    ```

3.  **Feed button presses to the service:** In your UI where button presses occur (e.g., `_onItemTapped` for the footer navigation), call `SequenceDetectorService().addPress()` with the index of the pressed button.

    ```dart
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      // ... existing logging
      SequenceDetectorService().addPress(index); // Add the button press to the detector
    }
    ```
