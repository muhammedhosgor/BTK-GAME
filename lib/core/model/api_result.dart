import 'package:json_annotation/json_annotation.dart';

part 'api_result.g.dart';

@JsonSerializable()
class ApiResult {
  ApiResult({
    this.data,
    this.success,
    this.message,
    this.errorMessage,
  });
  @JsonKey(name: 'data')
  final dynamic data;
  @JsonKey(name: 'success')
  final bool? success;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'errorMessage')
  final String? errorMessage;

  factory ApiResult.fromJson(Map<String, dynamic> json) =>
      _$ApiResultFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResultToJson(this);
}
