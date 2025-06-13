import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

class AppOKModalDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onOk;

  const AppOKModalDialog({
    super.key,
    required this.title,
    required this.content,
    this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Text(content),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            mozPrint('Dialog: OK pressed', 'DIALOG', 'MODAL');
            Navigator.of(context).pop();
            onOk?.call();
          },
          child: Text(LocalizationService().translate('dialog.button.ok')),
        ),
      ],
    );
  }
}
