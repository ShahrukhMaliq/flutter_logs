// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogResource _$LogResourceFromJson(Map<String, dynamic> json) => LogResource(
      logId: json['logId'] as int?,
      component: json['component'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$LogResourceToJson(LogResource instance) =>
    <String, dynamic>{
      'logId': instance.logId,
      'component': instance.component,
      'description': instance.description,
    };
