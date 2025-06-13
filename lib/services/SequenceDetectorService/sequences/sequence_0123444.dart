import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

void executeSequenceMethod_0123444(BuildContext context) {
  final Configuration config = Configuration();
  final Map<String, dynamic> configData = config.getAllConfigData();
  final String formattedConfig =
      const JsonEncoder.withIndent('  ').convert(configData);

  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AppOKModalDialog(
        title: 'Configuration Data',
        content: formattedConfig,
      );
    },
  );
}
