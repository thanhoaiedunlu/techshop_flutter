import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:techshop_flutter/models/customer/CustomerModel.dart';
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
  Future<CustomerModel?> loginWithProvider({
    required String providerId,
    required String email,
    required String numberPhone,
    required String fullName,
  }) async {
    final uri = '$baseUrl/api/customer/loginWithProvider'; // Endpoint API
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    final body = json.encode({
      'provider_id': providerId, // ID của nhà cung cấp (Google/Facebook)
      'email': email,           // Email của người dùng
      'numberPhone': numberPhone, // Số điện thoại của người dùng
      'fullName': fullName,     // Họ tên đầy đủ của người dùng
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Parse dữ liệu từ JSON và trả về đối tượng CustomerModel
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return CustomerModel.fromJson(responseBody);
      } else {
        // Xử lý nếu đăng nhập thất bại
        return null;
      }
    } catch (e) {
      // Xử lý lỗi khi có sự cố kết nối
      print('Error during loginWithProvider: $e');
      return null;
    }
  }
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '506553335061-mgd53m1f73n58mli9bcf4pk2818fvign.apps.googleusercontent.com', // Web Client ID
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Future<CustomerModel?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Người dùng hủy đăng nhập Google.');
        return null;
      }

      final String providerId = googleUser.id;
      final String email = googleUser.email;
      final String fullName = googleUser.displayName ?? '';
      final String url = '$baseUrl/api/customer/loginWithProvider';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'provider_id': providerId,
          'email': email,
          'fullName': fullName,
          'numberPhone': '', // Có thể thêm nếu cần
        }),
      );

      if (response.statusCode == 200) {
        await _googleSignIn.disconnect();
        final Map<String, dynamic> responseBody = json.decode(utf8.decode(response.bodyBytes));
        return CustomerModel.fromJson(responseBody);

      } else {
        print('Lỗi từ server: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Đăng nhập Google thất bại: $e');
      return null;
    }
  }
  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
  }


  Future<CustomerModel?> loginWithFacebook() async {
    try {
      // Đăng nhập Facebook
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Lấy dữ liệu người dùng từ Facebook
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200).height(200)",
        );

        final String providerId = userData['id'];
        final String email = userData['email'] ?? '';
        final String fullName = userData['name'] ?? '';
        final String numberPhone = ''; // Số điện thoại nếu cần

        // Gửi thông tin tới backend
        return await _sendFacebookDataToBackend(
          providerId: providerId,
          email: email,
          fullName: fullName,
          numberPhone: numberPhone,
        );
      } else {
        print('Facebook login failed: ${result.message}');
        return null;
      }
    } catch (e) {
      print('Error during Facebook login: $e');
      return null;
    }
  }

  Future<CustomerModel?> _sendFacebookDataToBackend({
    required String providerId,
    required String email,
    required String fullName,
    required String numberPhone,
  }) async {
    final String url = '$baseUrl/api/customer/loginWithProvider';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'provider_id': providerId,
          'email': email,
          'fullName': fullName,
          'numberPhone': numberPhone,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));
        await FacebookAuth.instance.logOut();
        return CustomerModel.fromJson(responseBody);
      } else {
        print('Backend error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending Facebook data to backend: $e');
      return null;
    }
  }



}

