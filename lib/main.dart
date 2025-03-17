import 'package:flutter/material.dart';

// Pages
import 'sign_in.dart';
import 'sign_in_password.dart'; 
import 'about.dart';
import 'create_account.dart';
import 'forgot_password.dart';
import 'reset_password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Sign In',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/signIn',
      routes: {
        '/signIn': (context) => const SignIn(),
        '/signInPassword': (context) => const SignInPassword(),
        '/createAccount': (context) => const CreateAccount(),
        '/forgotPassword': (context) => const ForgotPassword(),
        '/resetPassword': (context) => const ResetPassword(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/signIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Splash.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
