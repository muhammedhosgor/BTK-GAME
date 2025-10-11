// MARK: - THEMED DIALOG
import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_cubit.dart';
import 'package:flutter_base_app/feature/auth/login/cubit/login_state.dart';
import 'package:flutter_base_app/product/components/button/primary_button.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Temaya uygun giriş (login) iletişim kutusu.
class ThemedLoginDialog extends StatelessWidget {
  const ThemedLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Dialog boyutunu ekranın yaklaşık %80'i olarak ayarla.
    final double dialogWidth = MediaQuery.of(context).size.width * 0.8;

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: dialogWidth,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: kTableNavy, // Koyu lacivert arka plan
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kSuitGold, width: 3), // Altın çerçeve
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            // Hafif bir arkaplan deseni ekleyebiliriz
            image: const DecorationImage(
              image: AssetImage('assets/asset/bg.jpg'),
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık
              Text(
                "PLAYER LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSuitGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: kBlackColor.withOpacity(0.8), blurRadius: 5, offset: const Offset(1, 2)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const GoldNavContainer(),
              const SizedBox(height: 20),

              // Kullanıcı Adı Girişi
              Container(
                decoration: BoxDecoration(
                  color: kBlackColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kSuitGold.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: kBlackColor.withOpacity(0.7),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: context.read<LoginCubit>().emailController,
                  obscureText: false,
                  style: const TextStyle(color: kWhiteColor, fontSize: 16),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: kSuitGold.withOpacity(0.8)),
                    hintText: "Email",
                    hintStyle: TextStyle(color: kWhiteColor.withOpacity(0.6)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    border: InputBorder.none, // Çerçeveyi kaldırdık, Container'ın border'ını kullanıyoruz
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Şifre Girişi
              Container(
                decoration: BoxDecoration(
                  color: kBlackColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kSuitGold.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: kBlackColor.withOpacity(0.7),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: context.read<LoginCubit>().passwordController,
                  obscureText: true,
                  style: const TextStyle(color: kWhiteColor, fontSize: 16),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: kSuitGold.withOpacity(0.8)),
                    hintText: "Password",
                    hintStyle: TextStyle(color: kWhiteColor.withOpacity(0.6)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    border: InputBorder.none, // Çerçeveyi kaldırdık, Container'ın border'ını kullanıyoruz
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Giriş Butonu (Temaya uygun)
              BlocListener<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.loginState == LoginStates.loading) {
                    // Yükleniyor durumu için bir gösterge ekleyebilirsiniz
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kSuitGold),
                        ),
                      ),
                    );
                  } else if (state.loginState == LoginStates.completed) {
                    context.pop(); // Yükleniyor göstergesini kapat
                    context.pop(); // Giriş dialogunu kapat
                    // context.push('/home_view');
                    context.read<LoginCubit>().changeLoginStatus(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message ?? 'Login Successful!'),
                        backgroundColor: kAccentGreen,
                      ),
                    );
                    Navigator.of(context).pop(); // Dialogu kapat
                    // Başarılı giriş sonrası yapılacak işlemler
                  } else if (state.loginState == LoginStates.error) {
                    //context.pop(); // Yükleniyor göstergesini kapat
                    // Hata mesajını gösterebilirsiniz
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? 'An error occurred'),
                        backgroundColor: kSuitRed,
                      ),
                    );
                  }
                },
                child: SizedBox(
                  height: 50.h,
                  width: 250.w,
                  child: PrimaryGameButton(
                    buttonColor: kButtonGreen,
                    text: 'LOG IN NOW',
                    icon: Icons.login,
                    onTap: () async {
                      await context.read<LoginCubit>().userLogin(
                            context.read<LoginCubit>().emailController.text,
                            context.read<LoginCubit>().passwordController.text,
                          );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // İptal Butonu (Temaya uygun)
              SizedBox(
                height: 50.h,
                width: 250.w,
                child: PrimaryGameButton(
                  buttonColor: kSuitRed,
                  text: 'CANCEL',
                  icon: Icons.cancel,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
