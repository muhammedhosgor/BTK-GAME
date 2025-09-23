import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageButton extends StatelessWidget {
  ImageButton({
    super.key,
    required this.onTap,
    required this.imagePath,
  });
  void Function()? onTap;
  String imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: 50.w,
        height: 50.h,
      ),
    );
  }
}
