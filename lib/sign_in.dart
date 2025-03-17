import 'package:flutter/material.dart';
import 'styles/signinStyles.dart';
import './components/continue_button.dart';
import './db/user_data.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
            const Text("Sign in", style: SignInStyles.titleTextStyle),
            SignInStyles.largeSpacing,
            _buildEmailInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: SignInStyles.inputDecoration.copyWith(
            hintText: "Email Address",
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
              setState(() => _errorMessage = "Email not found. Create an account");
              return;
            }

            Navigator.pushNamed(context, '/signInPassword', arguments: email);
          },
        ),
        SignInStyles.spacing,

        Row(
          children: [
            const Text("Don't have an account? ", style: SignInStyles.normalTextStyle),
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/createAccount'),
              child: const Text(
                "Create One",
                style: SignInStyles.linkTextStyle,
              ),
            ),
          ],
        ),
        SignInStyles.largeSpacing,
        _buildSocialLoginButtons(),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        _socialButton("Continue With Apple", "assets/images/apple.png"),
        _socialButton("Continue With Google", "assets/images/google.png"),
        _socialButton("Continue With Facebook", "assets/images/facebook.png"),
      ],
    );
  }

  Widget _socialButton(String text, String iconPath) {
    return Padding(
      padding: SignInStyles.buttonPadding,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: SignInStyles.socialButtonStyle,
          child: Padding(
            padding: SignInStyles.buttonContentPadding,
            child: Row(
              children: [
                Image.asset(iconPath, width: 20),
                Expanded(
                  child: Text(
                    text,
                    style: SignInStyles.socialButtonTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}