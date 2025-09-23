import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/functions/optimus_prime/optimus_prime.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertPage extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? subTitleSecond;

  final bool isTwoButtonAlert;
  final Function()? onYesPressed;
  final Function()? onNoPressed;
  final Function()? onOkPressed;
  final Function()? onBackButtonPressed;

  final Widget contentWidget;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? surfaceTintColor;
  final Color? iconColor;

  const AlertPage({
    Key? key,
    required this.title,
    this.subTitle,
    this.subTitleSecond,
    required this.isTwoButtonAlert,
    this.onNoPressed,
    this.onYesPressed,
    this.onOkPressed,
    required this.contentWidget,
    required this.onBackButtonPressed,
    this.backgroundColor,
    this.textColor,
    this.surfaceTintColor,
    this.iconColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:
          EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.01.sh),
      backgroundColor: backgroundColor ?? Colors.white,
      surfaceTintColor: surfaceTintColor ?? Colors.white,
      insetPadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      content: Container(
        width: 1.sw,
        constraints: BoxConstraints(
          minHeight: 1.sh,
          maxHeight: double.infinity,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.01.sh,
            ),
            Container(
              width: 1.sw,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 31, 36, 46),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  width: 0.2.w,
                  color: Colors.white54,
                ),
              ),
              padding:
                  EdgeInsets.symmetric(vertical: 0.01.sh, horizontal: 0.03.sw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onBackButtonPressed,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20.sp,
                      color: iconColor ?? Colors.white,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveFontSize.optimusPrime(16),
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 0.08.sw,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: subTitle != null || subTitleSecond != null ? 0.02.sh : 0,
            ),
            subTitle != null || subTitleSecond != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            width: 0.2.w,
                            color: Colors.black,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.04.sw, vertical: 0.004.sh),
                        child: Text(
                          subTitle!,
                          style: TextStyle(
                            fontSize: ResponsiveFontSize.optimusPrime(11),
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            width: 0.2.w,
                            color: Colors.black,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.04.sw, vertical: 0.004.sh),
                        child: Text(
                          subTitleSecond!,
                          style: TextStyle(
                            fontSize: ResponsiveFontSize.optimusPrime(11),
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            SizedBox(
              height: 0.02.sh,
            ),
            Container(
              color: Colors.white,
              width: 1.sw,
              height: 0.2.h,
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            contentWidget,
            SizedBox(
              height: 0.04.sh,
            ),
            isTwoButtonAlert == true
                ? Row(
                    children: [
                      SizedBox(
                        height: 32,
                        width: 0.24,
                        child: ElevatedButton(
                          onPressed: onNoPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            "NO",
                            style: TextStyle(
                                fontSize: ResponsiveFontSize.optimusPrime(12),
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 32,
                        width: 0.24,
                        child: ElevatedButton(
                          onPressed: onYesPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            "YES",
                            style: TextStyle(
                              fontSize: ResponsiveFontSize.optimusPrime(12),
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0.04.sh,
                    child: ElevatedButton(
                      onPressed: onOkPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0.08.sw),
                      ),
                      child: Text(
                        "CLOSE",
                        style: TextStyle(
                          fontSize: ResponsiveFontSize.optimusPrime(12),
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 0.04.sh,
            )
          ],
        ),
      ),
    );
  }
}
