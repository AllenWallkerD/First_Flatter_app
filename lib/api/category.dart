import 'package:app/api/api_client.dart';
import 'package:app/models/category_model.dart';

class Category {
  final ApiClient apiClient;

  static const Map<String, String> _categoryImages = {
    'tv': 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=300&h=200&fit=crop',
    'audio': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=200&fit=crop',
    'laptop': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=200&fit=crop',
    'mobile': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=200&fit=crop',
    'gaming': 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=300&h=200&fit=crop',
    'appliances': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=200&fit=crop',
  };

  static const String _defaultImage = 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300&h=200&fit=crop';

  Category({required this.apiClient});

  Future<List<CategoryModel>> getCategories() async {
    try {
      final categoryNames = await apiClient.getCategories();
      return categoryNames.map((name) {
        final lowerCaseName = name.toLowerCase();
        return CategoryModel(
          id: lowerCaseName,
          name: _formatCategoryName(name),
          image: _categoryImages[lowerCaseName] ?? _defaultImage,
          slug: lowerCaseName,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  String _formatCategoryName(String name) {
    if (name.isEmpty) return name;
    return '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category, {
        int limit = 50,
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