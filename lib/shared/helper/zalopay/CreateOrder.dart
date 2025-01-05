import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'helpers.dart';

class CreateOrder {
  static Future<Map<String, dynamic>> createOrder(String amount) async {
    final String appId = "2553";
    final String macKey = "PcY4iZIKFCIdgZvA6ueMcMHHUbRLYjPL";
    final String url = "https://sb-openapi.zalopay.vn/v2/create";

    final String appTransId = Helpers.getAppTransId();
    final String appTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String embedData = "{}";
    final String items = "[]";
    final String description = "Merchant pay for order #$appTransId";

    final String inputHMac =
        "$appId|$appTransId|Android_Demo|$amount|$appTime|$embedData|$items";
    final String mac = Helpers.getMac(macKey, inputHMac);

    final body = {
      "app_id": appId,
      "app_user": "Android_Demo",
      "app_time": appTime,
      "amount": amount,
      "app_trans_id": appTransId,
      "embed_data": embedData,
      "item": items,
      "bank_code": "zalopayapp",
      "description": description,
      "mac": mac,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print("200");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create order');
    }
  }
}
