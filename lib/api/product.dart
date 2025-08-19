import 'package:app/api/api_client.dart';
import 'package:app/models/product_model.dart';

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
}

class Product {
  final ApiClient apiClient;

  Product({required this.apiClient});

  /// Get products by category
  Future<List<ProductModel>> getProducts(String category, {int limit = 10}) async {
    try {
      final response = await apiClient.getProductsByCategory(category, limit: limit);

      if (response['products'] != null) {
        final productsJson = List<Map<String, dynamic>>.from(response['products']);
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  /// Get top selling products with pagination
  Future<ProductsResponse> getTopSellingProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.getTopSellingProducts(page: page, limit: limit);

      if (response['products'] != null) {
        final productsJson = List<Map<String, dynamic>>.from(response['products']);
        final products = productsJson.map((json) => ProductModel.fromJson(json)).toList();

        // Extract pagination info from response
        final pagination = response['pagination'] ?? {};
        final currentPage = pagination['currentPage'] ?? page;
        final totalPages = pagination['totalPages'] ?? 1;
        final totalProducts = pagination['totalProducts'] ?? products.length;

        return ProductsResponse(
          products: products,
          currentPage: currentPage,
          totalPages: totalPages,
          totalProducts: totalProducts,
          hasNextPage: currentPage < totalPages,
          hasPreviousPage: currentPage > 1,
        );
      }

      return ProductsResponse(
        products: [],
        currentPage: page,
        totalPages: 1,
        totalProducts: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      );
    } catch (e) {
      throw Exception('Failed to load top selling products: $e');
    }
  }

  /// Get all products with pagination (for main page)
  Future<ProductsResponse> getAllProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.getProducts(page: page, limit: limit);

      if (response['products'] != null) {
        final productsJson = List<Map<String, dynamic>>.from(response['products']);
        final products = productsJson.map((json) => ProductModel.fromJson(json)).toList();

        // Extract pagination info from response
        final pagination = response['pagination'] ?? {};
        final currentPage = pagination['currentPage'] ?? page;
        final totalPages = pagination['totalPages'] ?? 1;
        final totalProducts = pagination['totalProducts'] ?? products.length;

        return ProductsResponse(
          products: products,
          currentPage: currentPage,
          totalPages: totalPages,
          totalProducts: totalProducts,
          hasNextPage: currentPage < totalPages,
          hasPreviousPage: currentPage > 1,
        );
      }

      return ProductsResponse(
        products: [],
        currentPage: page,
        totalPages: 1,
        totalProducts: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      );
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  /// Get new in products (using first page of all products)
  Future<List<ProductModel>> getNewInProducts({int limit = 10}) async {
    try {
      final response = await getAllProducts(page: 1, limit: limit);
      return response.products;
    } catch (e) {
      throw Exception('Failed to load new in products: $e');
    }
  }
}