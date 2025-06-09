import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_route/auto_route.dart';
import '../../router/app_router.dart';
import '../../styles/signinStyles.dart';
import '../../components/continue_button.dart';

@RoutePage()
class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
            const Text('Create Account', style: SignInStyles.titleTextStyle),
            SignInStyles.largeSpacing,
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _firstNameController,
          decoration: SignInStyles.inputDecoration.copyWith(hintText: 'Firstname'),
        ),
        SignInStyles.spacing,
        TextField(
          controller: _lastNameController,
          decoration: SignInStyles.inputDecoration.copyWith(hintText: 'Lastname'),
        ),
        SignInStyles.spacing,
        TextField(
          controller: _emailController,
          decoration: SignInStyles.inputDecoration.copyWith(hintText: 'Email Address'),
          keyboardType: TextInputType.emailAddress,
        ),
        SignInStyles.spacing,
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: SignInStyles.inputDecoration.copyWith(hintText: 'Password'),
        ),
        SignInStyles.spacing,
        if (_errorMessage != null)
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        ContinueButton(text: 'Continue', onPressed: _createAccount),
        SignInStyles.spacing,
      ],
    );
  }

  void _createAccount() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      setState(() => _errorMessage = 'All fields are required');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      context.router.push(const AboutRoute());
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = 'Failed to create account: ${e.message}');
    }
  }
}