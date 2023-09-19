import 'package:json_annotation/json_annotation.dart';

part 'log_resource.g.dart';

@JsonSerializable()
class LogResource {
  int? logId;
  String? component;
  String? description;
  LogResource({this.logId, this.component, this.description});

  factory LogResource.fromJson(Map<String, dynamic> json) =>
      _$LogResourceFromJson(json);
  Map<String, dynamic> toJson() => _$LogResourceToJson(this);
}
