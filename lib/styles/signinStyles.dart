import 'package:flutter/material.dart';

class SignInStyles {
  static const EdgeInsets formPadding = EdgeInsets.all(24.0);
  static const SizedBox spacing = SizedBox(height: 12);
  static const SizedBox largeSpacing = SizedBox(height: 50);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 5);
  static const EdgeInsets buttonContentPadding = EdgeInsets.symmetric(horizontal: 20);

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle linkTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  static const TextStyle normalTextStyle = TextStyle(
    fontSize: 12,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle socialButtonTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static final InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    ),
  );

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF8E6CEF),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    padding: const EdgeInsets.symmetric(vertical: 15),
  );

  static final ButtonStyle socialButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[200],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    padding: const EdgeInsets.symmetric(vertical: 15),
  );
}
