import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/cart_item.dart';
import '../entities/order.dart' as OrderEntity;
import '../entities/product.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addToCart(Product product, int quantity);
  Future<Either<Failure, void>> updateCartItem(int productId, int quantity);
  Future<Either<Failure, void>> removeFromCart(int productId);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, List<OrderEntity.Order>>> getOrderHistory();
  Future<Either<Failure, OrderEntity.Order>> createOrder(List<CartItem> items, String? deliveryAddress);
}
