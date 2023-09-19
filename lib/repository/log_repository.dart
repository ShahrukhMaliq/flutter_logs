import 'dart:convert';
import 'dart:async';

import 'package:flutter_logs/base/api_client.dart';
import 'package:flutter_logs/consts/LogConsts.dart';
import 'package:flutter_logs/enums/log_level.dart';

import 'package:flutter_logs/utils/logs_utils.dart';
import 'package:flutter_logs/models/logs/log.dart';

/// Globally accessible LogRepository.
abstract class LogRepository {
  static final LogRepository _instance = _create();
  factory LogRepository() => _instance;

  static LogRepository _create() {
    /// make a condition to return DemoLogRepository
    return ApiLogRepository();
  }

  Future<bool> postLogs(List<Log> logs);
}

class ApiLogRepository implements LogRepository {
  ApiClient _apiClient = ApiClient();
  @override
  Future<bool> postLogs(List<Log> logs) async {
    try {
      String url = 'api/PlanogramMobileLog/POSTPTGLog';
      var data = json.encode(logs);
      var response = await _apiClient.post(url, data);
      if (response == 200) {
        LogsUtility().logThis(id: LogConsts.logsPosted, level: LogLevel.Debug);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      LogsUtility().logThis(
          id: LogConsts.postLogFailed, level: LogLevel.Error, error: err);
      throw (err);
    }
  }
}

class DemoLogRepository implements LogRepository {
  ApiClient _apiClient = ApiClient();
  @override
  Future<bool> postLogs(List<Log> logs) async {
    try {
      String url = 'api/PlanogramMobileLog/POSTPTGLog';
      var data = json.encode(logs);
      var response = await _apiClient.post(url, data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      return false;
    }
  }
}

Iterable decodeJson(String jsonContent) {
  return json.decode(jsonContent);
}
