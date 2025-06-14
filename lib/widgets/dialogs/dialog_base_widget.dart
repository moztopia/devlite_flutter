import 'package:flutter/material.dart';

class DialogBaseWidget extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const DialogBaseWidget({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}
