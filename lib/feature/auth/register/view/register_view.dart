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

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _RegisterViewState extends State<RegisterView> {
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
            opacity: 0.9,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.85),
              Colors.blueGrey.shade900.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Create Your Player",
                    style: TextStyle(
                      color: kSuitGold,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(color: Colors.black.withOpacity(0.9), blurRadius: 8),
                        Shadow(color: kSuitGold.withOpacity(0.8), blurRadius: 12),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  const GoldNavContainer(),
                  SizedBox(height: 20.h),

                  // Geri Butonu
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: kTableNavy.withOpacity(0.8),
                        child: BackButton(color: kWhiteColor, onPressed: () => context.pushReplacement('/login_view')),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // FORM ALANI
                  Container(
                    width: 0.9.sw,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.75),
                          Colors.blueGrey.shade800.withOpacity(0.65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: kSuitGold.withOpacity(0.8), width: 2),
                      boxShadow: [
                        BoxShadow(color: kSuitGold.withOpacity(0.4), blurRadius: 12, spreadRadius: 2),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                      child: Column(
                        children: [
                          // Profil Fotoğrafı
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
                                          "Select Image",
                                          style:
                                              TextStyle(color: kSuitGold, fontWeight: FontWeight.bold, fontSize: 20.sp),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.camera_alt, color: kWhiteColor),
                                              title:
                                                  Text("Camera", style: TextStyle(color: kWhiteColor, fontSize: 18.sp)),
                                              onTap: () async {
                                                File? cameraImage = await pickImage(fromCamera: true);
                                                if (cameraImage != null) {
                                                  context.read<RegisterCubit>().setImage(cameraImage);
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.photo_library, color: kWhiteColor),
                                              title: Text("Gallery",
                                                  style: TextStyle(color: kWhiteColor, fontSize: 18.sp)),
                                              onTap: () async {
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: kSuitGold, width: 2),
                                    boxShadow: [
                                      BoxShadow(color: kSuitGold.withOpacity(0.5), blurRadius: 10),
                                    ],
                                  ),
                                  child: state.imageFile != null
                                      ? ClipOval(
                                          child: Image.file(
                                            state.imageFile!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const CircleAvatar(
                                          radius: 55,
                                          backgroundColor: kTableGreen,
                                          child: Icon(Icons.people_alt_sharp, color: kWhiteColor, size: 50),
                                        ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 25.h),

                          // AD - SOYAD - MAIL - ŞİFRE ALANLARI
                          _buildTextField(
                            context,
                            controller: context.read<RegisterCubit>().nameController,
                            hintText: 'Name',
                            textInputType: TextInputType.name,
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name cannot be empty';
                              }
                              if (value.trim().length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value.trim())) {
                                return 'Name can only contain letters';
                              }
                              return null; // Geçerli
                            },
                          ),
                          SizedBox(height: 15.h),
                          _buildTextField(
                            context,
                            controller: context.read<RegisterCubit>().surnameController,
                            hintText: 'Surname',
                            textInputType: TextInputType.name,
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Surname cannot be empty';
                              }
                              if (value.trim().length < 2) {
                                return 'Surname must be at least 2 characters';
                              }
                              if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value.trim())) {
                                return 'Surname can only contain letters';
                              }
                              return null; // Geçerli
                            },
                          ),
                          SizedBox(height: 15.h),
                          _buildTextField(
                            context,
                            controller: context.read<RegisterCubit>().emailController,
                            textInputType: TextInputType.emailAddress,
                            hintText: 'E-mail',
                            icon: Icons.email_outlined,
                            validator: (p0) {
                              if (p0 == null || p0.trim().isEmpty) {
                                return 'E-mail cannot be empty';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(p0.trim())) {
                                return 'Invalid e-mail format';
                              }
                              return null; // Geçerli
                            },
                          ),
                          SizedBox(height: 15.h),

                          BlocBuilder<RegisterCubit, RegisterState>(
                            builder: (context, state) {
                              return _buildTextField(
                                context,
                                controller: context.read<RegisterCubit>().passwordController,
                                hintText: 'Password',
                                textInputType: TextInputType.visiblePassword,
                                icon: Icons.lock_outline,
                                obscureText: state.obscureText,
                                validator: (p0) {
                                  if (p0 == null || p0.trim().isEmpty) {
                                    return 'Password cannot be empty';
                                  }
                                  if (p0.trim().length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null; // Geçerli
                                },
                                suffix: IconButton(
                                  icon: Icon(
                                    state.obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: kSuitGold,
                                  ),
                                  onPressed: () => context.read<RegisterCubit>().changeObscureText(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 25.h),

                          // KAYIT BUTONU
                          BlocListener<RegisterCubit, RegisterState>(
                            listenWhen: (prev, curr) => prev.registerState != curr.registerState,
                            listener: (context, state) {
                              if (state.registerState == RegisterStates.completed) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(state.message ?? "Registration successful")));
                                Future.microtask(() => context.pushReplacement('/login_view'));
                              } else if (state.registerState == RegisterStates.error) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                              }
                            },
                            child: BlocBuilder<RegisterCubit, RegisterState>(
                              builder: (context, state) {
                                if (state.registerState == RegisterStates.loading) {
                                  return const CircularProgressIndicator(color: kSuitGold);
                                }
                                return PrimaryGameButton(
                                  buttonColor: Colors.deepOrange,
                                  text: 'Create Account',
                                  icon: Icons.save,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
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
                                    } else if (context.read<RegisterCubit>().state.imageFile == null) {
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            backgroundColor: Colors.black.withOpacity(0.85),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              side: const BorderSide(color: Colors.redAccent, width: 2),
                                            ),
                                            title: const Row(
                                              children: [
                                                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Warning",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: const Text(
                                              "Please select an image. The image field cannot be left blank.",
                                              style: TextStyle(color: Colors.white70, fontSize: 15),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(dialogContext).pop(),
                                                child: const Text(
                                                  "OK",
                                                  style:
                                                      TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            backgroundColor: Colors.black.withOpacity(0.85),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              side: const BorderSide(color: Colors.redAccent, width: 2),
                                            ),
                                            title: const Row(
                                              children: [
                                                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Warning",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: const Text(
                                              "Please fill in all fields correctly.",
                                              style: TextStyle(color: Colors.white70, fontSize: 15),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(dialogContext).pop(),
                                                child: const Text(
                                                  "OK",
                                                  style:
                                                      TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),
                  Text("Already have an account?",
                      style: TextStyle(color: kWhiteColor.withOpacity(0.8), fontSize: 15.sp)),
                  TextButton(
                    onPressed: () => context.pushReplacement('/login_view'),
                    child: Text("Go to Login",
                        style: TextStyle(color: kSuitGold, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
    TextInputType? textInputType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      style: const TextStyle(color: kWhiteColor, fontSize: 16, fontWeight: FontWeight.w500),
      cursorColor: kSuitGold,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: kTableNavy.withOpacity(0.85),
        hintText: hintText,
        hintStyle: TextStyle(color: kLightGrey.withOpacity(0.7), fontSize: 15),
        prefixIcon: Icon(icon, color: kSuitGold),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kSuitGold, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kAccentGreen, width: 2),
        ),
      ),
    );
  }
}
