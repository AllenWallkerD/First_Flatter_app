import 'package:app/api/api_client.dart';
import '../data/models/product_model.dart';

class ProductsResponse {
  final List<ProductModel> products;
  final int currentPage;
  final int totalPages;
  final int totalProducts;
  final bool hasNextPage;
  final bool hasPreviousPage;

  ProductsResponse({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalProducts,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ProductsResponse.empty(int page) => ProductsResponse(
    products: [],
    currentPage: page,
    totalPages: 1,
    totalProducts: 0,
    hasNextPage: false,
    hasPreviousPage: false,
  );
}

class Product {
  final ApiClient apiClient;

  Product({required this.apiClient});

  ProductsResponse _parseProductsResponse(Map<String, dynamic> response, int page) {
    if (response['products'] == null) {
      return ProductsResponse.empty(page);
    }
    final productsJson = List<Map<String, dynamic>>.from(response['products']);
    final products = productsJson.map((json) {
      return ProductModel.fromJson(json);
    }).toList();
    final hasMore = products.length >= 10;
    return ProductsResponse(
      products: products,
      currentPage: page,
      totalPages: hasMore ? page + 1 : page,
      totalProducts: hasMore ? (page * 10) + 1 : products.length,
      hasNextPage: hasMore,
      hasPreviousPage: page > 1,
    );
  }

  Future<List<ProductModel>> getProductsByCategory(String category, {int limit = 50}) async {
    try {
      final response = await apiClient.getProductsByCategory(category, limit: limit);
      final productsResponse = _parseProductsResponse(response, 1);
      return productsResponse.products;
    } catch (e) {
      throw Exception('Failed to load products for category $category: $e');
    }
  }

  Future<ProductsResponse> getAllProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.getProducts(page: page, limit: limit);
      return _parseProductsResponse(response, page);
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<ProductModel>> getNewInProducts({int limit = 10}) async {
    final response = await getAllProducts(page: 1, limit: limit);
    return response.products;
  }
}