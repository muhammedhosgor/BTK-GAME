import 'package:dio/dio.dart';
import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = injector.get<LocalStorage>().getString("token");

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final token = await injector.get<LocalStorage>().getString("token");

      if (token != null) {
        injector.get<LocalStorage>().saveString("token", token);
        final request = err.requestOptions;
        request.headers['Authorization'] = 'Bearer $token';
        final dio = NetworkManager.instance.dio;
        await dio.fetch(request).then((value) {
          handler.resolve(value);
        }).catchError((e) {
          handler.reject(e);
        });
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
