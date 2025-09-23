import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {Key? key,
      this.onPressed,
      required this.text,
      this.isLoading,
      this.buttonColor,
      this.textColor = Colors.white,
      this.icon,
      this.isIcon,
      this.fontWeigth = FontWeight.bold,
      this.iconColor = Colors.white,
      this.isPassive = false})
      : super(key: key);
  final VoidCallback? onPressed;
  final String text;
  final bool? isLoading;
  Color? buttonColor = const Color(0xff765299);
  final Color textColor;
  final FontWeight fontWeigth;
  bool? isIcon = false;
  final IconData? icon;
  final Color iconColor;
  final isPassive;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.h,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11.sp),
        child: onPressed == null ? _buildText() : _buildGradientColor(context),
      ),
    );
  }

  Ink _buildGradientColor(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          gradient: (isPassive == false)
              ? LinearGradient(colors: [buttonColor ?? const Color(0xff765299), buttonColor ?? const Color(0xff765299)])
              : const LinearGradient(colors: [Color.fromARGB(200, 196, 192, 192), Color.fromARGB(200, 196, 192, 192)]),
          borderRadius: BorderRadius.circular(11.sp)),
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
