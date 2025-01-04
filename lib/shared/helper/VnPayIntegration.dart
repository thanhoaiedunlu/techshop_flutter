import 'package:flutter/services.dart';

class VnPayIntegration {
  static const MethodChannel _channel = MethodChannel('vnpay_channel');

  static Future<String?> openVnPaySdk({
    required String url,
    required String tmnCode,
    required String scheme,
    required bool isSandbox,
  }) async {
    try {
      final action = await _channel.invokeMethod<String>('openVnPaySdk', {
        'url': url,
        'tmn_code': tmnCode,
        'scheme': scheme,
        'is_sandbox': isSandbox,
      });
      return action; // e.g. "SuccessBackAction", "AppBackAction", ...
    } on PlatformException catch (e) {
      print('Error calling openVnPaySdk: $e');
      return null;
    }
  }
}
