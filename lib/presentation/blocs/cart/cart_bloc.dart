import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/order.dart' as OrderEntity;
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/cart_usecases.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddProductToCart extends CartEvent {
  final Product product;
  final int quantity;

  const AddProductToCart(this.product, {this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

class UpdateCartItemQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateCartItemQuantity(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class RemoveProductFromCart extends CartEvent {
  final int productId;

  const RemoveProductFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

class CreateOrderEvent extends CartEvent {
  final String? deliveryAddress;

  const CreateOrderEvent({this.deliveryAddress});

  @override
  List<Object?> get props => [deliveryAddress];
}

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalAmount;
  final int totalItems;

  const CartLoaded({
    required this.items,
    required this.totalAmount,
    required this.totalItems,
  });

  @override
  List<Object> get props => [items, totalAmount, totalItems];
}

class CartOperationSuccess extends CartState {
  final String message;
  final List<CartItem> items;
  final double totalAmount;
  final int totalItems;

  const CartOperationSuccess({
    required this.message,
    required this.items,
    required this.totalAmount,
    required this.totalItems,
  });

  @override
  List<Object> get props => [message, items, totalAmount, totalItems];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderCreated extends CartState {
  final OrderEntity.Order order;

  const OrderCreated(this.order);

  @override
  List<Object> get props => [order];
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems getCartItems;
  final AddToCart addToCart;
  final UpdateCartItem updateCartItem;
  final RemoveFromCart removeFromCart;
  final ClearCart clearCart;
  final CreateOrder createOrder;

  CartBloc({
    required this.getCartItems,
    required this.addToCart,
    required this.updateCartItem,
    required this.removeFromCart,
    required this.clearCart,
    required this.createOrder,
  }) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<CreateOrderEvent>(_onCreateOrder);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());

    final result = await getCartItems();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(_createCartLoadedState(items)),
    );
  }

  Future<void> _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) async {
    final result = await addToCart(event.product, event.quantity);
    
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) async {
        final cartResult = await getCartItems();
        cartResult.fold(
          (failure) => emit(CartError(failure.message)),
          (items) => emit(CartOperationSuccess(
            message: '${event.product.title} added to cart',
            items: items,
            totalAmount: _calculateTotal(items),
            totalItems: _calculateTotalItems(items),
          )),
        );
      },
    );
  }

  Future<void> _onUpdateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    final result = await updateCartItem(event.productId, event.quantity);
    
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) async {
        final cartResult = await getCartItems();
        cartResult.fold(
          (failure) => emit(CartError(failure.message)),
          (items) => emit(_createCartLoadedState(items)),
        );
      },
    );
  }

  Future<void> _onRemoveProductFromCart(RemoveProductFromCart event, Emitter<CartState> emit) async {
    final result = await removeFromCart(event.productId);
    
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) async {
        final cartResult = await getCartItems();
        cartResult.fold(
          (failure) => emit(CartError(failure.message)),
          (items) => emit(CartOperationSuccess(
            message: 'Item removed from cart',
            items: items,
            totalAmount: _calculateTotal(items),
            totalItems: _calculateTotalItems(items),
          )),
        );
      },
    );
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    final result = await clearCart();
    
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartLoaded(items: [], totalAmount: 0.0, totalItems: 0)),
    );
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<CartState> emit) async {
    final cartResult = await getCartItems();
    
    await cartResult.fold(
      (failure) async => emit(CartError(failure.message)),
      (items) async {
        if (items.isEmpty) {
          emit(const CartError('Cart is empty'));
          return;
        }

        final result = await createOrder(items, event.deliveryAddress);
        result.fold(
          (failure) => emit(CartError(failure.message)),
          (order) => emit(OrderCreated(order)),
        );
      },
    );
  }

  CartLoaded _createCartLoadedState(List<CartItem> items) {
    return CartLoaded(
      items: items,
      totalAmount: _calculateTotal(items),
      totalItems: _calculateTotalItems(items),
    );
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold<double>(0, (sum, item) => sum + item.totalPrice);
  }

  int _calculateTotalItems(List<CartItem> items) {
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}
