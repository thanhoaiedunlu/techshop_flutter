import 'dart:convert';

import 'package:techshop_flutter/models/CartModel.dart';
import 'package:techshop_flutter/shared/constant/constants.dart';
import 'package:http/http.dart' as http;

class CartService {
  Future<CartModel?> getCartByUserIsLogin(int id) async {
    final url = Uri.parse('$baseUrl/api/cart/$id');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      return CartModel.fromJson(data);
    } else {
      return null; // Xử lý lỗi
    }
  }

  Future<int?> getQuantityCartItemInCart(int cartId) async {
    final url = Uri.parse('$baseUrl/api/cartItem/quantity/$cartId');
    print(url);
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return int.parse(utf8.decode(response.bodyBytes));
    } else {
      return null; // Xử lý lỗi
    }
  }
}
