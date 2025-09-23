import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryGameButton extends StatelessWidget {
  PrimaryGameButton({
    super.key,
    required this.buttonColor,
    required this.text,
    this.icon,
  });

  Color buttonColor;
  String text;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 0.8.sw,
        height: 50.h,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: kSuitGold, width: 2),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20.w),
              Icon(icon ?? Icons.videogame_asset, color: kWhiteColor, size: 24.sp),
              const Spacer(),
              Text(
                text,
                style: TextStyle(color: kWhiteColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
