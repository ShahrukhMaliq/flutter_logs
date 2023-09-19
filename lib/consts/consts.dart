import 'package:flutter/cupertino.dart';

class AppConsts {
  /// global navigator key to allow navigation without buildContext
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final moduleId = 1010;
  static final logFileName = "Logs.txt";
  static final logLength = 5;
  static final scannerTimeout = 5;
}
