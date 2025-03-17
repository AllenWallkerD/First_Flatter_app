import 'package:flutter/material.dart';
import 'styles/signinStyles.dart';
import './components/continue_button.dart';
import './db/user_data.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      body: Padding(
        padding: SignInStyles.formPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/mail.png',
              width: 80,
            ),
            SignInStyles.largeSpacing,
            const Text(
              "We Sent you an Email to reset your password.",
              style: SignInStyles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
            SignInStyles.spacing,

            ContinueButton(
              text: "Return to Login",
              width: 160,
              onPressed: () {
                Navigator.pushNamed(context, '/signIn');
              },
            ),
          ],
        ),
      ),
    );
  }
}
