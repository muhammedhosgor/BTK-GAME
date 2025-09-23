// import 'package:flutter/material.dart';

// class AppTextFormField extends StatelessWidget {
//   final String? Function(String?) validator;
//   final TextEditingController controller;
//   final String? labelText;
//   final Color? labelColor;
//   final Color? textColor;
//   final Color? errorColor;
//   final Color? focusedErrorColor;
//   final Color? enabledColor;
//   final Color? focusedColor;
//   final Widget? suffixIcon;
//   final bool obscureText;
//   final String obscuringCharacter;
//   final String? hintText;
//   final TextInputType? keyboardType;
//   final double? height;
//   final double? width;
//   final int? maxLength;
//   final Widget? prefixIcon;
//   final int? maxLines;
//   final int? minLines;

//   const AppTextFormField({
//     super.key,
//     required this.validator,
//     required this.controller,
//     this.labelText,
//     this.labelColor,
//     this.textColor,
//     this.errorColor,
//     this.focusedErrorColor,
//     this.enabledColor,
//     this.focusedColor,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.obscuringCharacter = '*',
//     this.hintText,
//     this.keyboardType,
//     this.height,
//     this.width,
//     this.maxLength,
//     this.prefixIcon,
//     this.maxLines,
//     this.minLines,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height ?? 0.07.sh,
//       width: width ?? 1.sw,
//       child: TextFormField(
//         maxLength: maxLength,
//         maxLines: maxLines,
//         minLines: minLines,
//         validator: validator,
//         controller: controller,
//         keyboardType: keyboardType,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             fontSize: 16 ,
//             fontWeight: FontWeight.bold,
//             fontStyle: FontStyle.italic,
//             color: textColor),
//         decoration: InputDecoration(
//             prefixIcon: prefixIcon,
//             fillColor: const Color.fromARGB(255, 224, 223, 223),
//             filled: true,
//             suffixIcon: suffixIcon,
//             contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 0.04.sw, vertical: 0.02.sh),
//             errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//                 borderSide: BorderSide(color: errorColor ?? darkGreyColor, width: 0)),
//             focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//                 borderSide: BorderSide(color: focusedErrorColor ?? darkGreyColor, width: 0)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//                 borderSide: BorderSide(color: enabledColor ?? darkGreyColor, width: 0)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//                 borderSide: BorderSide(color: focusedColor ?? darkGreyColor, width: 0)),
//             labelText: labelText,
//             hintText: hintText,
//             hintStyle:
//                 TextStyle(color: lightBlackColor, fontSize: 8 * context.optimusPrime(), fontWeight: FontWeight.w300),
//             labelStyle: TextStyle(
//               color: labelColor,
//               fontSize: 10 * context.optimusPrime(),
//             ),
//             errorStyle: TextStyle(color: redColor, fontSize: 8 * context.optimusPrime(), fontWeight: FontWeight.bold)),
//         obscureText: obscureText,
//         obscuringCharacter: obscuringCharacter,
//       ),
//     );
//   }
// }
