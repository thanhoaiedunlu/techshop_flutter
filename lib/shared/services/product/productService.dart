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

  // Phương thức lấy chi tiết sản phẩm
  Future<ProductModel> getProductDetail(String productId) async {
    final uri =
        '$baseUrl/api/product/$productId'; // Đường dẫn API chi tiết sản phẩm
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Giải mã dữ liệu theo UTF-8
        final decodedResponse =
            utf8.decode(response.bodyBytes); // Đảm bảo giải mã đúng UTF-8
        final Map<String, dynamic> data = json.decode(decodedResponse);
        return ProductModel.fromJson(
            data); // Chuyển đổi từ JSON thành ProductModel
      } else {
        throw Exception('Failed to load product detail');
      }
    } catch (e) {
      throw Exception('Error fetching product detail: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategoryId(int categoryId) async {
    final String uri = '$baseUrl/api/product/list/$categoryId'; // Đường dẫn API
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<ProductModel> products =
            data.map((e) => ProductModel.fromJson(e)).toList();
        return products;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
