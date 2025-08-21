import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  Future<Either<Failure, List<Product>>> call(String category, {int limit = 50}) async {
    return await repository.getProductsByCategory(category, limit: limit);
  }
}
