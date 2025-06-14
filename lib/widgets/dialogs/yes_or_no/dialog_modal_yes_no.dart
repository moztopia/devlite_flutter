import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

class AppModalDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onYes;

  const AppModalDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return DialogBaseWidget(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            mozPrint(
                'Dialog: ${LocalizationService().translate('dialog.button.no')} pressed',
                'DIALOG',
                'MODAL');
            Navigator.of(context).pop(false);
          },
          child: Text(LocalizationService().translate('dialog.button.no')),
        ),
        TextButton(
          onPressed: () {
            mozPrint(
                'Dialog: ${LocalizationService().translate('dialog.button.yes')} pressed',
                'DIALOG',
                'MODAL');
            Navigator.of(context).pop(true);
            onYes();
          },
          child: Text(LocalizationService().translate('dialog.button.yes')),
        ),
      ],
    );
  }
}
