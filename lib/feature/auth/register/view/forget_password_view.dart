import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_app/feature/auth/register/cubit/register_cubit.dart';
import 'package:flutter_base_app/feature/auth/register/cubit/register_state.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetCode() async {
    String email = _emailController.text;
    injector<LocalStorage>().saveString("resetEmail", email);

    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Please enter a valid email address",
              style: TextStyle(color: Colors.white),
            )),
      );
      return;
    }

    // Dummy PlayerId or local saved
    int? playerId =
        await injector<LocalStorage>().getInt('registerUserId') ?? -1;

    context.read<RegisterCubit>().sendOtp(email);

    // Save email to storage
    // injector<LocalStorage>().setString("registerEmail", email);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Reset code sent to your email",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    context.push("/otp_forget_password_view");
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                BackButton(
                  color: Colors.white,
                  onPressed: () => context.pushReplacement('/login_view'),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: kSuitGold,
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(0.8), blurRadius: 6),
                      Shadow(color: kSuitGold.withOpacity(0.7), blurRadius: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Enter your email to reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 40.h),

                // Email Input
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: kSuitGold, width: 2),
                  ),
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // Send Button (BlocBuilder for loading state)
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return PrimaryGameButton(
                      buttonColor: kButtonGreen,
                      text: state.otpState == OtpStates.loading
                          ? "Sending..."
                          : "Send Reset Code",
                      icon: Icons.email_outlined,
                      onTap: state.otpState == OtpStates.loading
                          ? () {}
                          : _sendResetCode,
                    );
                  },
                ),

                const Spacer(),

                // Footer
                Column(
                  children: [
                    Text(
                      'Version 1.0.1',
                      style:
                          TextStyle(color: Colors.grey[300], fontSize: 12.sp),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      '© 2025 Valor of Cards',
                      style:
                          TextStyle(color: Colors.grey[300], fontSize: 12.sp),
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
