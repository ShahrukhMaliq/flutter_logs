import 'dart:async';
import 'dart:convert';
import 'package:flutter_logs/consts/LogConsts.dart';
import 'package:flutter_logs/enums/log_level.dart';
import 'package:flutter_logs/utils/logs_utils.dart';

class ApiClient {
  static const int TIMEOUT_SECONDS = 150;
  static final String baseUrl = "";

  get oauth2Client => null;

  Future<dynamic> getJson(String url) async {
    try {
      url = combineUrls(baseUrl, url);
      final response = await oauth2Client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: TIMEOUT_SECONDS));

      if (response.statusCode == 204) {
        return null;
      }

      final responseJson = json.decode(response.body);

      return responseJson;
    } catch (err) {
      LogsUtility().logThis(
          id: LogConsts.getJsonApiClientFailed,
          level: LogLevel.Error,
          error: err);
      throw err;
    }
  }

  Future<dynamic> post(String url, String data) async {
    try {
      url = combineUrls(baseUrl, url);
      final response = await oauth2Client.post(Uri.parse(url),
          body: data,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          }).timeout(const Duration(seconds: TIMEOUT_SECONDS));

      LogsUtility()
          .logThis(id: LogConsts.httpPostMethod, level: LogLevel.Debug);

      return response.statusCode;
    } catch (err) {
      LogsUtility().logThis(
          id: LogConsts.httpPostApiClientFailed,
          level: LogLevel.Error,
          error: err);
      throw err;
    }
  }

  Future<String?>? getBase64(String url) async {
    try {
      url = getFullUrl(url);
      final response = await oauth2Client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: TIMEOUT_SECONDS));

      if (response.statusCode != 200) {
        return null;
      }

      var base64String = base64.encode(response.bodyBytes);
      return base64String;
    } catch (err) {
      LogsUtility().logThis(
          id: LogConsts.getBase64ImageFailed,
          level: LogLevel.Error,
          error: err);
      throw err;
    }
  }

  static String getFullUrl(String path) {
    return combineUrls(baseUrl, path);
  }

  static String combineUrls(String baseUrl, String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    if (!baseUrl.endsWith('/')) {
      baseUrl = baseUrl + '/';
    }

    if (path.startsWith('/')) {
      path = path.substring(1);
    }

    var result = baseUrl + path;
    return result;
  }

  Map<String, String> getAuthenticationHeaders() {
    final Map<String, String> map = {};

    if (oauth2Client?.credentials?.accessToken != null) {
      map["Authorization"] = "Bearer " + oauth2Client.credentials.accessToken;
    }

    return map;
  }
}
