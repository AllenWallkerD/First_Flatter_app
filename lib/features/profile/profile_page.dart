import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../api/user.dart';
import '../../models/user_model.dart';
import './styles/profile_styles.dart';
import '../../router/app_router.dart';

@RoutePage()
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final UserApiService _userApiService;
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _userApiService = UserApiService();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _userApiService.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _userApiService.getRandomUser();

    setState(() {
      _isLoading = false;
      if (result.success) {
        _userProfile = result.data;
        _errorMessage = null;
      } else {
        _errorMessage = result.errorMessage;
        _userProfile = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileStyles.backgroundColor,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage != null
            ? _buildErrorState()
            : _buildProfileContent(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ProfileStyles.textPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchUserProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ProfileStyles.textPrimaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_userProfile == null) return const SizedBox.shrink();

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
                _userProfile!.profileImage,
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
                  _userProfile!.fullName,
                  style: ProfileStyles.nameTextStyle,
                ),
                ProfileStyles.smallSpacing,
                Text(
                  _userProfile!.email,
                  style: ProfileStyles.emailTextStyle,
                ),
              ],
            ),
          ),

          ProfileStyles.sectionSpacing,

          _buildMenuItem(
            title: "Wishlist",
            onTap: () {},
          ),

          ProfileStyles.menuSpacing,

          _buildMenuItem(
            title: "Payment",
            onTap: () {},
          ),

          ProfileStyles.menuSpacing,

          _buildMenuItem(
            title: "Support",
            onTap: () {},
          ),

          const Spacer(),

          TextButton(
            onPressed: () {
              _showSignOutDialog(context);
            },
            style: ProfileStyles.signOutButtonStyle,
            child: const Text(
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
            const Icon(
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
          content: const Text(
            "Are you sure you want to sign out?",
            style: TextStyle(
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