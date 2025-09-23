import 'package:flutter_base_app/core/model/api_result.dart';
import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';

abstract class ILoginService {
  ILoginService(this.dio);
  NetworkManager dio;
  Future<ApiResult?> userLogin(String emailOrPhone, String password);
}
