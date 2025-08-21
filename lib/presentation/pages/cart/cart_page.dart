import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/cart/cart_item_card.dart';
import '../../../router/app_router.dart';

@RoutePage()
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<CartBloc>()..add(const LoadCart()),
      child: const CartView(),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          
          if (state is OrderCreated) {
            _showOrderSuccessDialog(context, state.order.id);
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const LoadingWidget(message: 'Loading your cart...');
          }
          
          if (state is CartError) {
            return ErrorDisplayWidget(
              message: state.message,
            );
          }
          
          if (state is CartLoaded || 
              state is CartOperationSuccess) {
            final items = state is CartLoaded 
                ? state.items 
                : (state as CartOperationSuccess).items;
            final totalAmount = state is CartLoaded 
                ? state.totalAmount 
                : (state as CartOperationSuccess).totalAmount;
            final totalItems = state is CartLoaded 
                ? state.totalItems 
                : (state as CartOperationSuccess).totalItems;
                
            if (items.isEmpty) {
              return EmptyStateWidget(
                title: 'Your Cart is Empty',
                message: 'Looks like you haven\'t added anything to your cart yet. Start shopping to fill it up!',
                imagePath: 'assets/images/cart_empty.png',
                actionText: 'Explore Categories',
                onAction: () => context.router.push(const CategoriesListRoute()),
              );
            }
            
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$totalItems ${totalItems == 1 ? 'Item' : 'Items'}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: \$${totalAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[600],
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.shopping_cart,
                        size: 32,
                        color: Colors.purple[400],
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      return CartItemCard(
                        cartItem: cartItem,
                        onQuantityChanged: (newQuantity) {
                          context.read<CartBloc>().add(
                            UpdateCartItemQuantity(cartItem.product.id, newQuantity),
                          );
                        },
                        onRemove: () {
                          context.read<CartBloc>().add(
                            RemoveProductFromCart(cartItem.product.id),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if ((state is CartLoaded || state is CartOperationSuccess) && 
              _getItems(state).isNotEmpty) {
            final totalAmount = _getTotalAmount(state);
            
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showCheckoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Checkout - \$${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  List _getItems(dynamic state) {
    if (state is CartLoaded) return state.items;
    if (state is CartOperationSuccess) return state.items;
    return [];
  }

  double _getTotalAmount(dynamic state) {
    if (state is CartLoaded) return state.totalAmount;
    if (state is CartOperationSuccess) return state.totalAmount;
    return 0.0;
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CartBloc>().add(const ClearCartEvent());
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    final addressController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your delivery address:'),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: 'Enter delivery address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CartBloc>().add(
                CreateOrderEvent(deliveryAddress: addressController.text.trim()),
              );
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }

  void _showOrderSuccessDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: Colors.green[600],
          size: 64,
        ),
        title: const Text('Order Placed Successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your order #$orderId has been placed successfully.'),
            const SizedBox(height: 16),
            const Text(
              'You can track your order in the Orders section.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.router.push(OrdersPageRoute());
            },
            child: const Text('View Orders'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CartBloc>().add(const LoadCart());
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
