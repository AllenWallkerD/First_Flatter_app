import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart' as OrderEntity;
import '../../domain/entities/product.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      return Right(cartItems);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, e.code));
    } catch (e) {
      return Left(CacheFailure('Failed to get cart items: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(Product product, int quantity) async {
    try {
      final cartItem = CartItemModel(
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      await localDataSource.addCartItem(cartItem);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, e.code));
    } catch (e) {
      return Left(CacheFailure('Failed to add item to cart: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(int productId, int quantity) async {
    try {
      final currentItems = await localDataSource.getCartItems();
      final itemIndex = currentItems.indexWhere((item) => item.product.id == productId);
      
      if (itemIndex == -1) {
        return Left(ValidationFailure('Item not found in cart'));
      }

      final updatedItem = currentItems[itemIndex].copyWith(quantity: quantity);
      await localDataSource.updateCartItem(updatedItem);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, e.code));
    } catch (e) {
      return Left(CacheFailure('Failed to update cart item: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async {
    try {
      await localDataSource.removeCartItem(productId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, e.code));
    } catch (e) {
      return Left(CacheFailure('Failed to remove item from cart: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, e.code));
    } catch (e) {
      return Left(CacheFailure('Failed to clear cart: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity.Order>>> getOrderHistory() async {
    try {
      final orders = await localDataSource.getOrderHistory();
      return Right(orders);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, e.code));
    } catch (e) {
      return Left(CacheFailure('Failed to get order history: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity.Order>> createOrder(List<CartItem> items, String? deliveryAddress) async {
    try {
      final orderId = await localDataSource.generateOrderId();
      final totalAmount = items.fold<double>(0, (sum, item) => sum + item.totalPrice);
      
      final order = OrderModel(
        id: orderId,
        items: items,
        totalAmount: totalAmount,
        status: OrderEntity.OrderStatus.pending,
        createdAt: DateTime.now(),
        deliveryAddress: deliveryAddress,
      );

      await localDataSource.saveOrder(order);
      await localDataSource.clearCart(); // Clear cart after successful order
      
      return Right(order);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, e.code));
    } catch (e) {
      return Left(CacheFailure('Failed to create order: $e'));
    }
  }
}
