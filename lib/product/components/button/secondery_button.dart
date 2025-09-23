import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryButton extends StatelessWidget {
  SecondaryButton(
      {Key? key,
      this.onPressed,
      required this.text,
      this.isLoading,
      this.buttonColor = const Color(0xffF18A00),
      this.textColor = Colors.white,
      this.icon,
      this.isIcon,
      this.fontWeigth = FontWeight.bold,
      this.iconColor = Colors.white})
      : super(key: key);
  final VoidCallback? onPressed;
  final String text;
  final bool? isLoading;
  final Color buttonColor;
  final Color textColor;
  final FontWeight fontWeigth;
  bool? isIcon = false;
  final IconData? icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400.w,
      height: 50.h,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.sp),
        child: onPressed == null ? _buildText() : _buildGradientColor(context),
      ),
    );
  }

  Ink _buildGradientColor(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [buttonColor, buttonColor]),
          borderRadius: BorderRadius.circular(16.sp)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 300.w,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              (isIcon == true)
                  ? Center(
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 28.sp,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                width: 10.w,
              ),
              (isLoading ?? false) ? _buildCircularProgress() : _buildText(),
            ]),
          ),
        ],
      ),
    );
  }

  Transform _buildCircularProgress() {
    return Transform.scale(
      scale: 1.r,
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }

  Text _buildText() {
    return Text(
      text,
      style: TextStyle(color: textColor, fontWeight: fontWeigth),
    );
  }
}
