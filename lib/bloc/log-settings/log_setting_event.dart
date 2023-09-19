part of 'log_setting_bloc.dart';

abstract class LogSettingEvent extends Equatable {
  const LogSettingEvent();

  @override
  List<Object> get props => [];
}

class LoggingModeInitEvent extends LogSettingEvent {
  const LoggingModeInitEvent();

  @override
  List<Object> get props => [];
}

class LoggingModeChangedEvent extends LogSettingEvent {
  const LoggingModeChangedEvent(this.loggingMode);

  final LoggingMode loggingMode;

  @override
  List<Object> get props => [this.loggingMode];
}

class LoggingLevelChangedEvent extends LogSettingEvent {
  const LoggingLevelChangedEvent(this.loggingLevel);

  final Map<LogLevel, bool> loggingLevel;

  @override
  List<Object> get props => [this.loggingLevel];
}

class LoggingLevelInitEvent extends LogSettingEvent {
  const LoggingLevelInitEvent();

  @override
  List<Object> get props => [];
}
