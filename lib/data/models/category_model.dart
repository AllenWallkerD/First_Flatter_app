import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.name,
    required super.displayName,
    super.description,
    super.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? json['name'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'displayName': displayName,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      name: category.name,
      displayName: category.displayName,
      description: category.description,
      imageUrl: category.imageUrl,
    );
  }

  // Static method to create category from string (for API compatibility)
  factory CategoryModel.fromString(String categoryName) {
    return CategoryModel(
      name: categoryName.toLowerCase(),
      displayName: _formatDisplayName(categoryName),
      description: 'Products in $categoryName category',
      imageUrl: _getCategoryImage(categoryName.toLowerCase()),
    );
  }

  static String _formatDisplayName(String name) {
    return name
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  static String _getCategoryImage(String category) {
    // Map categories to available local images
    const categoryImages = {
      'mobile': 'assets/images/categories/Accessories.png',
      'laptop': 'assets/images/categories/Bag.png',
      'tv': 'assets/images/categories/Hoodies.png',
      'audio': 'assets/images/categories/Shoes.png',
      'gaming': 'assets/images/categories/Shorts.png',
      'appliances': 'assets/images/categories/Accessories.png',
      // Add more mappings as needed
      'electronics': 'assets/images/categories/Accessories.png',
      'clothing': 'assets/images/categories/Hoodies.png',
      'shoes': 'assets/images/categories/Shoes.png',
      'bags': 'assets/images/categories/Bag.png',
    };
    
    return categoryImages[category] ?? 'assets/images/categories/Accessories.png';
  }
}
