import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get morePage_logSettings => 'Log-Einstellungen';

  @override
  String get morePage_loggingMode => 'Logging-Modus';

  @override
  String get morePage_logLevels => 'Log Levels';

  @override
  String get morePage_exportLogs => 'Logs exportieren';

  @override
  String get logSettingsSelectLoggingMode => 'Logging Modus Auswählen';

  @override
  String get logSettingsSelectLogLevels => 'Log Levels Auswählen';

  @override
  String get logSettingsLevel => 'Level';

  @override
  String get logSettingsDefaultLevel => 'Default Level';

  @override
  String get logSettingsFileMode => 'Datei Mode';

  @override
  String get logSettingsOnlineMode => 'Online Mode';

  @override
  String get performanceLogsTimeUnit => 'ms';
}
