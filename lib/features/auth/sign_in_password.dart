import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_route/auto_route.dart';
import '../../styles/signinStyles.dart';
import '../../components/continue_button.dart';
import '../../router/app_router.dart';

@RoutePage()
class SignInPassword extends StatefulWidget {
  final String email;
  const SignInPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<SignInPassword> createState() => _SignInPasswordState();
}

class _SignInPasswordState extends State<SignInPassword> {
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  String _mapErrorCode(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account exists for ${widget.email}';
      case 'wrong-password':
        return 'Incorrect password';
      case 'network-request-failed':
        return 'Network error; please try again';
      default:
        return e.message ?? 'Auth error: ${e.code}';
    }
  }

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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: SignInStyles.formPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Enter Password", style: SignInStyles.titleTextStyle),
                SignInStyles.largeSpacing,
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
                  text: "Sign In",
                  onPressed: () async {
                    final pwd = _passwordController.text.trim();
                    if (pwd.isEmpty) {
                      setState(() => _errorMessage = "Please enter your password");
                      return;
                    }
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: widget.email,
                        password: pwd,
                      );
                      context.router.replace(const HomePageRoute());
                    } on FirebaseAuthException catch (e) {
                      setState(() => _errorMessage = _mapErrorCode(e));
                    }
                  },
                ),
                SignInStyles.spacing,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Forgot Password? ", style: SignInStyles.normalTextStyle),
                    InkWell(
                      onTap: () => context.router.push(const ForgotPasswordRoute()),
                      child: const Text("Reset", style: SignInStyles.linkTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
