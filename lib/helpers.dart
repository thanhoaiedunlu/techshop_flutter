import 'dart:convert';

import 'package:crypto/crypto.dart';

class Helpers {
  static String getAppTransId() {
    final DateTime now = DateTime.now();
    final String year = now.year.toString().substring(2);
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');
    final String time = now.millisecondsSinceEpoch.toString().substring(7);
    return "$year$month$day$time";
  }

  static String getMac(String key, String input) {
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(input));
    return digest.toString();
  }
}
