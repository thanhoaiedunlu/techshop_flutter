import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techshop_flutter/shared/constant/constants.dart';

class PasswordResetService {
  Future<bool> initPasswordReset({required String username}) async {
    final url = Uri.parse('$baseUrl/api/customer/initPasswordReset/$username');
    try {
      final response = await http.post(url);
      return response.statusCode == 200; // Trả về true nếu thành công
    } catch (_) {
      return false; // Trả về false nếu có lỗi
    }
  }

  Future<bool> resetPassword({
    required String username,
    required String resetCode,
    required String newPassword,
  }) async {
    final url = Uri.parse(
        '$baseUrl/api/customer/resetPassword/$username?resetCode=$resetCode&newPassword=$newPassword');

    print('Calling API: $url'); // In URL gọi API

    try {
      final response = await http.post(url);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> changePassword({
    required int customerId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/api/customer/changePassword/$customerId');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });

    print('Calling API: $url'); // In URL gọi API

    try {
      final response = await http.patch(url, headers: headers, body: body);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
