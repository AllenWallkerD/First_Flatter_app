import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.image,
    required super.price,
    required super.description,
    required super.category,
    super.brand,
    super.model,
    super.color,
    super.discount,
    super.onSale,
    super.popular,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      price: _parseDouble(json['price']),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'],
      model: json['model'],
      color: json['color'],
      discount: _parseInt(json['discount']),
      onSale: _parseBool(json['onSale']),
      popular: _parseBool(json['popular']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'description': description,
      'category': category,
      'brand': brand,
      'model': model,
      'color': color,
      'discount': discount,
      'onSale': onSale,
      'popular': popular,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      image: product.image,
      price: product.price,
      description: product.description,
      category: product.category,
      brand: product.brand,
      model: product.model,
      color: product.color,
      discount: product.discount,
      onSale: product.onSale,
      popular: product.popular,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
      return int.tryParse(value) != 0;
    }
    return null;
  }
}
