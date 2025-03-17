import 'package:flutter/material.dart';
import 'styles/signinStyles.dart';
import './components/continue_button.dart';
import './db/user_data.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: SignInStyles.formPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Forgot Password", style: SignInStyles.titleTextStyle),
            SignInStyles.largeSpacing,
            _buildEmailField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: SignInStyles.inputDecoration.copyWith(
            hintText: "Enter Email address",
            errorText: _errorMessage,
          ),
        ),
        SignInStyles.spacing,

        ContinueButton(
          text: "Continue",
          onPressed: () {
            final email = _emailController.text.trim();
            if (email.isEmpty) {
              setState(() => _errorMessage = "Please enter your email");
              return;
            }

            if (!userDatabase.containsKey(email)) {
              setState(() => _errorMessage = "No user found with this email");
              return;
            }

            Navigator.pushNamed(context, '/resetPassword', arguments: email);
          },
        ),
      ],
    );
  }
}
