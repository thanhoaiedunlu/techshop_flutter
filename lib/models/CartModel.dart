import 'CartItemModel.dart';

class CartModel {
  final int id;
  final int customerId;
  final double totalPrice;
  final List<CartItemModel> cartItems;

  CartModel({
    required this.id,
    required this.customerId,
    required this.totalPrice,
    required this.cartItems,
  });

  // Factory constructor để tạo CartModel từ JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      customerId: json['customerId'],
      totalPrice: json['totalPrice'].toDouble(),
      // Chuyển đổi thành double nếu cần
      cartItems: (json['cartItems'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
    );
  }

  // Phương thức để chuyển đổi CartModel thành Map (hoặc JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'totalPrice': totalPrice,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
    };
  }

  // Factory constructor để tạo CartModel từ Map (nếu cần dùng)
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'],
      customerId: map['customerId'],
      totalPrice: map['totalPrice'].toDouble(),
      cartItems: (map['cartItems'] as List)
          .map((item) => CartItemModel.fromMap(item))
          .toList(),
    );
  }
}
