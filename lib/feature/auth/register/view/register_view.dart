import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base_app/feature/auth/login/model/user_model.dart';
import 'package:flutter_base_app/feature/auth/register/cubit/register_cubit.dart';
import 'package:flutter_base_app/feature/auth/register/cubit/register_state.dart';
import 'package:flutter_base_app/feature/auth/register/widget/image_picker.dart';
import 'package:flutter_base_app/product/components/button/primary_game_button.dart';
import 'package:flutter_base_app/product/components/container/gold_nav.dart';
import 'package:flutter_base_app/product/constant/color_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        // color: kTableGreen,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/asset/bg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            Text(
              "Register View",
              style: TextStyle(
                color: kWhiteColor,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            const GoldNavContainer(),
            SizedBox(
              height: 20.h,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: kTableNavy.withOpacity(0.85),
              child: BackButton(color: kWhiteColor, onPressed: () => context.pushReplacement('/login_view')),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: 0.85.sw,
              height: 0.66.sh,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: kWhiteColor.withOpacity(0.8), width: 2),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/asset/bg.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBlackColor.withOpacity(0.7),
                    spreadRadius: 4,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return BlocProvider.value(
                                value: context.read<RegisterCubit>(),
                                child: AlertDialog(
                                  backgroundColor: kTableNavy.withOpacity(0.85),
                                  title: Text(
                                    "Image",
                                    style: TextStyle(color: kWhiteColor, fontSize: 20.sp, fontWeight: FontWeight.bold),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt, color: kWhiteColor, size: 30),
                                        title: Text(
                                          "Camera",
                                          style: TextStyle(
                                              color: kWhiteColor, fontSize: 24.sp, fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () async {
                                          // 📷 Kameradan fotoğraf çek
                                          File? cameraImage = await pickImage(fromCamera: true);
                                          if (cameraImage != null) {
                                            context.read<RegisterCubit>().setImage(cameraImage);
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt, color: kWhiteColor, size: 30),
                                        title: Text(
                                          "Gallery",
                                          style: TextStyle(
                                              color: kWhiteColor, fontSize: 24.sp, fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () async {
                                          // 🖼️ Galeriden seç
                                          File? galleryImage = await pickImage(fromCamera: false);
                                          if (galleryImage != null) {
                                            context.read<RegisterCubit>().setImage(galleryImage);
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          child: state.imageFile != null
                              ? ClipOval(
                                  child: Image.file(
                                    state.imageFile!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: kTableGreen,
                                  child: Icon(
                                    Icons.people_alt_sharp,
                                    color: kWhiteColor,
                                    size: 50,
                                  ),
                                ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      controller: context.read<RegisterCubit>().nameController,
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: kSuitGold,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kTableNavy.withOpacity(0.85), // koyu arka plan
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          color: kLightGrey.withOpacity(0.7),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSuitGold, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kAccentGreen, width: 2.2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kButtonRed, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kButtonRed, width: 2.2),
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: kSuitGold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      controller: context.read<RegisterCubit>().surnameController,
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: kSuitGold,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kTableNavy.withOpacity(0.85), // koyu arka plan
                        hintText: 'Surname',
                        hintStyle: TextStyle(
                          color: kLightGrey.withOpacity(0.7),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSuitGold, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kAccentGreen, width: 2.2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kButtonRed, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kButtonRed, width: 2.2),
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: kSuitGold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      controller: context.read<RegisterCubit>().emailController,
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: kSuitGold,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kTableNavy.withOpacity(0.85), // koyu arka plan
                        hintText: 'E-mail',
                        hintStyle: TextStyle(
                          color: kLightGrey.withOpacity(0.7),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSuitGold, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kAccentGreen, width: 2.2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kButtonRed, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kButtonRed, width: 2.2),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: kSuitGold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return TextFormField(
                          controller: context.read<RegisterCubit>().passwordController,
                          obscureText: state.obscureText,
                          style: const TextStyle(
                            color: kWhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: kSuitGold,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  context.read<RegisterCubit>().changeObscureText();
                                },
                                icon: Icon(state.obscureText ? Icons.remove_red_eye : Icons.remove_red_eye_outlined)),
                            filled: true,
                            fillColor: kTableNavy.withOpacity(0.85), // koyu arka plan
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: kLightGrey.withOpacity(0.7),
                              fontSize: 15,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kSuitGold, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kAccentGreen, width: 2.2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kButtonRed, width: 1.5),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kButtonRed, width: 2.2),
                            ),
                            prefixIcon: const Icon(
                              Icons.password,
                              color: kSuitGold,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    BlocListener<RegisterCubit, RegisterState>(
                      listenWhen: (previous, current) => previous.registerState != current.registerState,
                      listener: (context, state) {
                        if (state.registerState == RegisterStates.completed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message ?? "Kayıt başarılı")),
                          );

                          // 🕑 Navigasyonu biraz geciktir (build tamamlandıktan sonra)
                          Future.microtask(() => context.pushReplacement('/login_view'));
                        } else if (state.registerState == RegisterStates.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)),
                          );
                        }
                      },
                      child: BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          if (state.registerState == RegisterStates.loading) {
                            return const CircularProgressIndicator(color: kSuitGold);
                          }

                          return PrimaryGameButton(
                            buttonColor: Colors.deepOrange,
                            text: 'Save',
                            icon: Icons.save,
                            onTap: () {
                              context.read<RegisterCubit>().insertUser(
                                    UserModel(
                                      id: 0,
                                      name: context.read<RegisterCubit>().nameController.text,
                                      surname: context.read<RegisterCubit>().surnameController.text,
                                      email: context.read<RegisterCubit>().emailController.text,
                                      password: context.read<RegisterCubit>().passwordController.text,
                                    ),
                                    state.imageFile,
                                  );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
