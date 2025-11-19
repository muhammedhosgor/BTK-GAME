import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_app/feature/auth/register/cubit/register_cubit.dart';
import 'package:flutter_base_app/feature/auth/register/cubit/register_state.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({
    super.key,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Password must be at least 6 characters",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Passwords do not match",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }
    String? email = await injector<LocalStorage>().getString("resetEmail");

    bool response = await context.read<RegisterCubit>().resetPassword(email ?? '', newPassword); //!
    if (response == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Password reset successfully , please login",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      injector<LocalStorage>().remove("resetEmail");
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      context.read<RegisterCubit>().resetLogin(); //!

      context.pushReplacement("/login_view");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Password reset failed",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/asset/bg.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.85),
              kTableNavy.withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                BackButton(
                  color: Colors.white,
                  onPressed: () => context.pop(),
                ),
                SizedBox(height: 20.h),

                /// Title
                Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: kSuitGold,
                    shadows: [
                      Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 6),
                      Shadow(color: kSuitGold.withOpacity(0.6), blurRadius: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Create your new password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 40.h),

                /// New Password Field
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: kSuitGold, width: 2),
                  ),
                  child: TextField(
                    controller: _newPasswordController,
                    obscureText: _hideNewPassword,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "New Password",
                      labelStyle: TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideNewPassword ? Icons.visibility_off : Icons.visibility,
                          color: kSuitGold,
                        ),
                        onPressed: () {
                          setState(() => _hideNewPassword = !_hideNewPassword);
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                /// Confirm Password Field
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: kSuitGold, width: 2),
                  ),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: _hideConfirmPassword,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: kSuitGold,
                        ),
                        onPressed: () {
                          setState(() => _hideConfirmPassword = !_hideConfirmPassword);
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                /// Button
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return PrimaryGameButton(
                      buttonColor: kButtonGreen,
                      text: "Reset Password",
                      icon: Icons.lock_open,
                      onTap: _resetPassword,
                    );
                  },
                ),

                const Spacer(),

                /// Footer
                Column(
                  children: [
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.grey[300], fontSize: 12.sp),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      '© 2025 YourGameCompany',
                      style: TextStyle(color: Colors.grey[300], fontSize: 12.sp),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
