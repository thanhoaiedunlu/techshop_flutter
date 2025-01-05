import 'package:flutter/services.dart';

class ZaloPay {
  static const MethodChannel _channel = MethodChannel('zalopay_sdk');

  static Future<Map<String, dynamic>> payOrder(String zpTransToken) async {
    final result = await _channel.invokeMethod('payOrder', {'zpTransToken': zpTransToken});
    return Map<String, dynamic>.from(result);
  }
}
