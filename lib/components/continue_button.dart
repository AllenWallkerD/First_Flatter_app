import 'package:flutter/material.dart';
import '../styles/signinStyles.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;

  const ContinueButton({
    Key? key,
    required this.onPressed,
    this.text = "Continue",
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: SignInStyles.primaryButtonStyle,
        child: Text(
          text,
          style: SignInStyles.buttonTextStyle,
        ),
      ),
    );
  }
}
