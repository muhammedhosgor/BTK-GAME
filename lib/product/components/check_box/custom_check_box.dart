import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final Function(bool? value) onChanged;
  final bool? value;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 12.r,
      backgroundColor: Colors.blue,
      child: CircleAvatar(
        radius: 10.r,
        backgroundColor: Colors.white,
        child: Checkbox(
          fillColor: const WidgetStatePropertyAll(Colors.blue),
          value: value,
          side: BorderSide.none,
          shape: const CircleBorder(side: BorderSide(color: Colors.blue)),
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ),
    );
  }
}
