import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Product>>> getTopSellingProducts(PaginationParams params) async {
    try {
      final result = await remoteDataSource.getTopSellingProducts(params);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getNewInProducts({int limit = 10}) async {
    try {
      final products = await remoteDataSource.getNewInProducts(limit: limit);
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category, {int limit = 50}) async {
    try {
      final products = await remoteDataSource.getProductsByCategory(category, limit: limit);
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
