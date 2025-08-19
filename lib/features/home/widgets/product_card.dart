import 'package:flutter/material.dart';
import '../../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel item;
  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Image.asset(item.image, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(item.name,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text('\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
