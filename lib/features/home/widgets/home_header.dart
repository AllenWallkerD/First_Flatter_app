import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../router/app_router.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String selectedGender = 'Men'; // Track selected gender

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile avatar
          InkWell(
            onTap: () {
              context.router.push(const ProfileRoute());
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
            ),
          ),

          // Gender dropdown
          DropdownButton<String>(
            value: selectedGender,
            icon: const Icon(Icons.keyboard_arrow_down),
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedGender = newValue;
                });
                // You might want to trigger some state management here
                // to update the products based on gender selection
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

          // Cart icon
          InkWell(
            onTap: () {
              context.router.push(const CartRoute());
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
}