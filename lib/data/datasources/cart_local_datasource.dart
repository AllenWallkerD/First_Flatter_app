import '../../core/storage/local_storage_service.dart';
import '../../core/constants/storage_constants.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> addCartItem(CartItemModel item);
  Future<void> updateCartItem(CartItemModel item);
  Future<void> removeCartItem(int productId);
  Future<void> clearCart();
  Future<List<OrderModel>> getOrderHistory();
  Future<void> saveOrder(OrderModel order);
  Future<String> generateOrderId();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final LocalStorageService storageService;

  CartLocalDataSourceImpl({required this.storageService});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final cartData = storageService.getJsonList(StorageConstants.cartItems);
    if (cartData == null) return [];
    
    return cartData
        .map((item) => CartItemModel.fromJson(item))
        .toList();
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final cartData = items.map((item) => item.toJson()).toList();
    await storageService.setJsonList(StorageConstants.cartItems, cartData);
  }

  @override
  Future<void> addCartItem(CartItemModel item) async {
    final currentItems = await getCartItems();
    
    // Check if item already exists
    final existingIndex = currentItems.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );
    
    if (existingIndex != -1) {
      // Update existing item quantity
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentItems[existingIndex].quantity + item.quantity,
      );
    } else {
      // Add new item
      currentItems.add(item);
    }
    
    await saveCartItems(currentItems);
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    final currentItems = await getCartItems();
    final index = currentItems.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );
    
    if (index != -1) {
      if (item.quantity <= 0) {
        currentItems.removeAt(index);
      } else {
        currentItems[index] = item;
      }
      await saveCartItems(currentItems);
    }
  }

  @override
  Future<void> removeCartItem(int productId) async {
    final currentItems = await getCartItems();
    currentItems.removeWhere((item) => item.product.id == productId);
    await saveCartItems(currentItems);
  }

  @override
  Future<void> clearCart() async {
    await storageService.remove(StorageConstants.cartItems);
  }

  @override
  Future<List<OrderModel>> getOrderHistory() async {
    final ordersData = storageService.getJsonList(StorageConstants.orderHistory);
    if (ordersData == null) return [];
    
    return ordersData
        .map((order) => OrderModel.fromJson(order))
        .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by newest first
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    final currentOrders = await getOrderHistory();
    currentOrders.insert(0, order); // Add to beginning of list
    
    final ordersData = currentOrders.map((order) => order.toJson()).toList();
    await storageService.setJsonList(StorageConstants.orderHistory, ordersData);
  }

  @override
  Future<String> generateOrderId() async {
    final lastOrderId = storageService.getInt(StorageConstants.lastOrderId) ?? 0;
    final newOrderId = lastOrderId + 1;
    await storageService.setInt(StorageConstants.lastOrderId, newOrderId);
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORDER_${newOrderId}_$timestamp';
  }
}
