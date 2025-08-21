import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/cart_item.dart';
import '../entities/order.dart' as OrderEntity;
import '../entities/product.dart';
import '../repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<Either<Failure, List<CartItem>>> call() async {
    return await repository.getCartItems();
  }
}

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<Either<Failure, void>> call(Product product, int quantity) async {
    if (quantity <= 0) {
      return Left(ValidationFailure('Quantity must be greater than 0'));
    }
    return await repository.addToCart(product, quantity);
  }
}

class UpdateCartItem {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  Future<Either<Failure, void>> call(int productId, int quantity) async {
    if (quantity < 0) {
      return Left(ValidationFailure('Quantity cannot be negative'));
    }
    return await repository.updateCartItem(productId, quantity);
  }
}

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<Either<Failure, void>> call(int productId) async {
    return await repository.removeFromCart(productId);
  }
}

class ClearCart {
  final CartRepository repository;

  ClearCart(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearCart();
  }
}

class GetOrderHistory {
  final CartRepository repository;

  GetOrderHistory(this.repository);

  Future<Either<Failure, List<OrderEntity.Order>>> call() async {
    return await repository.getOrderHistory();
  }
}

class CreateOrder {
  final CartRepository repository;

  CreateOrder(this.repository);

  Future<Either<Failure, OrderEntity.Order>> call(List<CartItem> items, String? deliveryAddress) async {
    if (items.isEmpty) {
      return Left(ValidationFailure('Cannot create order with empty cart'));
    }
    return await repository.createOrder(items, deliveryAddress);
  }
}
