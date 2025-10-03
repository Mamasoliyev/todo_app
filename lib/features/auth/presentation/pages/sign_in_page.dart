import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/style/app_color.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_app/generated/locale_keys.g.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/todo');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.primary, // tashqi fon
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  children: [
                    // Yuqorida App nomi
                    Text(
                      "Todo App",
                      style: TextStyle(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Ramka (oq card)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(22.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(22.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${LocaleKeys.welcome_to.tr()} Todo App",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            LocaleKeys.sign_in_to_continue.tr(),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(height: 28.h),

                          // Email
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.email.tr(),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 18.h),

                          // Password
                          TextField(
                            controller: passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.password.tr(),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 28.h),

                          // Button
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                EmailSignInRequested(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 52),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    LocaleKeys.sign_in.tr(),
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                          ),
                          SizedBox(height: 18.h),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.dont_have_account.tr(),
                                style: TextStyle(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.go("/sign-up");
                                },
                                child: Text(
                                  " ${LocaleKeys.sign_up.tr()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // OR
                          Center(
                            child: Text(
                              LocaleKeys.or.tr(),
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Social buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialButton(
                                "assets/svg/google.svg",
                                () => context.read<AuthBloc>().add(
                                  GoogleSignInRequested(),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              _socialButton(
                                "assets/svg/facebook.svg",
                                () => context.read<AuthBloc>().add(
                                  FacebookSignInRequested(),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              _socialButton(
                                "assets/svg/apple.svg",
                                () => context.read<AuthBloc>().add(
                                  AppleSignInRequested(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _socialButton(String assetPath, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(const CircleBorder()),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        side: WidgetStateProperty.all(BorderSide(color: Colors.grey.shade400)),
      ),
      icon: SvgPicture.asset(assetPath, height: 42.h, width: 42.w),
    );
  }
}
