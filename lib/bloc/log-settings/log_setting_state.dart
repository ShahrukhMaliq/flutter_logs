part of 'log_setting_bloc.dart';

class LogSettingState extends Equatable {
  const LogSettingState({this.loggingMode, this.loggingLevel});

  final LoggingMode? loggingMode;
  final Map<LogLevel, bool>? loggingLevel;

  LogSettingState copyWith({
    required loggingMode,
    required Map<LogLevel, bool> loggingLevel,
  }) {
    return LogSettingState(
      loggingMode: loggingMode ?? this.loggingMode,
      loggingLevel: loggingLevel ?? this.loggingLevel,
    );
  }

  @override
  List<Object?> get props => [this.loggingMode, this.loggingLevel];
}
