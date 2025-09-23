import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoldNavContainer extends StatelessWidget {
  const GoldNavContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 10.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFD700), // Saf altın sarısı
            Color(0xFFFFA500), // Turuncuya yakın parıltı
            Color(0xFFFFFFAC), // Açık sarı (ışık yansıması gibi)
            Color(0xFFFFD700), // Tekrar altın sarısı
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
