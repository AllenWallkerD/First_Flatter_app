import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../styles/signinStyles.dart';
import '../../components/continue_button.dart';
import '../../router/app_router.dart';

@RoutePage()
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: Padding(
        padding: SignInStyles.formPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Forgot Password", style: SignInStyles.titleTextStyle),
            SignInStyles.largeSpacing,
            TextField(
              controller: _emailController,
              decoration: SignInStyles.inputDecoration.copyWith(
                hintText: "Enter Email Address",
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SignInStyles.spacing,
            ContinueButton(
              text: "Continue",
              onPressed: () async {
                final email = _emailController.text.trim();
                if (email.isEmpty) {
                  setState(() => _errorMessage = "Please enter your email");
                  return;
                }
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: email,
                  );
                  context.router.push(const ResetPasswordRoute());
                } on FirebaseAuthException catch (e) {
                  setState(() => _errorMessage = e.message);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
