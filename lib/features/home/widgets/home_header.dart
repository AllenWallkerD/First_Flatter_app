import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: 'Men',
                icon: const Icon(Icons.keyboard_arrow_down),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                },
                items: <String>['Men', 'Women', 'Kids', 'Unisex']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}
