import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/register/cubit/register_cubit.dart';
import 'package:flutter_base_app/feature/auth/register/cubit/register_state.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_base_app/product/injector/injector.dart';
import 'package:flutter_base_app/product/storage/local_get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OTPForgetPasswordView extends StatefulWidget {
  const OTPForgetPasswordView({super.key});

  @override
  State<OTPForgetPasswordView> createState() => _OTPForgetPasswordViewState();
}

class _OTPForgetPasswordViewState extends State<OTPForgetPasswordView> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _remainingSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _focusNodes[0].requestFocus();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Future<void> _submitOTP() async {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      String? email = await injector<LocalStorage>().getString("resetEmail");
      context.read<RegisterCubit>().checkResetPasswordOtp(email ?? '', otp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 60.w,
          height: 60.h,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: kWhiteColor),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: kSuitGold, width: 2.w)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: kSuitGold, width: 2.w)),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                _focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
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
            colors: [Colors.black.withOpacity(0.85), kTableNavy.withOpacity(0.85)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                BackButton(
                  color: kWhiteColor,
                  onPressed: () => context.pushReplacement('/login_view'),
                ),
                SizedBox(height: 20.h),
                Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: kSuitGold,
                    shadows: [
                      Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 6),
                      Shadow(color: kSuitGold.withOpacity(0.7), blurRadius: 10),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Enter the 6-digit code sent to your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 40.h),
                _buildOtpFields(),
                SizedBox(height: 40.h),
                BlocConsumer<RegisterCubit, RegisterState>(
                  listener: (context, state) {
                    if (state.otpState == OtpStates.completed) {
                      context.pushReplacement('/reset_password_view');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "OTP verification success, register is successful",
                              style: TextStyle(color: Colors.white),
                            )),
                      );
                    } else if (state.otpState == OtpStates.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "OTP verification failed",
                              style: TextStyle(color: Colors.white),
                            )),
                      );
                    }
                  },
                  builder: (context, state) {
                    return PrimaryGameButton(
                      buttonColor: kButtonGreen,
                      text: "Verify OTP",
                      icon: Icons.check,
                      onTap: state.otpState == OtpStates.loading ? () {} : _submitOTP,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Text(
                      _canResend ? "" : "Resend OTP in $_remainingSeconds s",
                      style: TextStyle(color: kSuitGold, fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Didn't receive code?",
                      style: TextStyle(color: Colors.grey[300], fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    if (_canResend)
                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          return TextButton(
                            onPressed: () async {
                              int? PlayerId = await injector<LocalStorage>().getInt('registerUserId');
                              String? email = await injector<LocalStorage>().getString('registerEmail');
                              context.read<RegisterCubit>().sendOtp(email ?? '');
                              _startTimer();
                            },
                            child: Text(
                              "Resend",
                              style: TextStyle(color: kSuitGold, fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      '© 2025 YourGameCompany',
                      style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold, fontSize: 12.sp),
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
