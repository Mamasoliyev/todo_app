import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth_bloc.dart';

class PhoneSmsCodePage extends StatefulWidget {
  const PhoneSmsCodePage({super.key});

  @override
  State<PhoneSmsCodePage> createState() => _PhoneSmsCodePageState();
}

class _PhoneSmsCodePageState extends State<PhoneSmsCodePage> {
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    final verificationId = GoRouterState.of(context).extra as String;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go("/phone");
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go("/");
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Введите СМС-код.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                ),
                onChanged: (value) {
                  smsCode = value;
                },
              ),
              SizedBox(height: 20.h),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return ElevatedButton(
                    onPressed: isLoading || smsCode.length != 6
                        ? null
                        : () {
                      context.read<AuthBloc>().add(
                        VerifyPhoneCodeRequested(
                          verificationId,
                          smsCode,
                        ),
                      );
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("подтверждать"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
