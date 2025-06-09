import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../styles/signinStyles.dart';
import '../../components/continue_button.dart';
import '../../router/app_router.dart';

@RoutePage()
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;

  bool _validateEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: SignInStyles.formPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Sign in", style: SignInStyles.titleTextStyle),
            SignInStyles.largeSpacing,
            TextField(
              controller: _emailController,
              decoration: SignInStyles.inputDecoration.copyWith(
                hintText: "Email Address",
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SignInStyles.spacing,
            ContinueButton(
              text: "Continue",
              onPressed: () {
                final email = _emailController.text.trim();
                if (email.isEmpty || !_validateEmail(email)) {
                  setState(() => _errorMessage = "Please enter a valid email");
                  return;
                }
                // Always navigate—actual “not found” handled on password step
                context.router.push(SignInPasswordRoute(email: email));
              },
            ),
            SignInStyles.spacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ", style: SignInStyles.normalTextStyle),
                InkWell(
                  onTap: () => context.router.push(const CreateAccountRoute()),
                  child: const Text("Create One", style: SignInStyles.linkTextStyle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}