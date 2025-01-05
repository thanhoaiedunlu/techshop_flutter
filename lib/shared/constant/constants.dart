import 'package:flutter/material.dart';

const String baseUrl = "http://192.168.1.189:8080";

class AppColors {
  static const Color primaryColor = Color(0xFFFBFBFB); // Màu cam chính (Shopee)
  static const Color backgroundLightColor = Color(0xFFFDFCFD); // Nền nhạt
  static const Color successColor = Color(0xFF52C41A); // Trạng thái "Đã giao"
  static const Color errorColor = Color(0xFFF5222D); // Trạng thái "Đã hủy"
  static const Color textMutedColor =
      Color(0xFF8C8C8C); // Trạng thái trung tính
  static const Color statusAlDelivered = Color(0xFF2D4ABC); // Màu chữ đậm
  static const Color statusBought = Colors.blue; // Đã mua
  static const Color statusDelivered = Colors.green; // Đã giao
  static const Color statusCancelled = Colors.red; // Đã hủy
  static const Color statusProcessing = Colors.orange; // Đang xử lý
  static const Color statusDefault = Colors.grey; // Mặc định
}

enum OrderStatus {
  PENDING_PAYMENT,
  PENDING,
  SHIPPING,
  DELIVERED,
  CANCELLED;
}

enum PaymentMethod {
  COD, // Thanh toán khi nhận hàng (Cash On Delivery)
  MOMO,
  ZALO_PAY,
  VN_PAY
}
