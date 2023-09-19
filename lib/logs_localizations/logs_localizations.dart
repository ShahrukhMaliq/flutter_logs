import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/models/logs/log_resource.dart';

class LogLocalizations {
  final Locale appLocale;

  LogLocalizations(this.appLocale);

  static LogLocalizations? of(BuildContext context) {
    return Localizations.of<LogLocalizations>(context, LogLocalizations);
  }

  static const LocalizationsDelegate<LogLocalizations> delegate =
      _LogLocalizationsDelegate();

  List<LogResource> _allLogs = [];
  Future<bool> loadLogResourceFiles() async {
    String value = await rootBundle
        .loadString('assets/logs/log_${appLocale.languageCode}.json');

    List<dynamic> jsonMap = jsonDecode(value);
    jsonMap.forEach((element) {
      element.forEach((key, value) {
        value.forEach((item) {
          _allLogs.add(LogResource.fromJson(item));
        });
      });
    });

    return true;
  }

  LogResource? translateLogById(int id) {
    LogResource? foundLog;

    _allLogs.forEach((element) {
      if (element.logId == id) {
        foundLog = element;
      }
    });
    return foundLog;
  }
}

class _LogLocalizationsDelegate
    extends LocalizationsDelegate<LogLocalizations> {
  const _LogLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    var supportedLocale = [];
    //Add your supported locale logic here
    return supportedLocale.contains(locale.languageCode);
  }

  @override
  Future<LogLocalizations> load(Locale locale) async {
    LogLocalizations localizations = new LogLocalizations(locale);
    await localizations.loadLogResourceFiles();
    return localizations;
  }

  @override
  bool shouldReload(_LogLocalizationsDelegate old) => false;
}
