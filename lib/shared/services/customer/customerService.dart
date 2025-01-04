import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techshop_flutter/models/CustomerModel.dart';
import 'package:techshop_flutter/shared/constant/constants.dart';


class CustomerService {
  // Hàm thêm customer (thêm khách hàng)
  Future<bool> addCustomer({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    final uri = '$baseUrl/api/customer'; // Đường dẫn API
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    final body = json.encode({
      'fullname': fullname, // Tên đầy đủ
      'username': username, // Tên đăng nhập
      'email': email, // Địa chỉ email
      'password': password, // Mật khẩu
      'phone': phone, // Số điện thoại
    });
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 2) {
        // Thành công, trả về true
        return true;
      } else {
        // Thất bại, trả về false
        return false;
      }
    } catch (e) {
      // Xử lý lỗi khi có sự cố kết nối (timeout, không thể kết nối đến API)
      return false;
    }
  }

  Future<CustomerModel?> checkLogin({
    required String username,
    required String password,
  }) async {
    final uri = '$baseUrl/api/customer/login'; // Đường dẫn API để kiểm tra đăng nhập
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    final body = json.encode({
      'username': username, // Tên đăng nhập
      'password': password, // Mật khẩu
    });
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        // Parse dữ liệu từ JSON và trả về đối tượng User
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return CustomerModel.fromJson(responseBody);
      } else {
        // Nếu đăng nhập thất bại, trả về null
        return null;
      }
    } catch (e) {
      // Xử lý lỗi khi có sự cố kết nối
      return null;
    }
  }
  Future<List<CustomerModel>> getCustomers() async {
    final String apiUrl = '$baseUrl/api/customer/list';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> customerJson = json.decode(response.body);
        return customerJson.map((json) => CustomerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<void> deleteCustomer(int customerId) async {
    final uri = '$baseUrl/api/customer/$customerId'; // Đường dẫn API xóa sản phẩm
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Xóa thành công
        print('Customer deleted successfully');
      } else {
        // Lỗi phía server
        throw Exception('Failed to delete customer: ${response.statusCode}');
      }
    } catch (e) {
      // Lỗi kết nối hoặc lỗi khác
      throw Exception('Error deleting customer: $e');
    }
  }

}

