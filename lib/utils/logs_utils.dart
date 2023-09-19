import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/consts/consts.dart';
import 'package:flutter_logs/enums/log_level.dart';
import 'package:flutter_logs/enums/logging_mode.dart';
import 'package:flutter_logs/logs_localizations/logs_localizations.dart';
import 'package:flutter_logs/logs_preferences/log_preferences.dart';
import 'package:flutter_logs/models/logs/log.dart';
import 'package:flutter_logs/models/logs/log_resource.dart';
import 'package:flutter_logs/repository/log_repository.dart';
import 'package:flutter_logs/utils/toast_utils.dart';
import 'package:path_provider/path_provider.dart';

abstract class Logger {
  static List<Log> logs = [];
  static LogPreferences logPreferences = new LogPreferences();
  static LogRepository logRepository = new LogRepository();
  static Map<LogLevel, bool> selectedLogLevels = new Map<LogLevel, bool>();
  static LoggingMode? loggingMode;
  static BuildContext? context = AppConsts.navigatorKey.currentContext;
  void logThis(
      {required int id,
      required LogLevel level,
      String exception,
      String error,
      String? elapsedTime,
      String? additionalInfo});
}

class LogsUtility implements Logger {
  var logPreferences = Logger.logPreferences;
  var logRepository = Logger.logRepository;
  var selectedLogLevels = Logger.selectedLogLevels;
  var loggingMode = Logger.loggingMode;
  var logs = Logger.logs;

  BuildContext? context = AppConsts.navigatorKey.currentContext;

  void handleAppStateChange(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      tryLogExport();
    }
  }

  tryLogExport() async {
    LoggingMode loggingMode;
    LogPreferences logPreferences = new LogPreferences();
    loggingMode = await logPreferences.getLoggingMode();
    if (loggingMode == LoggingMode.OnlineMode) {
      exportOnlineLogs();
    }
  }

  void logThis(
      {required int id,
      required LogLevel level,
      dynamic exception,
      dynamic error,
      String? elapsedTime,
      String? additionalInfo}) {
    LogResource? logResource = new LogResource();
    logResource = LogLocalizations.of(context!)!.translateLogById(id);
    LogsUtility().handleLog(
        id: logResource?.logId,
        description: additionalInfo != null
            ? '${logResource?.description} $additionalInfo'
            : logResource?.description,
        component: logResource?.component,
        level: level,
        exception: exception,
        error: error,
        elapsedTime: elapsedTime);
  }

  void handleLog(
      {int? id,
      String? description,
      String? component,
      required LogLevel level,
      dynamic exception,
      dynamic error,
      String? elapsedTime}) async {
    List<Log> result = [];
    loggingMode = await logPreferences.getLoggingMode();
    selectedLogLevels = await logPreferences.getLogLevels();
    result = await createLogs(
        id: id,
        description: description,
        component: component,
        level: level,
        exception: exception,
        error: error,
        elapsedTime: elapsedTime,
        selectedLogLevels: selectedLogLevels);
    if (loggingMode == LoggingMode.LocalMode) {
      if (result.isNotEmpty && level != LogLevel.Error) {
        writeToFile(result);
      } else if (result.isNotEmpty && level == LogLevel.Error) {
        exportLocalLogs(result);
      }
    } else if (loggingMode == LoggingMode.OnlineMode) {
      if (logs.length > AppConsts.logLength) {
        exportOnlineLogs();
      }
    }
  }

  Future<List<Log>> createLogs(
      {int? id,
      String? component,
      String? description,
      LogLevel? level,
      dynamic exception,
      dynamic error,
      String? elapsedTime,
      Map<LogLevel, bool>? selectedLogLevels}) async {
    List<Log> extendedLogs = [];

    if (level == LogLevel.Warning &&
        (selectedLogLevels?[LogLevel.Warning] ?? true)) {
      description = description!.isNotEmpty
          ? description
          : "" + ' ' + exception.toString();
      extendedLogs = await extendLogs(
          id: id, description: description, component: component, level: level);
    }
    if (level == LogLevel.Error &&
        (selectedLogLevels?[LogLevel.Error] ?? true)) {
      description =
          description!.isNotEmpty ? description : "" + ' ' + error.toString();
      extendedLogs = await extendLogs(
          id: id, description: description, component: component, level: level);
    }
    if (level == LogLevel.Debug &&
        (selectedLogLevels?[LogLevel.Debug] ?? true)) {
      extendedLogs = await extendLogs(
          id: id, description: description, component: component, level: level);
    }
    if (level == LogLevel.Info && (selectedLogLevels?[LogLevel.Info] ?? true)) {
      extendedLogs = await extendLogs(
          id: id,
          description: description,
          component: component,
          level: level,
          elapsedTime: elapsedTime);
    }

    return extendedLogs;
  }

  Future<List<Log>> extendLogs(
      {int? id,
      String? description,
      String? component,
      LogLevel? level,
      String? elapsedTime}) async {
    if (loggingMode == LoggingMode.LocalMode) {
      logs.clear();
    }
    Log log = new Log();
    var platform = Platform.isAndroid
        ? "Android"
        : Platform.isIOS
            ? "iOS"
            : "Unidentiifed device";
    var deviceInfo = await getDeviceDetails();
    log = Log(
        logId: id!,
        logLevel: level!.index,
        userName: "User",
        deviceInfo: deviceInfo ?? "",
        platform: platform ?? "",
        component: component!,
        description: description ?? "",
        moduleID: AppConsts.moduleId,
        occurenceTime: DateTime.now(),
        elapsedTime: elapsedTime.toString() +
            ' ' +
            AppLocalizations.of(context!)!.performanceLogsTimeUnit);

    if (loggingMode == LoggingMode.OnlineMode) {
      logs.add(log);
    } else {
      if (level == LogLevel.Error) {
        logs.add(log);
      } else {
        File file = await fileManager();
        bool exist = file.existsSync();
        if (exist) {
          Iterable existingLogs;
          existingLogs = json.decode(file.readAsStringSync());
          logs = List<Log>.from(existingLogs.map((log) => Log.fromJson(log)));
        }
        logs.add(log);
      }
    }
    return logs;
  }

  Future<String?> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var deviceInfo = await deviceInfoPlugin.androidInfo;

        return "Device: " +
            deviceInfo.model +
            '' +
            deviceInfo.manufacturer +
            " Android version: " +
            deviceInfo.version.baseOS.toString();
      } else {
        var deviceInfo = await deviceInfoPlugin.iosInfo;

        return "Device: " +
            deviceInfo.name +
            "iOS version: " +
            deviceInfo.systemVersion.toString();
      }
    } on PlatformException {
      ToastUtils.showToast(
          "Unidentified Device");
      return null;
    }
  }

  Future<File> fileManager() async {
    String fileName = AppConsts.logFileName;
    final Directory? dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    String savePath = '${dir?.path}/$fileName';
    final File file = File(savePath);
    return file;
  }

  void writeToFile(List<Log> listLogs) async {
    if (listLogs.isNotEmpty) {
      File file = await fileManager();
      var text = json.encode(listLogs);
      file.writeAsStringSync(text, mode: FileMode.writeOnly);
    }
  }

  void exportLocalLogs(List<Log> errorLog) async {
    Iterable result;
    File file = await fileManager();
    bool exist = file.existsSync();
    if (errorLog == null && exist) {
      result = json.decode(file.readAsStringSync());
    } else {
      var text = json.encode(errorLog);
      result = json.decode(text);
    }

    if (exist || errorLog != null) {
      logs = List<Log>.from(result.map((log) => Log.fromJson(log)));
      logs.forEach((element) {
        element.deliveryTime = DateTime.now();
      });
      var isPosted = await logRepository.postLogs(logs);
      if (isPosted) {
        logs.clear();
      } else {
        clearFile();
        logs.clear();
      }
    }
  }

  void exportOnlineLogs() async {
    logs.forEach((element) {
      element.deliveryTime = DateTime.now();
    });
    var isPosted = await logRepository.postLogs(logs);
    if (isPosted) {
      logs.clear();
    }
  }

  void clearFile() async {
    File file = await fileManager();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
