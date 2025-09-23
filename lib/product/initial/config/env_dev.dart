import 'package:envied/envied.dart';
import 'package:flutter_base_app/product/initial/config/app_configuration.dart';

part 'env_dev.g.dart';

@Envied(
  obfuscate: true,
  path: 'assets/env/.dev.env',
)
class DevEnv implements AppConfiguration {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = _DevEnv._baseUrl;

  @EnviedField(varName: 'API_KEY')
  static final String _apiKey = _DevEnv._apiKey;

  @override
  // TODO: implement apiKey
  String get apiKey => _apiKey;

  @override
  // TODO: implement baseUrl
  String get baseUrl => _baseUrl;
}
