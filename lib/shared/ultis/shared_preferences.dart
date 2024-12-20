import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:techshop_flutter/models/CustomerModel.dart';

class SharedPreferencesHelper {
  // Lưu thông tin người dùng
  static Future<void> saveUserData(CustomerModel customer) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = json.encode(customer.toMap());
    await prefs.setString('user_data', userJson);
  }
  // Lấy thông tin người dùng
  static Future<CustomerModel?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_data');
    if (userJson != null) {
      return CustomerModel.fromMap(json.decode(userJson));
    }
    return null;  // Không có dữ liệu
  }
  // Xóa thông tin người dùng
  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }
  // Kiểm tra xem người dùng đã đăng nhập chưa
  static Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_data');
  }
  static Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_data');
    if (userJson != null) {
      final customer = CustomerModel.fromMap(json.decode(userJson));
      return customer.id;
    }
    return null;
  }
}
