import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:techshop_flutter/models/CustomerModel.dart';

class CustomerService {
  // Đặt baseUrl của API
  final String baseUrl = 'http://192.168.0.62:8080';// Thay đổi URL này thành đúng địa chỉ API của bạn

  // Hàm thêm customer (thêm khách hàng)
  Future<bool> addCustomer({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    final uri = '$baseUrl/api/customer';
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'fullname': fullname,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
    });
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<CustomerModel?> checkLogin({
    required String username,
    required String password,
  }) async {
    final uri = '$baseUrl/api/customer/login';
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'username': username,
      'password': password,
    });
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return CustomerModel.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

}

