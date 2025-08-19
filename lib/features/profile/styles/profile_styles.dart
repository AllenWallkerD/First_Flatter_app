import 'package:flutter/material.dart';

class ProfileStyles {

  static const Color backgroundColor = Colors.white;
  static const Color profileCardColor = Color(0xFFF4F4F4);
  static const Color menuItemColor = Color(0xFFF4F4F4);
  static const Color textPrimaryColor = Color(0xFF2C2C2C);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color signOutColor = Color(0xFFFF4444);
  static const Color menuIconColor = Color(0xFF666666);
  static const Color chevronColor = Color(0xFFCCCCCC);

  static const EdgeInsets screenPadding = EdgeInsets.all(20.0);
  static const EdgeInsets profileHeaderPadding = EdgeInsets.all(24.0);
  static const EdgeInsets menuItemPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
  static const EdgeInsets menuItemMargin = EdgeInsets.only(bottom: 8.0);
  static const EdgeInsets signOutButtonPadding = EdgeInsets.symmetric(vertical: 16.0);

  static const SizedBox profileSpacing = SizedBox(height: 16.0);
  static const SizedBox smallSpacing = SizedBox(height: 8.0);
  static const SizedBox sectionSpacing = SizedBox(height: 24.0);
  static const SizedBox menuItemSpacing = SizedBox(width: 16.0);
  static const SizedBox menuSpacing = SizedBox(height: 12.0);
  static const SizedBox topSpacing = SizedBox(height: 40.0);
  static const SizedBox bottomSpacing = SizedBox(height: 40.0);

  static const double profileImageSize = 80.0;
  static const double menuIconSize = 24.0;
  static const double chevronSize = 20.0;

  static const BorderRadius profileCardBorderRadius = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius menuItemBorderRadius = BorderRadius.all(Radius.circular(8.0));

  static BoxDecoration get profileHeaderDecoration => const BoxDecoration(
    color: profileCardColor,
    borderRadius: profileCardBorderRadius,
    boxShadow: [
      BoxShadow(
        color: Colors.black,
      ),
    ],
  );

  static BoxDecoration get profileImageDecoration => BoxDecoration(
    color: Colors.grey[200],
    shape: BoxShape.circle,
    boxShadow: const [
      BoxShadow(
        color: Colors.black,
      ),
    ],
  );

  static BoxDecoration get menuItemDecoration => const BoxDecoration(
    color: menuItemColor,
    borderRadius: menuItemBorderRadius,
    boxShadow: [
      BoxShadow(
        color: Colors.black,
      ),
    ],
  );

  static const TextStyle nameTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle emailTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );

  static const TextStyle menuItemTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  static const TextStyle signOutTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: signOutColor,
  );

  static const TextStyle locationTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );

  static const TextStyle usernameTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
  );

  static ButtonStyle get signOutButtonStyle => TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}