import '../../core/network/network_service.dart';
import '../../core/constants/api_constants.dart';
import '../../domain/entities/pagination.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<PaginatedResult<ProductModel>> getTopSellingProducts(PaginationParams params);
  Future<List<ProductModel>> getNewInProducts({int limit = 10});
  Future<List<ProductModel>> getProductsByCategory(String category, {int limit = 50});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final NetworkService networkService;

  ProductRemoteDataSourceImpl({required this.networkService});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await networkService.get<Map<String, dynamic>>(
      ApiConstants.categories,
    );

    if (response['status'] == 'SUCCESS' && response['categories'] != null) {
      final categories = (response['categories'] as List<dynamic>)
          .map((category) => CategoryModel.fromString(category.toString()))
          .toList();
      return categories;
    }

    throw Exception('Failed to load categories: ${response['message'] ?? 'Unknown error'}');
  }

  @override
  Future<PaginatedResult<ProductModel>> getTopSellingProducts(PaginationParams params) async {
    final response = await networkService.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: {
        'page': params.page.toString(),
        'limit': params.limit.toString(),
      },
    );

    if (response['status'] == 'SUCCESS') {
      final products = (response['products'] as List<dynamic>?)
              ?.map((product) => ProductModel.fromJson(product))
              .toList() ??
          [];

      final totalItems = products.length;
      final totalPages = (totalItems / params.limit).ceil();
      
      return PaginatedResult<ProductModel>(
        items: products,
        currentPage: params.page,
        totalPages: totalPages,
        totalItems: totalItems,
        hasNextPage: params.page < totalPages,
        hasPreviousPage: params.page > 1,
      );
    }

    throw Exception('Failed to load top selling products: ${response['message'] ?? 'Unknown error'}');
  }

  @override
  Future<List<ProductModel>> getNewInProducts({int limit = 10}) async {
    final response = await networkService.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: {
        'limit': limit.toString(),
      },
    );

    if (response['status'] == 'SUCCESS') {
      final products = (response['products'] as List<dynamic>?)
              ?.map((product) => ProductModel.fromJson(product))
              .take(limit)
              .toList() ??
          [];
      return products;
    }

    throw Exception('Failed to load new products: ${response['message'] ?? 'Unknown error'}');
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category, {int limit = 50}) async {
    final response = await networkService.get<Map<String, dynamic>>(
      ApiConstants.categories,
      queryParameters: {
        'type': category,
        'limit': limit.toString(),
      },
    );

    if (response['status'] == 'SUCCESS') {
      final products = (response['products'] as List<dynamic>?)
              ?.map((product) => ProductModel.fromJson(product))
              .toList() ??
          [];
      return products;
    }

    throw Exception('Failed to load products for category $category: ${response['message'] ?? 'Unknown error'}');
  }
}
