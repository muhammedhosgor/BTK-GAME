import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownButton extends StatelessWidget {
  CustomDropDownButton({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.width,
    this.border,
    this.color,
    this.height,
    this.iconSize,
    this.fontSize,
    this.borderRadius,
    this.dropdownColor,
  });

  final List<String> items;
  final String selectedItem;
  final double? width;
  final Function(String?) onChanged;
  final BoxBorder? border;
  final Color? color;
  final double? height;
  final double? iconSize;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;
  final Color? dropdownColor;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        alignment: Alignment.center,
        isExpanded: true,
        items: items
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: fontSize ?? 12.sp,
                        fontWeight: FontWeight.w600,
                        color: color ?? Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        value: selectedItem,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          height: height ?? 24.h,
          width: width ?? 110.w,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(24.r),
            border: border ??
                Border.all(
                  color: Colors.grey,
                ),
            color: dropdownColor ?? Colors.white,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: color ?? Colors.black,
          ),
          iconSize: fontSize ?? 18.sp,
          iconEnabledColor: Colors.black,
          iconDisabledColor: Colors.black,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
