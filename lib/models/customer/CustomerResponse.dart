import 'package:techshop_flutter/models/CartModel.dart';

class CustomerResponse {
  final int id;
  final String fullname;
  final String username;
  final String email;
  final String phone;
  final bool role;
  final CartModel cart;
  final String password; // Thêm trường password

  CustomerResponse({
    required this.id,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.cart,
    required this.password, // Thêm trường password vào constructor
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      cart: json['cart'],
      password: json['password'] ?? '', // Xử lý trường password nếu JSON không có
    );
  }

  // Chuyển đối tượng User thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'cart': cart,
      'password': password, // Thêm trường password vào map
    };
  }

  // Khởi tạo đối tượng User từ Map (dữ liệu JSON)
  factory CustomerResponse.fromMap(Map<String, dynamic> map) {
    return CustomerResponse(
      id: map['id'],
      fullname: map['fullname'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      cart: map['cart'],
      password: map['password'] ?? '', // Xử lý trường password nếu không có
    );
  }
}
