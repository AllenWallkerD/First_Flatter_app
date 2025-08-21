import 'package:app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cart_empty.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 32),
            const Text(
              'Your Cart is Empty',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                elevation: 3,
              ),
              onPressed: () => context.router.push(const CategoriesListRoute()),
              child: const Text(
                'Explore Categories',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}