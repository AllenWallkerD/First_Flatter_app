import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_profile/user_profile_bloc.dart';
import '../../bloc/user_profile/user_profile_event.dart';
import '../../bloc/user_profile/user_profile_state.dart';
import '../../models/user_model.dart';
import './styles/profile_styles.dart';
import '../../router/app_router.dart';

@RoutePage()
class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileStyles.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoaded) {
              return _buildProfileContent(context, state.userProfile);
            } else if (state is UserProfileError) {
              return _buildErrorState(context, state.message);
            } else {
              return _buildNotSignedInState(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotSignedInState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Profile Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Profile Error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.router.replaceAll([const SignInRoute()]),
              style: ElevatedButton.styleFrom(
                backgroundColor: ProfileStyles.textPrimaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Back to Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile userProfile) {
    return Padding(
      padding: ProfileStyles.screenPadding,
      child: Column(
        children: [
          ProfileStyles.topSpacing,

          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                userProfile.profileImage,
                width: ProfileStyles.profileImageSize,
                height: ProfileStyles.profileImageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: ProfileStyles.profileHeaderDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile.fullName,
                  style: ProfileStyles.nameTextStyle,
                ),
                ProfileStyles.smallSpacing,
                Text(
                  userProfile.email,
                  style: ProfileStyles.emailTextStyle,
                ),
              ],
            ),
          ),

          ProfileStyles.sectionSpacing,

          // Menu Items
          _buildMenuItem(
            title: "Wishlist",
            onTap: () {
              // Navigate to wishlist
              // context.router.push(const WishlistRoute());
            },
          ),

          ProfileStyles.menuSpacing,

          _buildMenuItem(
            title: "Payment",
            onTap: () {
              // Navigate to payment
              // context.router.push(const PaymentRoute());
            },
          ),

          ProfileStyles.menuSpacing,

          _buildMenuItem(
            title: "Support",
            onTap: () {
              // Navigate to support
              // context.router.push(const SupportRoute());
            },
          ),

          const Spacer(),

          // Sign Out Button
          TextButton(
            onPressed: () {
              _showSignOutDialog(context);
            },
            style: ProfileStyles.signOutButtonStyle,
            child: Text(
              "Sign Out",
              style: ProfileStyles.signOutTextStyle,
            ),
          ),

          ProfileStyles.bottomSpacing,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: ProfileStyles.menuItemBorderRadius,
      child: Container(
        padding: ProfileStyles.menuItemPadding,
        decoration: ProfileStyles.menuItemDecoration,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: ProfileStyles.menuItemTextStyle,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: ProfileStyles.chevronColor,
              size: ProfileStyles.chevronSize,
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final userBloc = context.read<UserProfileBloc>();
    final currentUser = userBloc.currentUser;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Sign Out",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          content: Text(
            "Are you sure you want to sign out${currentUser != null ? ', ${currentUser.firstName}' : ''}?",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Clear user profile data when signing out
                context.read<UserProfileBloc>().add(const ClearUserProfile());
                context.router.replaceAll([const SignInRoute()]);
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}