import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchField extends StatelessWidget {
  SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  final TextEditingController controller;
  final Function(String value) onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
      controller: controller,
      cursorWidth: 0.8.w,
      cursorHeight: 0.024.sh,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: 'Arama',
        hintStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        suffixIcon: Icon(
          Icons.search,
          color: Colors.grey,
          size: 20.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.2.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.2.w,
          ),
        ),
      ),
    );
  }
}
