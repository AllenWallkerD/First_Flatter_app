import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/user_model.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.errorMessage,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(
      success: true,
      data: data,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      success: false,
      errorMessage: message,
      statusCode: statusCode,
    );
  }
}

class UserApiService {
  static const String _baseUrl = 'https://randomuser.me/api/';
  static const Duration _timeout = Duration(seconds: 30);

  final http.Client _client;

  UserApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<ApiResponse<UserProfile>> getRandomUser() async {
    try {
      final uri = Uri.parse(_baseUrl);
      final response = await _client
          .get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(_getErrorMessage(e));
    }
  }

  Future<ApiResponse<List<UserProfile>>> getRandomUsers({int count = 10}) async {
    try {
      final uri = Uri.parse('$_baseUrl?results=$count');
      final response = await _client
          .get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        final List<UserProfile> users = results
            .map((userData) => UserProfile.fromJson(userData))
            .toList();

        return ApiResponse.success(users);
      } else {
        return ApiResponse.error(
          'Failed to fetch users: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(_getErrorMessage(e));
    }
  }

  ApiResponse<UserProfile> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        final userData = data['results']?[0];

        if (userData == null) {
          return ApiResponse.error('No user data found in response');
        }

        final user = UserProfile.fromJson(userData);
        return ApiResponse.success(user);
      } catch (e) {
        return ApiResponse.error('Failed to parse user data: ${e.toString()}');
      }
    } else {
      return ApiResponse.error(
        'API request failed: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('TimeoutException')) {
      return 'Request timeout. Please check your internet connection.';
    } else if (error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    } else if (error.toString().contains('FormatException')) {
      return 'Invalid data format received from server.';
    } else {
      return 'Network error: ${error.toString()}';
    }
  }

  void dispose() {
    _client.close();
  }
}