import 'dart:convert';

import 'package:techshop_flutter/models/ProductModel.dart';
import 'package:techshop_flutter/shared/constant/constants.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<ProductModel>> getProducts() async {
    const uri = '$baseUrl/api/product/list'; // Đường dẫn API
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<ProductModel> products =
            data.map((e) => ProductModel.fromJson(e)).toList();
        return products;
      } else {
        return [];
      }
    } catch (e) {
      return []; // Trả về danh sách rỗng trong trường hợp lỗi
    }
  }
}
