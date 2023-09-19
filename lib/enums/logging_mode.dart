import 'package:json_annotation/json_annotation.dart';

enum LoggingMode {
  @JsonValue("onlineMode")
  OnlineMode,

  @JsonValue("localMode")
  LocalMode
}
