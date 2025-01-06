import 'dart:convert';

import 'package:techshop_flutter/models/CartItemModel.dart';
import 'package:techshop_flutter/shared/constant/constants.dart';
import 'package:http/http.dart' as http;

class CartItemService {
  Future<bool?> updateQuantityCartItem(int cartItemId, int quantity) async {
    final url = Uri.parse(
        '$baseUrl/api/cartItem/updatequantity/$cartItemId?quantity=$quantity');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Update successful.');
      return true;
    } else {
      print('Server Error: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> deleteCartItem(int cartItemId) async {
    final url = Uri.parse('$baseUrl/api/cartItem/$cartItemId');
    final response =
        await http.delete(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false; // Xử lý lỗi
    }
  }

  Future<bool> addCartItem(int cartId, int productId, int quantity) async {
    final url = Uri.parse('$baseUrl/api/cartItem');
    print(url);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'cartId': cartId, 'productId': productId, 'quantity': quantity}));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false; // Xử lý lỗi
    }
  }

  static Future<bool> deleteCartItemByCartId(int cartId) async {
    final url = Uri.parse('$baseUrl/api/cartItem/cartId/$cartId');

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    // Nếu server trả về HTTP 200, coi như thành công.
    if (response.statusCode == 200) {
      return true;
    } else {
      // Trường hợp còn lại xử lý thất bại
      return false;
    }
  }
}
