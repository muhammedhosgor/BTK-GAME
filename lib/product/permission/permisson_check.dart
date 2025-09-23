import 'package:flutter_base_app/product/permission/i_permisson_check.dart';
import 'package:permission_handler/permission_handler.dart';

class ApplicationPermissionCheck implements IPermissionCheck {
  static final ApplicationPermissionCheck _instance =
      ApplicationPermissionCheck._internal();
  static ApplicationPermissionCheck get instance => _instance;
  ApplicationPermissionCheck._internal();

  @override
  Future<bool> checkPermissionFrom({required Permission source}) async {
    final status = await source.status;

    if (status.isGranted) {
      return true;
    } else {
      final result = await source.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
    // if (status.isGranted) {
    //   return true;
    // } else if (status.isDenied) {
    //   return false;
    // } else if (status.isPermanentlyDenied) {
    //   return false;
    // } else if (status.isRestricted) {
    //   return false;
    // } else if (status.isLimited) {
    //   return false;
    // } else {
    //   return false;
    // }
  }
}
