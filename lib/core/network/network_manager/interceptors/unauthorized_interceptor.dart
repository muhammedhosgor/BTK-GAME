import 'package:dio/dio.dart';
import 'package:flutter_base_app/core/network/network_manager/api_errors/unauthorized_api_error.dart';

class UnauthorizedInterceptor extends Interceptor {
  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      super.onError(err, handler);
      return UnauthorizedApiError(dioError: err);
    }

    super.onError(err, handler);
  }
}
