import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_logs/enums/log_level.dart';
import 'package:flutter_logs/enums/logging_mode.dart';
import 'package:flutter_logs/logs_preferences/log_preferences.dart';

part 'log_setting_event.dart';
part 'log_setting_state.dart';

class LogSettingBloc extends Bloc<LogSettingEvent, LogSettingState> {
  LogPreferences logPreferences = new LogPreferences();
  LogSettingBloc() : super(LogSettingState()) {
    add(LoggingLevelInitEvent());
    add(LoggingModeInitEvent());
  }

  Stream<LogSettingState> mapEventToState(LogSettingEvent event) async* {
    if (event is LoggingModeInitEvent) {
      final loggingMode = await logPreferences.getLoggingMode();
      add(LoggingModeChangedEvent(loggingMode));
    }

    if (event is LoggingLevelInitEvent) {
      final logLevel = await logPreferences.getLogLevels();
      add(LoggingLevelChangedEvent(logLevel));
    }

    if (event is LoggingModeChangedEvent) {
      yield* _mapLoggingModeChangedEvent(event, state);
    } else if (event is LoggingLevelChangedEvent) {
      yield* _mapLoggingLevelChangedEvent(event, state);
    }
  }

  Stream<LogSettingState> _mapLoggingModeChangedEvent(
      LoggingModeChangedEvent event, LogSettingState state) async* {
    yield state.copyWith(
        loggingMode: event.loggingMode, loggingLevel: state.loggingLevel!);
    logPreferences.setLoggingMode(event.loggingMode);
  }

  Stream<LogSettingState> _mapLoggingLevelChangedEvent(
      LoggingLevelChangedEvent event, LogSettingState state) async* {
    yield state.copyWith(
        loggingMode: state.loggingMode, loggingLevel: event.loggingLevel);
    logPreferences.setLogLevels(event.loggingLevel);
  }
}
