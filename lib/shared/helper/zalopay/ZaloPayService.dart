import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'CreateOrder.dart';

class ZaloPayService {
  static const MethodChannel _channel = MethodChannel('zalopay_sdk');

  // Gọi thanh toán từ ZaloPay SDK
  static Future<String> payOrder(String token) async {
    try {
      final result = await _channel.invokeMethod('payOrder', {"token": token});
      return result;
    } catch (e) {
      return "Error: $e";
    }
  }

  // Khởi tạo và xử lý thanh toán
  static Future<String> handlePayment(BuildContext context, String amount) async {
    try {
      // Khởi tạo đơn hàng với số tiền truyền vào
      print('da create order');
      final data = await CreateOrder.createOrder(amount);
      if (data['return_code'] == 1) {
        String token = data['zp_trans_token'];
        print("token");
        // Hiển thị thông báo khởi tạo đơn hàng thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Khởi tạo đơn hàng thành công, đang mở ZaloPay...")),
        );
        print("result");
        // Gọi ZaloPay để thanh toán
        final result = await payOrder(token);
        print("result $result");
        return result;
      } else {
        return "Lỗi khi khởi tạo đơn hàng: ${data['return_message']}";
      }
    } catch (e) {
      return "Lỗi thanh toán: $e";
    }
  }
}
