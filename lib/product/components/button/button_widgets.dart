import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidgets extends StatelessWidget {
  final String butonText;
  final Color butonColor;
  final Color textColor;
  final double radius;
  final double height;
  final double width;
  final double fontSize;
  final Widget butonIcon;
  final VoidCallback onPressed;

  const ButtonWidgets(
      {Key? key,
      required this.butonText,
      this.butonColor = Colors.purple,
      this.textColor = Colors.white,
      this.radius = 16,
      this.height = 60,
      this.width = 350,
      this.fontSize = 18,
      required this.butonIcon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: butonColor != null
                  ? WidgetStateProperty.all<Color>(butonColor)
                  : null,
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.white)))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Spreads, Collection-if, Collection-for
              if (butonIcon != null) ...[
                butonIcon,
                Text(
                  butonText,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize.sp),
                ),
                if (butonIcon != null) Opacity(opacity: 0, child: butonIcon)
              ],
              if (butonIcon == null) ...[
                butonIcon,
                Container(),
                Text(
                  butonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
                Container()
              ],
            ],
          ),
        ),
      ),
    );
  }
}
