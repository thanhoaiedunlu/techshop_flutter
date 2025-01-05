import 'package:techshop_flutter/models/CartModel.dart';

class UpdateCustomerModel {
  final int id;
  final String fullname;
  final String username;
  final String email;
  final String phone;
  final bool role;
  final int cartId;
  final String password; // Thêm trường password

  UpdateCustomerModel({
    required this.id,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.cartId,
    required this.password, // Thêm trường password vào constructor
  });

  factory UpdateCustomerModel.fromJson(Map<String, dynamic> json) {
    return UpdateCustomerModel(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      cartId: json['cartId'],
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
      'cartId': cartId,
      'password': password, // Thêm trường password vào map
    };
  }

  // Khởi tạo đối tượng User từ Map (dữ liệu JSON)
  factory UpdateCustomerModel.fromMap(Map<String, dynamic> map) {
    return UpdateCustomerModel(
      id: map['id'],
      fullname: map['fullname'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      cartId: map['cartId'],
      password: map['password'] ?? '', // Xử lý trường password nếu không có
    );
  }
}
