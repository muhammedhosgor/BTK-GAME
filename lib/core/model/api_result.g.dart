// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResult _$ApiResultFromJson(Map<String, dynamic> json) => ApiResult(
      data: json['data'],
      success: json['success'] as bool?,
      message: json['message'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ApiResultToJson(ApiResult instance) => <String, dynamic>{
      'data': instance.data,
      'success': instance.success,
      'message': instance.message,
      'errorMessage': instance.errorMessage,
    };
