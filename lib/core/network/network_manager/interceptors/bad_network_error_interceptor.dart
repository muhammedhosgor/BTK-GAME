import 'package:dio/dio.dart';
import 'package:flutter_base_app/core/network/network_information/network_connect_info.dart';
import 'package:flutter_base_app/core/network/network_manager/api_errors/bad_network_api_error.dart';

class BadNetworkErrorInterceptor extends Interceptor {
  final NetworkConnectInformation _networkConnectInfo =
      NetworkConnectInformation.instance;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response == null &&
        !await _networkConnectInfo.isConnectedWithNetwork()) {
      return BadNetworkApiError(dioError: err);
    }
    super.onError(err, handler);
  }
}
