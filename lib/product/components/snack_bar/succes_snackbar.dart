import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/enum/custom_snackbar_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> typeSnackBar(
    {required BuildContext context,
    required message,
    required SnackBarTypes snackBarTypes}) {
  ScaffoldMessenger.of(context)
      .hideCurrentSnackBar(); // bu kod satırı ile önceki snackbar kapatılır.
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      duration: Duration(seconds: 3),
      hitTestBehavior: HitTestBehavior.opaque,
      closeIconColor: Colors.white,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 180,
          left: 5.w,
          right: 5.w),
      content: Column(
        children: [
          Icon(
            snackBarTypes == SnackBarTypes.success
                ? Icons.check_circle
                : snackBarTypes == SnackBarTypes.error
                    ? Icons.error
                    : snackBarTypes == SnackBarTypes.warning
                        ? Icons.warning
                        : snackBarTypes == SnackBarTypes.info
                            ? Icons.info
                            : Icons.error,
            color: Colors.white,
            size: 35.sp,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            message.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      backgroundColor: snackBarTypes == SnackBarTypes.success
          ? Colors.green
          : snackBarTypes == SnackBarTypes.error
              ? Colors.red
              : snackBarTypes == SnackBarTypes.warning
                  ? Colors.orange
                  : snackBarTypes == SnackBarTypes.info
                      ? Colors.blue
                      : Colors.black,
    ),
  );
}
