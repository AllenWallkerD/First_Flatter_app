import 'package:flutter/material.dart';
import 'styles/signinStyles.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Text(
            "Welcome to the Home Page!",
            style: SignInStyles.titleTextStyle,
          ),
        ),
      ),
    );
  }
}
