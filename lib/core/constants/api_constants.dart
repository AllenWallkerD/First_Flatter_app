class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.in/api';
  
  // Endpoints
  static const String products = '/products';
  static const String categories = '/products/category';
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
  
  // Cache duration
  static const Duration cacheTimeout = Duration(minutes: 5);
}
