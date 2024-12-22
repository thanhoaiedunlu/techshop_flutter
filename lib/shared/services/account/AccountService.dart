import 'dart:convert';
import 'package:techshop_flutter/models/CustomerModel.dart';
import 'package:http/http.dart' as http;
import '../../constant/constants.dart';

class AccountService {
  Future<CustomerModel?> getProfile(int id) async {
    final url = Uri.parse('$baseUrl/api/customer/$id');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return CustomerModel.fromJson(data);
    } else {
      return null; // Xử lý lỗi
    }
  }

  // Future<bool> updateProfile(CustomerModel customer) async {
  //   final url = Uri.parse('$baseUrl/api/customer/${customer.id}');
  //   final response = await http.put(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(customer.toMap()),
  //   );
  //
  //   return response.statusCode == 200; // Trả về true nếu cập nhật thành công
  // }
  Future<bool> updateProfile(CustomerModel customer) async {
    // Cấu hình URL với API mới
    final url = Uri.parse('$baseUrl/api/customer/updateByUser/${customer.id}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'}, // Định dạng JSON
        body: json.encode({
          'name': customer.fullname,
          'email': customer.email,
          'phone': customer.phone,
          'password': customer.password,
        }),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

}
