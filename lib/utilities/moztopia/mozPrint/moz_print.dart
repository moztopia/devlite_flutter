import 'package:flutter/foundation.dart';

void mozPrint(String passedMessage,
    [String passedCategory = 'UNKNOWN',
    String passedFocus = '',
    String passedLevel = 'INFO']) {
  const String red = '\x1B[31m';
  const String green = '\x1B[32m';
  const String yellow = '\x1B[33m';
  const String blue = '\x1B[34m';
  const String reset = '\x1B[0m';
  // const String purple = '\x1B[35m';
  // const String cyan = '\x1B[36m';
  // const String white = '\x1B[37m';
  // const String black = '\x1B[30m';
  String section = '${red}MOZ$reset';
  String category = '$yellow$passedCategory$reset';
  String level = '$green$passedLevel$reset';
  String focus = passedFocus.isEmpty ? '' : '[$blue$passedFocus$reset]:';
  String message = passedMessage;
  debugPrint('$section/$category:[$level]:$focus $message');
}
