import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../router/app_router.dart';
import '../../../bloc/user_profile/user_profile_bloc.dart';
import '../../../bloc/user_profile/user_profile_state.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String selectedGender = 'Men';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  context.router.push(const ProfileRoute());
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _buildAvatarImage(state),
                  ),
                ),
              );
            },
          ),

          DropdownButton<String>(
            value: selectedGender,
            icon: const Icon(Icons.keyboard_arrow_down),
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedGender = newValue;
                });
              }
            },
            items: <String>['Men', 'Women', 'Kids', 'Unisex']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          InkWell(
            onTap: () {
                                context.router.push(const CartPageRoute());
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(UserProfileState state) {
    if (state is UserProfileLoaded) {
      return Image.network(
        state.userProfile.profileImage,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 40,
            height: 40,
            color: Colors.grey[200],
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 40,
            height: 40,
            color: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 24,
              color: Colors.grey[600],
            ),
          );
        },
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.person,
          size: 24,
          color: Colors.grey[600],
        ),
      );
    }
  }
}