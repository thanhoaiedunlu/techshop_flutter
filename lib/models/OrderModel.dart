import 'dart:convert';
import 'ProductModel.dart';

class OrderDetail {
  final int id;
  final int orderId;
  final ProductModel productResponseDTO;
  final int quantity;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.productResponseDTO,
    required this.quantity,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] ?? 0,
      orderId: json['orderId'] ?? 0,
      productResponseDTO: ProductModel.fromJson(json['productResponseDTO']),
      quantity: json['quantity'] ?? 0,
    );
  }
}

class OrderModel {
  final int id;
  final String address;
  final String numberPhone;
  final String orderDate;
  final String receiver;
  final String status;
  final double totalAmount;
  final int customerId;
  final List<OrderDetail> orderDetails;

  OrderModel({
    required this.id,
    required this.address,
    required this.numberPhone,
    required this.orderDate,
    required this.receiver,
    required this.status,
    required this.totalAmount,
    required this.customerId,
    required this.orderDetails,
  });
  String get derivedOrderName {
    if (orderDetails.isNotEmpty) {
      return orderDetails.first.productResponseDTO.name;
    }
    return 'Không rõ';
  }
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    String decodeUtf8(String? input) {
      if (input == null) return 'Không rõ';
      try {
        return utf8.decode(input.runes.toList());
      } catch (e) {
        return input; // Trả về chuỗi gốc nếu không giải mã được
      }
    }

    return OrderModel(
      id: json['id'] ?? 0,
      address: decodeUtf8(json['address']),
      numberPhone: decodeUtf8(json['numberPhone']),
      orderDate: decodeUtf8(json['orderDate']),
      receiver: decodeUtf8(json['receiver']), // Giải mã UTF-8 cho tên người nhận
      status: decodeUtf8(json['status']),     // Giải mã UTF-8 cho trạng thái
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      customerId: json['customerDTO']?['id'] ?? 0,
      orderDetails: (json['orderDetails'] as List)
          .map((detail) => OrderDetail.fromJson(detail))
          .toList(),
    );

}}
