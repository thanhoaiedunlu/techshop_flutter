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
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
    final uri = '$baseUrl/api/product/$productId'; // Đường dẫn API chi tiết sản phẩm
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
        final decodedResponse = utf8.decode(response.bodyBytes);  // Đảm bảo giải mã đúng UTF-8
        final Map<String, dynamic> data = json.decode(decodedResponse);
        return ProductModel.fromJson(data); // Chuyển đổi từ JSON thành ProductModel
      } else {
        throw Exception('Failed to load product detail');
      }
    } catch (e) {
      throw Exception('Error fetching product detail: $e');
    }
  }
  Future<void> deleteProduct(int productId) async {
    final uri = '$baseUrl/api/product/$productId'; // Đường dẫn API xóa sản phẩm
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
        print('Product deleted successfully');
      } else {
        // Lỗi phía server
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      // Lỗi kết nối hoặc lỗi khác
      throw Exception('Error deleting product: $e');
    }
  }

  Future<bool> editProduct(int id,{
    required String name,
    required String img,
    required String price,
    required String categoryName,
    required String detail
  }) async {
    final uri = '$baseUrl/api/product/${id}'; // Đường dẫn API
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    final int? priceInt = int.tryParse(price);
    if (priceInt == null) {
      throw Exception('Giá không hợp lệ: $price'); // Xử lý lỗi nếu không thể chuyển đổi
    }
    final body = json.encode({
      'name': name,
      'img': img,
      'price': priceInt,
      'categoryName': categoryName,
      'detail': detail
    });
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<bool> addProduct({
    required String name,
    required String img,
    required String price,
    required String categoryName,
    required String detail
  }) async {
    final uri = '$baseUrl/api/product'; // Đường dẫn API
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    final int? priceInt = int.tryParse(price);
    if (priceInt == null) {
      throw Exception('Giá không hợp lệ: $price'); // Xử lý lỗi nếu không thể chuyển đổi
    }
    final body = json.encode({
      'name': name,
      'img': img,
      'price': priceInt,
      'categoryName': categoryName,
      'detail': detail
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
        return false;
      }
    } catch (e) {
      return false;
    }
  }


}
