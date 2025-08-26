import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product.dart';
import '../entities/category.dart';
import '../entities/pagination.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, PaginatedResult<Product>>> getTopSellingProducts(PaginationParams params);
  Future<Either<Failure, List<Product>>> getNewInProducts({int limit = 10});
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category, {int limit = 50});
}
