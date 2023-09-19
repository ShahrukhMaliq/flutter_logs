// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Log _$LogFromJson(Map<String, dynamic> json) => Log(
      logId: json['logId'] as int?,
      logLevel: json['logLevel'] as int?,
      moduleID: json['moduleID'] as int?,
      userName: json['userName'] as String?,
      deviceInfo: json['deviceInfo'] as String?,
      platform: json['platform'] as String?,
      component: json['component'] as String?,
      description: json['description'] as String?,
      deliveryTime: json['deliveryTime'] == null
          ? null
          : DateTime.parse(json['deliveryTime'] as String),
      occurenceTime: json['occurenceTime'] == null
          ? null
          : DateTime.parse(json['occurenceTime'] as String),
      elapsedTime: json['elapsedTime'] as String?,
    );

Map<String, dynamic> _$LogToJson(Log instance) => <String, dynamic>{
      'logLevel': instance.logLevel,
      'logId': instance.logId,
      'moduleID': instance.moduleID,
      'userName': instance.userName,
      'component': instance.component,
      'description': instance.description,
      'deviceInfo': instance.deviceInfo,
      'platform': instance.platform,
      'deliveryTime': instance.deliveryTime?.toIso8601String(),
      'occurenceTime': instance.occurenceTime?.toIso8601String(),
      'elapsedTime': instance.elapsedTime,
    };
