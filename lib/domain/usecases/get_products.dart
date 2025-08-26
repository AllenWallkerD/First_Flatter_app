import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product.dart';
import '../entities/pagination.dart';
import '../repositories/product_repository.dart';

class GetTopSellingProducts {
  final ProductRepository repository;

  GetTopSellingProducts(this.repository);

  Future<Either<Failure, PaginatedResult<Product>>> call(PaginationParams params) async {
    final result = await repository.getTopSellingProducts(params);
    return result;
  }
}

class GetNewInProducts {
  final ProductRepository repository;

  GetNewInProducts(this.repository);

  Future<Either<Failure, List<Product>>> call({int limit = 10}) async {
    final result = await repository.getNewInProducts(limit: limit);
    return result;
  }
}
