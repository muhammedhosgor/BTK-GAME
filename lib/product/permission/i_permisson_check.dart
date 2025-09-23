import 'package:permission_handler/permission_handler.dart';

abstract class IPermissionCheck {
  Future<bool> checkPermissionFrom({required Permission source});
}
