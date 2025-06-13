# App Modal Dialog Guide

This file (`lib/widgets/dialog_modal_yes_no.dart`) defines a reusable `AppModalDialog` widget for displaying simple yes/no confirmation dialogs. It's particularly useful for actions that require user confirmation before proceeding.

## Purpose

The `AppModalDialog` provides a standardized way to present a modal alert to the user with a title, a content message, and two action buttons: "Yes" and "No". The "No" button simply dismisses the dialog, while the "Yes" button dismisses the dialog and executes a provided callback function.

## How to Use `AppModalDialog`

To display this dialog, you typically use Flutter's `showDialog` function, providing `AppModalDialog` as the `builder`'s return value.

### Parameters

- `title` (required `String`): The text displayed in the dialog's title area.
- `content` (required `String`): The main message or question displayed in the dialog's content area.
- `onYes` (required `VoidCallback`): A callback function that will be executed when the user taps the "Yes" button.

### Example Usage

Here's how you might invoke `AppModalDialog` from another widget, for instance, to confirm a logout action:

```dart
import 'package:flutter/material.dart';
import 'package:devlite_flutter/services/services.dart'; // For LocalizationService
import 'package:devlite_flutter/utilities/utilities.dart'; // For mozPrint
import 'package:devlite_flutter/widgets/widgets.dart'; // For AppModalDialog

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  void _confirmAction(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AppModalDialog(
          title: LocalizationService().translate('dialog.logout.title'), // Example using localized text
          content: LocalizationService().translate('dialog.logout.content'), // Example using localized text
          onYes: () {
            mozPrint('User confirmed YES!', 'EXAMPLE', 'DIALOG');
            // Place the action you want to perform on 'Yes' here
            // e.g., performLogout();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialog Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _confirmAction(context),
          child: const Text('Show Confirmation Dialog'),
        ),
      ),
    );
  }
}
```

In the example above, the dialog title and content are pulled from the `LocalizationService` using keys like `dialog.logout.title` and `dialog.logout.content`, providing support for multiple languages. The `onYes` callback simply logs a message, but in a real application, this is where your critical action (e.g., logging out, deleting an item) would be placed.
