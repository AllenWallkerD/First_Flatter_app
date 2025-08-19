import 'package:app/api/api_client.dart';
import 'package:app/models/category_model.dart';

class Category {
  final ApiClient apiClient;

  Category({required this.apiClient});

  /// Get categories with predefined images
  Future<List<CategoryModel>> getCategories() async {
    try {
      final categoryNames = await apiClient.getCategories();

      // Predefined images for categories
      final categoryImages = {
        'mobile': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=200&fit=crop',
        'laptop': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=200&fit=crop',
        'tv': 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=300&h=200&fit=crop',
        'audio': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=200&fit=crop',
        'gaming': 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=300&h=200&fit=crop',
        'appliances': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=200&fit=crop',
        'fashion': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=300&h=200&fit=crop',
        'grocery': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=300&h=200&fit=crop',
        'beauty': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=200&fit=crop',
        'sports': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop',
      };

      // Default image for unknown categories
      const defaultImage = 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300&h=200&fit=crop';

      return categoryNames.map((name) {
        return CategoryModel(
          id: name.toLowerCase(),
          name: _formatCategoryName(name),
          image: categoryImages[name.toLowerCase()] ?? defaultImage,
          slug: name.toLowerCase(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  /// Format category name for display
  String _formatCategoryName(String name) {
    return name.split('').map((char) {
      return char == name[0] ? char.toUpperCase() : char.toLowerCase();
    }).join('');
  }

  /// Get products by category
  Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category, {
        int limit = 10,
      }) async {
    try {
      final response = await apiClient.getProductsByCategory(
        category,
        limit: limit,
      );

      if (response['products'] != null) {
        return List<Map<String, dynamic>>.from(response['products']);
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load products for category $category: $e');
    }
  }
}