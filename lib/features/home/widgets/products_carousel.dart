import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import 'package:app/components/product_item.dart';

class ProductsCarousel extends StatelessWidget {
  final List<ProductModel> items;
  final double? itemWidth;
  final double? imageHeight;
  final bool showAddButton;
  final double? carouselHeight;

  const ProductsCarousel({
    super.key,
    required this.items,
    this.itemWidth,
    this.imageHeight,
    this.showAddButton = false,
    this.carouselHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final dynamicItemWidth = itemWidth ?? screenWidth * 0.45;
    final dynamicImageHeight = imageHeight ?? dynamicItemWidth * 1.2;

    final double dynamicCarouselHeight = dynamicImageHeight + 100;

    return SizedBox(
      height: dynamicCarouselHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ProductItem(
            product: items[index],
            width: dynamicItemWidth,
            imageHeight: dynamicImageHeight,
            onPressed: () {
              debugPrint('Added ${items[index].title} to cart');
            },
            onFavoritePressed: () {
              debugPrint('Toggled favorite for ${items[index].title}');
            },
          );
        },
      ),
    );
  }
}