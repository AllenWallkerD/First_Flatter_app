import 'package:flutter/material.dart';
import 'styles/signinStyles.dart';
import 'components/continue_button.dart';
import 'db/user_data.dart';

class SignInPassword extends StatefulWidget {
  const SignInPassword({super.key});

  @override
  State<SignInPassword> createState() => _SignInPasswordState();
}

class _SignInPasswordState extends State<SignInPassword> {
  final TextEditingController _passwordController = TextEditingController();
  String? email;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String?;
  }

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
            _buildPasswordInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: SignInStyles.inputDecoration.copyWith(
            hintText: "Password",
            errorText: _errorMessage,
          ),
        ),
        SignInStyles.spacing,
        ContinueButton(
          text: "Continue",
          onPressed: () {
            final pwd = _passwordController.text;
            if (pwd.isEmpty) {
              setState(() => _errorMessage = "Please enter your password");
              return;
            }
            if (email == null || !userDatabase.containsKey(email)) {
              setState(() => _errorMessage = "No user found. Please sign up.");
              return;
            }

            final user = userDatabase[email];
            if (user != null && user.password == pwd) {
              Navigator.pushNamed(context, '/home');
            } else {
              setState(() => _errorMessage = "Incorrect password");
            }
          },
        ),
        SignInStyles.spacing,
        Row(
          children: [
            const Text("Forgot Password ? ", style: SignInStyles.normalTextStyle),
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/forgotPassword'),
              child: const Text("Reset", style: SignInStyles.linkTextStyle),
            ),
          ],
        ),
      ],
    );
  }
}
