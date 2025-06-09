import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../styles/signinStyles.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0), 
          child: Text(
            "Welcome to the Home Page!",
            style: SignInStyles.titleTextStyle,
          ),
        ),
      ),
    );
  }
}
