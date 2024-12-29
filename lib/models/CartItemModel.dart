import 'package:techshop_flutter/models/ProductModel.dart';

class CartItemModel {
  final int id;
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  // Factory constructor để tạo CartItemModel từ JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  // Phương thức để chuyển đổi CartItemModel thành Map (hoặc JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  // Factory constructor để tạo CartItemModel từ Map (nếu cần dùng)
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'],
      product: ProductModel.fromMap(map['product']),
      quantity: map['quantity'],
    );
  }
}
