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
  final int? discount;
  final bool? onSale;
  final bool? popular;

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
    this.onSale,
    this.popular,
  });

  bool get hasDiscount => discount != null && discount! > 0;

  double get originalPrice {
    if (!hasDiscount) return price;
    return price / (1 - (discount! / 100));
  }

  double get discountPercentage => discount?.toDouble() ?? 0.0;

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
        onSale,
        popular,
      ];
}
