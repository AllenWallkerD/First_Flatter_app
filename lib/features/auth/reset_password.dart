import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../styles/signinStyles.dart';
import '../../components/continue_button.dart';
import '../../router/app_router.dart';

@RoutePage()
class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/mail.png',
                width: 80,
              ),
            ),
            SignInStyles.spacing,
            const Text(
              'We sent you an email to reset your password.',
              style: SignInStyles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
            SignInStyles.spacing,
            ContinueButton(
              text: 'Return to Login',
              width: 160,
              onPressed: () {
                context.router.replace(const SignInRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}
