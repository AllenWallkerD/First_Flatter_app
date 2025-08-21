import '../../domain/entities/order.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_item_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    super.deliveryAddress,
    super.deliveredAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
      totalAmount: _parseDouble(json['totalAmount']),
      status: OrderStatus.values.firstWhere(
        (status) => status.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      deliveryAddress: json['deliveryAddress'],
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items
          .map((item) => CartItemModel.fromEntity(item).toJson())
          .toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'deliveredAt': deliveredAt?.toIso8601String(),
    };
  }

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      items: order.items,
      totalAmount: order.totalAmount,
      status: order.status,
      createdAt: order.createdAt,
      deliveryAddress: order.deliveryAddress,
      deliveredAt: order.deliveredAt,
    );
  }

  @override
  OrderModel copyWith({
    String? id,
    List<CartItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    String? deliveryAddress,
    DateTime? deliveredAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
