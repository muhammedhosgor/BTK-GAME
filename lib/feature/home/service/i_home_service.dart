import 'package:flutter_base_app/core/network/network_manager/network_manager.dart';

abstract class IHomeService {
  IHomeService(this.dio);
  final NetworkManager dio;
}
