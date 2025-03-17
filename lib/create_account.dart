import 'package:flutter/material.dart';
import 'styles/signinStyles.dart';
import './components/continue_button.dart';
import 'db/user_data.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController  = TextEditingController();
  final TextEditingController _emailController     = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();

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
            const Text("Create Account", style: SignInStyles.titleTextStyle),
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
          decoration: SignInStyles.inputDecoration.copyWith(hintText: "Firstname"),
        ),
        SignInStyles.spacing,

        TextField(
          controller: _lastNameController,
          decoration: SignInStyles.inputDecoration.copyWith(hintText: "Lastname"),
        ),
        SignInStyles.spacing,

        TextField(
          controller: _emailController,
          decoration: SignInStyles.inputDecoration.copyWith(hintText: "Email Address"),
        ),
        SignInStyles.spacing,

        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: SignInStyles.inputDecoration.copyWith(hintText: "Password"),
        ),
        SignInStyles.spacing,

        if (_errorMessage != null)
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

        ContinueButton(
          text: "Continue",
          onPressed: () {
            _createAccount();
          },
        ),
        SignInStyles.spacing,
      ],
    );
  }

  void _createAccount() {
    final firstName = _firstNameController.text.trim();
    final lastName  = _lastNameController.text.trim();
    final email     = _emailController.text.trim();
    final password  = _passwordController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      setState(() => _errorMessage = "All fields are required");
      return;
    }

    if (userDatabase.containsKey(email)) {
      setState(() => _errorMessage = "User already exists. Please sign in.");
      return;
    }

    userDatabase[email] = User(
      firstName: firstName,
      lastName: lastName,
      password: password,
    );

    Navigator.pushNamed(context, '/about');
  }
}
