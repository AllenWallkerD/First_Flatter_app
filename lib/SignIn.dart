import 'package:flutter/material.dart';
import 'styles/signinStyles.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();

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
            _buildEmailInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Column(
      key: const ValueKey("email"),
      children: [
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: _emailController,
            decoration: SignInStyles.inputDecoration.copyWith(hintText: "Email Address"),
          ),
        ),
        SignInStyles.spacing,
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: SignInStyles.primaryButtonStyle,
            child: const Text("Continue", style: SignInStyles.buttonTextStyle),
          ),
        ),
        SignInStyles.spacing,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account? ", style: SignInStyles.normalTextStyle),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(4),
                child: Text("Create One", style: SignInStyles.linkTextStyle),
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
