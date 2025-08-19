import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://fakestoreapi.in/api';

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Get all available categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/products/category'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'SUCCESS' && data['categories'] != null) {
          return List<String>.from(data['categories']);
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get products by category with limit
  Future<Map<String, dynamic>> getProductsByCategory(
      String category, {
        int limit = 5,
      }) async {
    try {
      final uri = Uri.parse('$baseUrl/products/category').replace(
        queryParameters: {
          'type': category,
          'limit': limit.toString(),
        },
      );

      final response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'SUCCESS') {
          return data;
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get all products with pagination
  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/products').replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'SUCCESS') {
          return data;
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get top selling products (using general products endpoint)
  Future<Map<String, dynamic>> getTopSellingProducts({
    int page = 1,
    int limit = 10,
  }) async {
    return await getProducts(page: page, limit: limit);
  }

  void dispose() {
    _client.close();
  }
}