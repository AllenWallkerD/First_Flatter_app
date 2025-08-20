import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://fakestoreapi.in/api';
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json'
  };

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> _makeRequest(String endpoint, [Map<String, String>? queryParams]) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint').replace(
        queryParameters: queryParams,
      );
      final response = await _client.get(uri, headers: _defaultHeaders);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'SUCCESS') {
          return data;
        }
        throw Exception('API returned unsuccessful status: ${data['status']}');
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  Future<List<String>> getCategories() async {
    final data = await _makeRequest('products/category');
    if (data['categories'] != null) {
      return List<String>.from(data['categories']);
    }
    throw Exception('Categories not found in response');
  }

  Future<Map<String, dynamic>> getProductsByCategory(
      String category, {
        int limit = 50,
      }) async {
    return await _makeRequest('products/category', {
      'type': category,
      'limit': limit.toString(),
    });
  }

  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int limit = 10,
  }) async {
    return await _makeRequest('products', {
      'limit': limit.toString(),
      'page': page.toString(),
    });
  }

  void dispose() {
    _client.close();
  }
}