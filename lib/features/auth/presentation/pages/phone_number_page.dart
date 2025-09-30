import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:todo_app/core/style/app_color.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth_bloc.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String countryCode = "+998";

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
      mask: '## ### ## ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PhoneVerificationSentState) {
            context.push("/sms-code", extra: state.verificationId);
          }
          if (state is PhoneVerificationFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 40.h,
              right: 18.w,
              left: 18.w,
              bottom: 48.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 200.h),
                  Text(
                    "ваш номер телефона",
                    style:
                    TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Проверьте код страны и введите свой номер телефона.",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(height: 34.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CountryCodePicker(
                        onChanged: (country) {
                          countryCode = country.dialCode ?? "+998";
                        },
                        initialSelection: 'UZ',
                        favorite: ['+998', 'UZ'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatter],
                          decoration: const InputDecoration(
                            hintText: "-- --- -- --",
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Введите номер телефона.";
                            }
                            if (value.replaceAll(" ", "").length < 9) {
                              return "В номере телефона ошибка.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 200.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            final fullPhone =
                                "$countryCode${phoneNumberController.text.replaceAll(" ", "")}";
                            context
                                .read<AuthBloc>()
                                .add(PhoneSignInRequested(fullPhone));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text("получить смс-код"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
