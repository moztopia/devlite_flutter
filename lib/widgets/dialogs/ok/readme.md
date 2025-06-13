# App OK Modal Dialog Guide

This file (`lib/widgets/dialogs/ok/dialog_modal_ok.dart`) defines a reusable `AppOKModalDialog` widget for displaying simple informational or single-action dialogs. It's suitable for conveying messages that only require acknowledgement.

## Purpose

The `AppOKModalDialog` presents a modal alert to the user with a title, a content message, and a single "OK" button. Tapping "OK" dismisses the dialog and can optionally execute a provided callback function.

## How to Use `AppOKModalDialog`

To display this dialog, you typically use Flutter's `showDialog` function, providing `AppOKModalDialog` as the `builder`'s return value.

### Parameters

- `title` (required `String`): The text displayed in the dialog's title area.
- `content` (required `String`): The main message or information displayed in the dialog's content area.
- `onOk` (optional `VoidCallback`): A callback function that will be executed when the user taps the "OK" button, after the dialog is dismissed.

### Example Usage

Here's how you might invoke `AppOKModalDialog` from another widget, for instance, to inform the user about a successful operation or an error:

```dart
import 'package:flutter/material.dart';
import 'package:devlite_flutter/services/services.dart'; // For LocalizationService
import 'package:devlite_flutter/utilities/utilities.dart'; // For mozPrint
import 'package:devlite_flutter/widgets/widgets.dart'; // For AppOKModalDialog (via export)

class AnotherExampleScreen extends StatelessWidget {
  const AnotherExampleScreen({super.key});

  void _showInformationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AppOKModalDialog(
          title: 'Information',
          content: 'Operation completed successfully!',
          onOk: () {
            mozPrint('User acknowledged OK.', 'EXAMPLE', 'DIALOG');
            // Optional: Perform any action after the user clicks OK.
          },
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AppOKModalDialog(
          title: 'Error',
          content: 'An unexpected error occurred. Please try again.',
          // No onOk callback needed if no action is required after dismissal.
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OK Dialog Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showInformationDialog(context),
              child: const Text('Show Info Dialog'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showErrorDialog(context),
              child: const Text('Show Error Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}
```

The "OK" button's text is automatically localized using `LocalizationService().translate('dialog.button.ok')`. You will need to ensure your `localization.json` files contain an entry for `dialog.button.ok` (e.g., `"ok": "OK"`).
