import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
  // Đặt baseUrl của API
  final String baseUrl = 'http://192.168.1.180:8080';// Thay đổi URL này thành đúng địa chỉ API của bạn

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
}
