import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryGameButton extends StatelessWidget {
  PrimaryGameButton({
    super.key,
    required this.buttonColor,
    required this.text,
    this.icon,
    this.onTap,
  });

  final Color buttonColor;
  final String text;
  final IconData? icon;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      onTap: onTap,
      child: Container(
        width: 0.8.sw,
        height: 60.h, // biraz daha büyük
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              buttonColor.withOpacity(0.9),
              buttonColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: kWhiteColor.withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.videogame_asset,
              color: kWhiteColor,
              size: 28.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: kWhiteColor,
                fontSize: 20.sp, // yazılar büyütüldü
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
