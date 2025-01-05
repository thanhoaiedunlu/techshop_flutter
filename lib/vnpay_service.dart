import 'package:flutter/services.dart';

class ZaloPayService {
  static const MethodChannel _channel = MethodChannel('zalopay_sdk');

  static Future<String> payOrder(String token) async {
    try {
      final result = await _channel.invokeMethod('payOrder', {"token": token});
      return result;
    } catch (e) {
      return "Error: $e";
    }
  }
}
