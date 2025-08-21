import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_route/auto_route.dart';
import '../../styles/signinStyles.dart';
import '../../components/continue_button.dart';
import '../../router/app_router.dart';
import '../../bloc/user_profile/user_profile_bloc.dart';
import '../../bloc/user_profile/user_profile_event.dart';
import '../../api/user.dart';

@RoutePage()
class SignInPassword extends StatefulWidget {
  final String email;
  const SignInPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<SignInPassword> createState() => _SignInPasswordState();
}

class _SignInPasswordState extends State<SignInPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final UserApiService _userApiService = UserApiService();
  String? _errorMessage;
  bool _isLoading = false;

  String _mapErrorCode(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account exists for ${widget.email}';
      case 'wrong-password':
        return 'Incorrect password';
      case 'network-request-failed':
        return 'Network error; please try again';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return e.message ?? 'Auth error: ${e.code}';
    }
  }

  Future<void> _signInAndLoadProfile() async {
    final pwd = _passwordController.text.trim();
    if (pwd.isEmpty) {
      setState(() => _errorMessage = "Please enter your password");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: pwd,
      );

      final userResult = await _userApiService.getRandomUser();

      if (userResult.success && userResult.data != null) {
        if (mounted) {
          context.read<UserProfileBloc>().add(SetUserProfile(userResult.data!));
                        context.router.replace(const HomePageRoute());
        }
      } else {
        setState(() {
          _errorMessage = "Sign in successful, but failed to load profile: ${userResult.errorMessage ?? 'Unknown error'}";
          _isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _mapErrorCode(e);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Unexpected error: ${e.toString()}";
        _isLoading = false;
      });
    }
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
            const Text("Enter Password", style: SignInStyles.titleTextStyle),
            SignInStyles.largeSpacing,
            TextField(
              controller: _passwordController,
              obscureText: true,
              enabled: !_isLoading,
              decoration: SignInStyles.inputDecoration.copyWith(
                hintText: "Password",
                errorText: _errorMessage,
                suffixIcon: _errorMessage != null
                    ? const Icon(Icons.error_outline, color: Colors.red)
                    : null,
              ),
              onSubmitted: _isLoading ? null : (_) => _signInAndLoadProfile(),
            ),
            SignInStyles.spacing,
            ContinueButton(
              text: "Sign In",
              onPressed: _signInAndLoadProfile,
            ),
            SignInStyles.spacing,
            if (!_isLoading)
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
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _userApiService.dispose();
    super.dispose();
  }
}