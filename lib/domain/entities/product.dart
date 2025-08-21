import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final String image;
  final double price;
  final String description;
  final String category;
  final String? brand;
  final String? model;
  final String? color;
  final bool? discount;
  final double? originalPrice;

  const Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    this.brand,
    this.model,
    this.color,
    this.discount,
    this.originalPrice,
  });

  bool get hasDiscount => discount == true && originalPrice != null && originalPrice! > price;

  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        image,
        price,
        description,
        category,
        brand,
        model,
        color,
        discount,
        originalPrice,
      ];
}
