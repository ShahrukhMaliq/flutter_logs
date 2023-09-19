import 'dart:convert';
import 'package:flutter_logs/enums/log_level.dart';
import 'package:flutter_logs/enums/logging_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogPreferences {
  static const String LOGGING_MODE = 'LoggingMode';
  static const String LOGGING_LEVEL = 'LoggingLevel';

  void setLoggingMode(LoggingMode value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(LOGGING_MODE, value.index.toString());
  }

  Future<LoggingMode> getLoggingMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoggingMode _loggingMode = LoggingMode.LocalMode;

    String? result = pref.getString(LOGGING_MODE);
    if (result!.isNotEmpty) {
      var index = int.parse(result);
      _loggingMode = LoggingMode.values[index];
    }

    return _loggingMode;
  }

  void setLogLevels(Map<LogLevel, bool> selectedLogLevels) async {
    var serializableMap = Map<String, bool>();
    selectedLogLevels.forEach((key, value) {
      serializableMap[key.index.toString()] = value;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var result = json.encode(serializableMap);

    pref.setString(LOGGING_LEVEL, result);
  }

  Future<Map<LogLevel, bool>> getLogLevels() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<LogLevel, bool> selectedLogLevels = {
      LogLevel.Error: true,
      LogLevel.Warning: false,
      LogLevel.Info: false,
      LogLevel.Debug: false
    };

    var serializedMap = pref.getString(LOGGING_LEVEL);
    if (serializedMap != null) {
      var deserializedMap =
          Map<String, bool>.from(jsonDecode(pref.getString(LOGGING_LEVEL)!));
      deserializedMap.forEach((key, value) {
        var index = int.parse(key);
        var logLevel = LogLevel.values[index];

        selectedLogLevels[logLevel] = value;
      });
    }

    return selectedLogLevels;
  }
}
