import 'package:json_annotation/json_annotation.dart';

part 'log.g.dart';

@JsonSerializable()
class Log {
  Log(
      {this.logId,
      this.logLevel,
      this.moduleID,
      this.userName,
      this.deviceInfo,
      this.platform,
      this.component,
      this.description,
      this.deliveryTime,
      this.occurenceTime,
      this.elapsedTime});

  int? logLevel;

  int? logId;

  int? moduleID;

  String? userName;

  String? component;

  String? description;

  String? deviceInfo;

  String? platform;

  DateTime? deliveryTime;

  DateTime? occurenceTime;
  String? elapsedTime;

  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);
  Map<String, dynamic> toJson() => _$LogToJson(this);
}
